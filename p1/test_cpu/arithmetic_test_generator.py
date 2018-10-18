inst = [
    ('ADD', 1, 5, 6),
    ('ADD', 16384, 16384, 32767),
    ('ADD', -16385, -16384, -32768),
    ('ADD', -100, 100, 0),
    ('SUB', 42, 2, 40),
    ('SUB', 0, -2020, 2020),
    ('SUB', -32768, -32768, 0),
    ('SUB', -3, 32767, -32768),
    ('SUB', 0x0003, 0x8000, 0x7FFF),
    ("XOR", 0xFFFF, 0, 0xFFFF),
    ("XOR", 0, 0xFFFF, 0xFFFF),
    ("XOR", 0xFFFF, 0xFFFF, 0),
    ('RED', 0x7F7F, 0x7F7F, 508),
    ('RED', 0, 0, 0),
    ('RED', 0x8080, 0x8080, 0xFE00),
    ('RED', 0x1234, 0x5678, 276),
    ('SLL', 0xFFFF, 4, 0xFFF0, ''),
    ('SRA', 0x0FFF, 4, 0x00FF, ''),
    ('SRA', 0xF000, 4, 0xFF00, ''),
    ('ROR', 0xABCD, 4, 0xDABC, ''),
    ('PADDSB', 0x1212, 0x2121, 0x3333),
    ('PADDSB', 0x4444, 0x4444, 0x7777),
    ('PADDSB', 0x9999, 0xEEEE, 0x8888),
    ('PADDSB', 0x9999, 0xEEEE, 0x8888),
    ('PADDSB', 0x9ABC, 0xEDCB, 0x8888)
]
i = 0
with open('src/05_arithmetic.asm', 'w') as f:
    for tmp in inst:
        if len(tmp) == 5: # imm
            op, a, b, r, t = tmp
            f.write("# {}({}, {}) = {}\n".format(op, a, b, r))
            f.write("LLB R4, {}\n".format((i*2) & 0xFF))
            f.write("LHB R4, {}\n".format(((i*2)>>8) & 0xFF))
            f.write("LLB R1, {}\n".format(a & 0xFF))
            f.write("LHB R1, {}\n".format((a >> 8) & 0xFF))
            f.write("{} R3, R1, {}\n".format(op, b))
            f.write("SW R3, R4, 0\n")
        else:
            op, a, b, r = tmp
            f.write("# {}({}, {}) = {}\n".format(op, a, b, r))
            f.write("LLB R4, {}\n".format((i*2) & 0xFF))
            f.write("LHB R4, {}\n".format(((i*2)>>8) & 0xFF))
            f.write("LLB R1, {}\n".format(a & 0xFF))
            f.write("LHB R1, {}\n".format((a >> 8) & 0xFF))
            f.write("LLB R2, {}\n".format(b & 0xFF))
            f.write("LHB R2, {}\n".format((b >> 8) & 0xFF))
            f.write("{} R3, R1, R2\n".format(op))
            f.write("SW R3, R4, 0\n")
        i += 1
        f.write("\n")

    f.write("hlt\n")


i = 0
with open('src/05_arithmetic.ans', 'w') as f:
    for tmp in inst:
        if len(tmp) == 5:
            op, a, b, r, t = tmp
        else:
            op, a, b, r = tmp
        if (r == 0):
            i += 1
            continue
        if (r < 0):
            r = (r & 0x7F) + 0x8000
        f.write("{0:04x}: {1:04x}\n".format(i*2, r))
        i += 1
    f.write('=== DUMP ENDS ===\n')
