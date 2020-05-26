import cpu
import pyrtl

import sys, os, traceback
import base64, json
import re

ASSERT_REGEX = re.compile(r'assert\(\s*sim.inspect_mem\((rf|d_mem)\)\[(-?0[xX][0-9a-fA-F]+|-?\d+)\]\s*==\s*(-?0[xX][0-9a-fA-F]+|-?\d+)(?:\s?([&|^])\s*(-?0[xX][0-9a-fA-F]+|-?\d+))?\s*\)')
REGISTER_NAMES = ['zero'] + re.findall('..', 'atv0v1a0a1a2a3t0t1t2t3t4t5t6t7s0s1s2s3s4s5s6s7t8t9k0k1gpspfpra')

def int_or_hex(s):
    '''Convert a decimal or hexadecimal number in a string to an integer.'''
    if s.startswith('0x') or s.startswith('0X'):
        return int(s, 16)
    return int(s)


class DictWatcher(dict):
    '''Allow monitoring of dictionary __getitem__ and __getitem__ calls.'''
    def __init__(self, *args, **kwargs):
        dict.__init__(self, *args, **kwargs)
        self.listeners = {'getitem': set(), 'setitem': set()}

    def __getitem__(self, key):
        exceptions = []
        for fun in self.listeners['getitem']:
            try:
                fun(key)
            except Exception as e:
                traceback.print_exc()
        return dict.__getitem__(self, key)

    def __setitem__(self, key, value):
        old_value = dict.get(self, key)
        dict.__setitem__(self, key, value)

        for fun in self.listeners['setitem']:
            try:
                fun(key, value, old_value)
            except Exception as e:
                traceback.print_exc()

    def add_listener_getitem(self, fun):
        self.listeners['getitem'].add(fun)

    def add_listener_setitem(self, fun):
        self.listeners['setitem'].add(fun)

    def remove_listener_getitem(self, fun):
        self.listeners['getitem'].discard(fun)

    def remove_listener_setitem(self, fun):
        self.listeners['setitem'].discard(fun)




def parse_args(fnames):
    '''Parse test filenames to extract groups of test files.'''
    test_groups = []
    test_names = set()

    for fname in fnames:
        group = None

        # Try to guess the test format from the filename
        base, _ , ext = fname.partition('.')
        if ext not in ('txt', 's'):
            print(f'skipping {fname!r}')
            continue
        if base.endswith('_info'):
            base = base[:-len('_info')]

        inst_file = f'{base}.txt'
        info_txt  = f'{base}_info.txt'
        info_s    = f'{base}_info.s'
        combined  = f'{base}.s'

        isfile = os.path.isfile
        if isfile(inst_file) and (isfile(info_txt) or isfile(info_s)):
            # Two files: one for instructions, one for assembly and assertions
            group = {'multifile': True,
                     'name': base,
                     'inst_file': inst_file,
                     'info_file': info_txt if isfile(info_txt) else info_s}
        elif isfile(combined):
            with open(combined) as f:
                first_line = f.readlines()[0]

            # Check for comment symbol '#' + base64 for '{"' or "{'"
            if first_line.startswith('#eyI') or first_line.startswith('#eyc'):
                group = {'multifile': False,
                         'name': base,
                         'file': combined,
                         'first_line': first_line}
            else:
                print(f'error: single file for {base!r} found, expected base64 dict but got {first_line!r}, skipping test')
                continue

        if group:
            # Avoid duplicates (so that * works as expected)
            if base not in test_names:
                test_names.add(base)
                test_groups.append(group)
        else:
            print(f'error: could not determine test file(s) for {base!r}, skipping test')


    print(f'{len(test_groups)} test{"" if len(test_groups) == 1 else "s"} found.')
    return test_groups


def parse_assertion(stmt):
    match = ASSERT_REGEX.fullmatch(stmt)
    if not match:
        print(f'error: malformed assertion {stmt!r}')
        return {'valid': False,
                'str': stmt}

    mem_block = match.group(1)
    index = int_or_hex(match.group(2))
    value = int_or_hex(match.group(3))

    if match.group(4):
        op = match.group(4)
        other = int_or_hex(match.group(5))
        if op == '&':
            value &= other
        elif op == '|':
            value |= other
        elif op == '^':
            value ^= other
        else:
            print(f'internal error: operation {op!r} not supported')
            exit()

    return {'valid': True,
            'mem_block': mem_block,
            'index': index,
            'value': value,
            'str': stmt}


