# MPI Static Checker for Fortran (LLVM Flang)

## Overview
Static analysis tool to detect MPI-related bugs in Fortran programs using LLVM Flang.

## Features
- Buffer overflow detection
- Non-contiguous buffer detection
- Datatype mismatch detection
- Send/recv mismatch detection
- Optional argument misuse
- Derived type validation (BIND(C))
- Derived layout mismatch
- Collective reachability
- Collective ordering

## Files Modified
- flang/... (list your modified files)
- mpi-checker.cpp
- mpi-checker.h
- rule-engine.cpp
- rule-engine.h

## How to Apply Patch

```bash
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git apply 0001-MPI-checker-implementation.patch
