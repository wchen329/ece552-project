#!/bin/env python3
# -*- coding: utf-8 -*-

from typing import List, Dict
from glob import glob
from subprocess import call
from colorama import Fore, Style
import sys
import re

def list_testbenches() -> Dict[str, List[str]]:
    '''testbenches are modules which has their names end with `_tb`'''
    ret = dict()
    name_matcher = re.compile(r'^\s*module ([a-zA-Z0-9_]+?_tb) *\(', flags=re.MULTILINE)
    for fname in glob('**/*.v', recursive=True):
        with open(fname, 'r') as f:
            content = f.read()
            ret[fname] = name_matcher.findall(content)
    return ret

def list_testbenches_set():
    ret = set()
    name_matcher = re.compile(r'^\s*module ([a-zA-Z0-9_]+?_tb) *\(', flags=re.MULTILINE)
    for fname in glob('**/*.v', recursive=True):
        with open(fname, 'r') as f:
            content = f.read()
            ret.update(name_matcher.findall(content))
    return ret

def run_testbench(tbname: str):
    print(Style.BRIGHT+Fore.GREEN+"==> Running testbench", tbname, "..."+Style.RESET_ALL)
    all_files = glob('../**/*.v', recursive=True)
    compile_cmd = ['iverilog', *all_files, '-Wall', '-s', tbname, '-o', 'a.out']
    compile_retcode = call(compile_cmd)
    if compile_retcode != 0:
        print(Fore.RED+"Compilation Error"+Style.RESET_ALL)
        call(['rm', 'a.out'])
        return
    execute_retcode = call(['./a.out'])
    if execute_retcode != 0:
        print(Fore.RED+"Execution Error"+Style.RESET_ALL)
        call(['rm', 'a.out'])
        return
    call(['rm', 'a.out'])

def main(argc, argv):
    if argc < 2:
        print("./tester.py <list|all|{tbName}>")
    elif argv[1] == 'list':
        for k, v in list_testbenches().items():
            if len(v) > 0:
                print("Testbench(es) in file:", k)
                for s in v:
                    print("    -", s)
        print("+++END+++")
    elif argv[1] == 'all':
        for tbname in list_testbenches_set():
            run_testbench(tbname)
    else:
        tbname = argv[1]
        if tbname not in list_testbenches_set():
            print("No such testbench called", tbname)
        else:
            run_testbench(tbname)

if __name__ == '__main__':
    main(len(sys.argv), sys.argv)
