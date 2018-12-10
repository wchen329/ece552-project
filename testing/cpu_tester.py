#!/bin/env python3
# -*- coding: utf-8 -*-

from typing import List, Dict
from glob import glob
from subprocess import call
from colorama import Fore, Style
from os.path import join as path_join
from datetime import datetime
import sys
import re
import os
import shutil

# in unified memory, code starts from 0x0000, and data starts from 0x1000
def partition_test_file(file_path: str):
    ''' create source_code.asm, loadfile_inst.img, loadfile_data.img, dumpfile_data.ans'''

    parts = dict(source_code="", memory_input="", memory_answer="")
    with open(file_path, "r") as f:
        current_target = "source_code"
        data_file_written = False
        data_ans_written = False

        for line in f:
            if line[0:2] == r'//':
                continue
            elif UNIFIED_MEMORY and line[0:1] == r'@':
                continue
            elif line[0:2] == r'%%':
                if line[3:9] == 'mem_in':
                    current_target = "memory_input"
                    data_file_written = True
                elif line[3:19] == 'expected_mem_out':
                    current_target = "memory_answer"
                    data_ans_written = True
                else:
                    raise Exception("unexpected directive: " + line)
            else:
                parts[current_target] += line

        if not UNIFIED_MEMORY and not data_file_written:
            parts["memory_input"]="@0\n"
        if not UNIFIED_MEMORY and not data_ans_written:
            parts["memory_answer"]='=== DUMP ENDS ===\n'

    if not UNIFIED_MEMORY:
        with open("source_code.asm", 'w') as src_file, \
                open("loadfile_data.img", 'w') as data_file, \
                open("dumpfile_data.ans", 'w') as data_ans:
            src_file.write(parts["source_code"])
            data_file.write(parts["memory_input"])
            data_ans.write(parts["memory_answer"])
        with open("loadfile_inst.img", 'w') as src_bin:
            src_bin.write("@0\n")
            src_bin.flush()
            retcode = call(['perl', '../wiscasm/assembler.pl', 'source_code.asm'], stdout=src_bin)
            if retcode != 0:
                raise Exception("failed to assemble: " + file_path)
    else:
        with open("source_code.asm", 'w') as src_file:
            src_file.write(parts["source_code"])
        with open("loadfile_all.img", 'w') as src_bin:
            src_bin.write("@0\n")
            src_bin.flush()
            retcode = call(['perl', '../wiscasm/assembler.pl', 'source_code.asm'], stdout=src_bin)
            if retcode != 0:
                raise Exception("failed to assemble: " + file_path)
            src_bin.flush()
            src_bin.write("\n@1000\n")
            src_bin.write(parts["memory_input"])

def compile_phase1_cpu():
    all_files = [f for f in glob("../p1/**/*.v", recursive=True) if '/p1/test_' not in f]
    compile_cmd = ['iverilog', *all_files, 'phase1-cpu_tb.v', '-Wall', '-s', 'cpu_tb', '-o', 'cpu']
    compile_retcode = call(compile_cmd)
    if compile_retcode != 0:
        raise Exception("failed to compile phase1 cpu")

def compile_phase2_cpu():
    all_files = [f for f in glob("../p2/**/*.v", recursive=True) if '/p2/testbenches/' not in f]
    compile_cmd = ['iverilog', *all_files, 'phase2-cpu_tb.v', '-Wall', '-s', 'cpu_tb', '-o', 'cpu']
    compile_retcode = call(compile_cmd)
    if compile_retcode != 0:
        raise Exception("failed to compile phase2 cpu")

def compile_phase3_cpu():
    def start_with(s:str, *prefixes:List[str]):
        for prefix in prefixes:
            if s[:len(prefix)] == prefix:
                return True
        return False
    all_files = [f for f in glob("../p3/**/*.v", recursive=True)
                         if not start_with(f, "../p3/manual-dbg/", "../p3/memory/2_cycle_unused/", "../p3/testbenches")]
    compile_cmd = ['iverilog', '-Wall', '-s', 'cpu_ptb', '-o', 'cpu', *all_files, 'phase3-cpu_tb.v']
    print(' '.join(compile_cmd))
    compile_retcode = call(compile_cmd)
    if compile_retcode != 0:
        raise Exception("failed to compile phase3 cpu")

def run_testcase(case_name: str):
    print(Style.BRIGHT+Fore.GREEN+"==> Running testbench:", case_name, "..."+Style.RESET_ALL)
    try:
        partition_test_file(path_join("testcases", case_name+".test"))
        retcode = call(["./cpu"])
        if retcode != 0:
            raise Exception("Execution error on case: " + case_name)
    except Exception as e:
        print(Fore.RED+"==> " + str(e)+Style.RESET_ALL)
    collect_report(case_name)

def collect_report(case_name: str):
    report_dir = path_join("reports", case_name+"_"+str(datetime.now()))
    if os.path.exists("dumpfile_data.ans"):
        diff_retcode = call(["diff", 'dumpfile_data.img', 'dumpfile_data.ans'])
        if diff_retcode != 0:
            print(Fore.RED+"==> "+"Memory dump mismatch: "+report_dir+Style.RESET_ALL)
    else:
        print(Fore.YELLOW+"==> Missing memory answer. Skipping diff"+Style.RESET_ALL)
    shutil.rmtree(report_dir, ignore_errors=True)
    os.makedirs(report_dir, exist_ok=True)
    for f in [                     "source_code.asm"  ,
              "loadfile_data.img", "loadfile_inst.img", "loadfile_all.img",
              "dumpfile_data.img",
              "dumpfile_data.ans",

              "verilogsim.log", "verilogsim.trace", "dump.vcd"]:
        if not os.path.exists(f):
            print(Fore.YELLOW+"==> "+"File to be reported not found: "+f+Style.RESET_ALL)
        else:
            shutil.move(f, report_dir)

def main(argc, argv):
    global UNIFIED_MEMORY
    UNIFIED_MEMORY=False
    if argc <= 1:
        print("Usage: ./cpu_tester.py list")
        print("       ./cpu_tester.py <p1|p2|p3|p3_compile> [testName]")
        return

    test_list = [f[10:-5] for f in glob("testcases/*.test")]
    if argv[1] == 'list':
        for n in test_list:
            print(n)
        print("=== LIST END ===")
    else:
        try:
            if argv[1] == 'p1':
                compile_phase1_cpu()
            elif argv[1] == 'p2':
                compile_phase2_cpu()
            elif argv[1] == 'p3_compile':
                compile_phase3_cpu()
                return
            elif argv[1] == 'p3':
                print("You need to compile p3 manually with `p3_compile` command")
                UNIFIED_MEMORY = True
            else:
                print("Invalid operation:", argv[1])
        except Exception as e:
            print(Fore.RED+"==> " + str(e)+Style.RESET_ALL)
            os.system("rm cpu")
            return
        if argc >= 3:
            if argv[2] in test_list:
                run_testcase(argv[2])
            else:
                print("No such testcase:", argv[2])
        else:
            for c in test_list:
                run_testcase(c)
        # os.system("rm cpu")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)
