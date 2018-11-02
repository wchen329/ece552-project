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

def partition_test_file(file_path: str):
    ''' create source_code.asm, loadfile_inst.img, loadfile_data.img, dumpfile_data.ans'''
    with open(file_path, "r") as f, \
            open("source_code.asm", 'w') as src_file, \
            open("loadfile_data.img", 'w') as data_file, \
            open("dumpfile_data.ans", 'w') as data_ans:

        current_file = src_file
        data_file_written = False
        data_ans_written = False

        for line in f:
            if line[0:2] == r'//':
                continue
            elif line[0:2] == r'%%':
                if line[3:9] == 'mem_in':
                    current_file = data_file
                    data_file_written = True
                elif line[3:19] == 'expected_mem_out':
                    current_file = data_ans
                    data_ans_written = True
                else:
                    raise Exception("unexpected directive: " + line)
            else:
                current_file.write(line)

        if not data_file_written:
            data_file.write("@0\n")
        if not data_ans_written:
            data_ans.write('=== DUMP ENDS ===\n')

    with open("loadfile_inst.img", 'w') as src_bin:
        src_bin.write("@0\n")
        src_bin.flush()
        retcode = call(['perl', '../wiscasm/assembler.pl', 'source_code.asm'], stdout=src_bin)
        if retcode != 0:
            raise Exception("failed to assemble: " + file_path)

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
    diff_retcode = call(["diff", 'dumpfile_data.img', 'dumpfile_data.ans'])
    if diff_retcode != 0:
        print(Fore.RED+"==> "+"Memory dump mismatch: "+report_dir+Style.RESET_ALL)
    shutil.rmtree(report_dir, ignore_errors=True)
    os.makedirs(report_dir, exist_ok=True)
    for f in ["loadfile_data.img", "loadfile_inst.img",
              "dumpfile_data.ans", "dumpfile_data.img",
              "source_code.asm", "verilogsim.log", "verilogsim.trace", "dump.vcd"]:
        shutil.move(f, report_dir)

def main(argc, argv):
    if argc <= 1:
        print("Usage: ./cpu_tester.py list")
        print("       ./cpu_tester.py <p1|p2> [testName]")
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
        os.system("rm cpu")

if __name__ == "__main__":
    main(len(sys.argv), sys.argv)