def read_tests(test_groups):
    '''Read the test files and extract the instructions and assertions.'''
    tests = []
    for group in test_groups:
        # Create the test entry
        test = {'name': group['name']}

        # Unpack the group
        name = group['name']
        multifile = group['multifile']
        inst_file = group.get('inst_file', None)
        info_file = group.get('info_file', group.get('file', None))
        first_line = group.get('first_line', None)
        
        # Read the instructions
        if multifile:
            # Read instructions from a separate file
            with open(inst_file) as f:
                inst_contents = f.readlines()

            # Instructions are encoded as lines of hex words
            try:
                instructions = []
                for line in inst_contents:
                    # Skip over comments
                    if not line.startswith('#'):
                        instructions.append(int('0x' + line, 16))
                test['instructions'] = instructions
            except ValueError:
                print(f'error: could not parse instruction {line!r} in {inst_file}, skipping test')
                continue
            if not instructions:
                print(f'error: no instructions in {inst_file}, skipping test')
                continue

        else:
            # Read instructions from the first line of the test file
            inst_base64 = first_line[1:]
            try:
                inst_bytes = base64.b64decode(inst_base64)
                inst_json = inst_bytes.decode('utf-8')
                inst = json.loads(inst_json)
            except base64.binascii.Error as e:
                print(f'error: could not decode base64 instructions in {info_file}: {e}')
                continue
            except UnicodeError as e:
                print(f'error: Unicode error from instruction JSON in {info_file}: {e}')
                continue
            except json.JSONDecodeError as e:
                print(f'error: could not decode instruction JSON in {info_file}: {e}')
                continue
            
            # Translate JSON dictionary into list of instructions
            instructions = [0] * (max(map(int, inst.keys())) + 1)
            for addr, value in inst.items():
                instructions[int(addr)] = value
            test['instructions'] = instructions


        # Read the assembly/assertion file
        with open(info_file) as f:
            info_contents = f.readlines()

        # Parse the assertions
        assertions = []
        s_lines = [line.strip() for line in info_contents]
        for line in s_lines:
            if line.startswith('#assert(') or line.startswith('assert('):
                assertion = parse_assertion(line.lstrip('#'))
                assertions.append(assertion)

        test['assertions'] = assertions

        # Parse the assembly instructions from the .s file
        assembly = []
        section = None
        offset = 0
        for line in s_lines:
            if line and not line.startswith('#'):
                if line.endswith(':'):
                    section = line[:-1].strip()
                    offset = 0
                elif line.startswith('.'):
                    pass  # Ignore .text
                elif not section:
                    pass  # Necessary due to test2_init.s
                else:
                    assembly.append({'str': line, 'section': section, 'offset': offset})
                    offset += 1

        if len(instructions) != len(assembly):
            print(f'warning: instruction count mismatch for {name}: {len(instructions)} (machine code) != {len(assembly)} (assembly)')

        test['assembly'] = assembly


        # Add extra NOP instruction to catch end of execution for programs without an exit loop
        # addi $zero, $zero, 0
        test['out_of_bounds'] = len(instructions)
        instructions.append(0x20000000)
        assembly.append({'str': 'addi $zero, $zero, 0', 'section': '_out_of_bounds', 'offset': 0})


        tests.append(test)


    if len(tests) == len(test_groups):
        print('All tests loaded.')
    else:
        print(f'{len(tests)} tests loaded.')
        print(f'warning: {len(test_groups) - len(tests)} tests failed to load')
    return tests


def run_test(test):
    test_name = test['name']
    instructions = test['instructions']
    assembly = test['assembly']
    assertions = test['assertions']
    out_of_bounds = test['out_of_bounds']


    # Setup the memory map with initial values and listeners
    inst_map = dict(enumerate(instructions))
    mem_blocks = {'i_mem': cpu.i_mem, 'd_mem': cpu.d_mem, 'rf': cpu.rf}

    mem_map = {}
    mem_updates = {}
    for name, mem in mem_blocks.items():
        mem_updates[name] = []
        mem_map[mem] = DictWatcher(inst_map if name == 'i_mem' else {})
        mem_map[mem].add_listener_setitem((lambda name: lambda *up: mem_updates[name].append(up))(name))

    # Find the pc wire
    block = cpu.i_mem.block
    try:
        pc_wire = cpu.i_mem.readport_nets[0].args[0]
        assert(isinstance(pc_wire, (pyrtl.Register, pyrtl.WireVector)))
    except (AttributeError, IndexError, AssertionError):
        print('error: could not automatically locate pc wire')
        pc_name = input('please enter the name of the pc wire: ')
        while pc_name not in block.wirevector_by_name:
            pc_name = input('wire not found, please try again: ')
        pc_wire = block.wirevector_by_name[pc_name]

    # Setup the simulation
    sim_trace = pyrtl.SimulationTrace()
    sim = pyrtl.Simulation(tracer=sim_trace, memory_value_map=mem_map)
    pc_since_write = set()

    # Run the simulation
    print(f'Running {test_name}')
    try:
        while True:
            try:
                sim.step({})
            except Exception as e:
                # If the circuit raises an exception, render the circuit trace
                sim_trace.render_trace()
                traceback.print_exc()
                exit()

            # Check if the program counter has reached the out-of-bounds instruction
            pc = sim.inspect(pc_wire)
            if pc >= out_of_bounds:
                print('\npc is past last instruction, exiting program')
                if pc > out_of_bounds:
                    print('warning: pc is {pc - out_of_bounds + 1} past last instruction')
                break

            # Print the current program location and instruction
            print(f'\npc: {hex(pc):<8} | {assembly[pc]["section"]} + 0x{assembly[pc]["offset"]:x}')
            print(f'0x{instructions[pc]:08x}   | {assembly[pc]["str"]}')

            # Check for updates to memory blocks
            any_updates = False
            any_writes = False
            for name, updates in mem_updates.items():
                while updates:
                    # Print header on first update
                    if not any_updates:
                        any_updates = True
                        print('Updates:')

                    update = updates.pop(0)
                    addr, value, old = update
                    old = old or 0
                    any_writes = any_writes or value != old

                    # Print update message
                    if name == 'rf':
                        print(f'set ${REGISTER_NAMES[addr]} to 0x{value:x}    (was 0x{old:x})')
                    elif name == 'd_mem':
                        print(f'set memory at (0x{addr:x}) to 0x{value:x} (was 0x{old:x})')
                    if name == 'i_mem':
                        # Circuit should never write to instruction memory
                        print(f'error: write to i_mem detected: i_mem[{update[0]} = {update[1]}')
                        exit()

            # Exit the program once the pc has looped with no memory updates
            if pc in pc_since_write:
                print('\nloop detected, exiting program')
                break
            if any_writes:
                pc_since_write.clear()
            else:
                pc_since_write.add(pc)

    except KeyboardInterrupt:
        print('\nsimulation stopped by user')
        print('warning: assertions may not be accurate')


    # Test assertions
    print('\n\nAssertions:')
    num_passed = 0
    num_valid = 0
    num_total = len(assertions)

    # Evaluate and print results for each assertion
    for assertion in assertions:
        result = None
        value = None
        if not assertion['valid']:
            # Assertion is invalid (could not be parsed), so result is unknown
            result = '!!'
            value = 'BAD ASSERT'
        else:
            # Evaluate assertion
            num_valid += 1
            mem = mem_blocks[assertion['mem_block']]
            assertion_value = assertion['value']
            value = mem_map[mem].get(assertion['index'], 0)

            if value == assertion_value:
                result = 'OK'
                num_passed += 1
            else:
                result = 'X '
            value = hex(value)

        print(f'{result[:2]}  {value[:10]:>10}  {assertion["str"]}')

    # Calculate overall results
    if num_valid == 0:
        if num_total == 0:
            print(f'error: no assertions found for {test_name}')
            print('Please add some assertions!\n')
        else:
            print(f'error: no valid assertions for {test_name}')
            print('Please fix the assertions!\n')
        return
    percentage = (100.0 * num_passed) / num_valid
    num_invalid = num_total - num_valid
    
    # Print summary message
    print(f'\nSummary: passed {num_passed}/{num_valid} = {percentage:.0f}%')
    if num_invalid:
        print(f'warning: {num_invalid} invalid assertion{"" if num_invalid == 1 else "s"} could not be evaluated')
    elif num_passed == num_total:
        print('Congratulations!')
    print()



def main():
    # Check input
    if len(sys.argv) < 2:
        print('usage: python3 tester.py [FILENAME] ...')
        exit()

    # Read the tests
    test_groups = parse_args(sys.argv[1:])
    tests = read_tests(test_groups)
    print('\n')

    # Run the tests
    for test in tests:
        try:
            input('Press Enter to continue, Ctrl-C to exit...')
            print('\n\n\n\n')
            run_test(test)
        except (KeyboardInterrupt, EOFError):
            print()
            exit()

if __name__ == '__main__':
    main()

