# MPI Semantic Analyzer for LLVM Flang

## Overview

This project extends the LLVM Flang semantic analysis framework with a static MPI semantic analyzer capable of detecting common MPI communication errors directly from Fortran source code.

The analyzer extracts MPI communication semantics from the Flang parse tree and applies a collection of rule-based checks to identify correctness issues involving:

* Buffer sizes
* Datatype compatibility
* Send/receive matching
* Collective communication correctness
* Derived datatype safety
* Communicator consistency
* MPI API misuse

The implementation integrates into Flang's semantic analysis pipeline and produces diagnostics during compilation without requiring program execution.

---

# Features

## Buffer Safety Analysis

Detects:

* Buffer overflow in MPI_Send/MPI_Recv
* Dynamic count usage with fixed-size buffers
* Potential count mismatches

Example:

```fortran
integer :: a(5)

call mpi_send(a, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)
```

Diagnostic:

```text
[MPI ERROR] Buffer count exceeds declared array size
```

---

## Datatype Compatibility Checking

Detects mismatches between:

* INTEGER buffers and MPI_REAL
* REAL buffers and MPI_INTEGER
* COMPLEX buffers and incompatible MPI datatypes

Example:

```fortran
real :: r(10)

call mpi_send(r, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)
```

---

## Send/Receive Matching

Verifies:

* Matching counts
* Matching datatypes
* Matching source/destination ranks
* Matching tags

Example:

```fortran
call mpi_send(a,5,MPI_INTEGER,1,10,MPI_COMM_WORLD)

call mpi_recv(a,10,MPI_INTEGER,0,10,MPI_COMM_WORLD,ierr)
```

Diagnostic:

```text
[MPI ERROR] Send/Recv count mismatch
```

---

## Collective Communication Analysis

Checks:

### Collective Reachability

```fortran
if(rank == 0) then
  call mpi_barrier(MPI_COMM_WORLD,ierr)
end if
```

Diagnostic:

```text
[MPI ERROR] Collective call may not be executed by all ranks
```

---

### Collective Ordering

```fortran
if(rank==0) then
  call mpi_bcast(...)
  call mpi_barrier(...)
else
  call mpi_barrier(...)
  call mpi_bcast(...)
end if
```

Diagnostic:

```text
[MPI ERROR] Collective ordering mismatch
```

---

### Communicator Consistency

```fortran
if(rank==0) then
  call mpi_bcast(...,MPI_COMM_WORLD,...)
else
  call mpi_bcast(...,MPI_COMM_SELF,...)
end if
```

Diagnostic:

```text
[MPI ERROR] Communicator mismatch
```

---

## Loop-Based Collective Analysis

Detects collectives executed inside rank-dependent loops.

Example:

```fortran
do i=1,size
  if(rank==0) then
    call mpi_bcast(...)
  end if
end do
```

Diagnostic:

```text
[MPI ERROR] Collective call inside loop with rank condition
```

---

## Derived Type Validation

Supports Fortran derived types.

Detects:

* Non-BIND(C) derived types used in MPI communication
* Arrays of derived types with implementation-dependent layout

Example:

```fortran
type :: particle
  integer :: id
  real :: mass
end type

call mpi_send(p,4,MPI_BYTE,1,0,MPI_COMM_WORLD)
```

Diagnostic:

```text
[MPI ERROR] Derived type without BIND(C) may be incompatible with MPI
```

---

## Optional Argument Verification

Detects incorrect MPI API usage.

Examples:

```fortran
call mpi_recv(a,5,MPI_INTEGER,0,0,MPI_COMM_WORLD)
```

```fortran
call mpi_send(a,5,MPI_INTEGER,1,0,MPI_COMM_WORLD,ierr)
```

---

# Architecture

The implementation consists of three major components.

## 1. MPI Call Extraction

Files:

```text
flang/lib/Semantics/mpi-checker.cpp
flang/include/flang/MPICallSite.h
```

Responsibilities:

* Detect MPI API calls
* Extract arguments
* Infer datatypes
* Infer communicator usage
* Infer rank conditions
* Record semantic metadata

---

## 2. Rule Engine

Files:

```text
flang/lib/Semantics/rule-engine.cpp
flang/lib/Semantics/rule-engine.h
```

Responsibilities:

* Apply semantic checks
* Generate diagnostics
* Match communication patterns

---

## 3. Flang Integration

Files:

```text
flang/lib/Semantics/semantics.cpp
flang/lib/Semantics/CMakeLists.txt
```

Responsibilities:

* Execute analysis during semantic processing
* Emit diagnostics alongside Flang errors

---

# Repository Structure

```text
mpi-checker-tool/

├── 0001-MPI-checker-implementation-with-rules-and-semantics-.patch

├── tests
│   ├── unit
│   │   ├── programs
│   │   └── outputs
│   │
│   ├── integration
│   │   ├── programs
│   │   └── outputs
│   │
│   └── limitations
│       ├── programs
│       └── outputs
│
└── nas_benchmark_survey.md
```

---

# Applying the Patch

## Step 1: Clone LLVM

```bash
git clone https://github.com/llvm/llvm-project.git

cd llvm-project
```

---

## Step 2: Apply Patch

Copy the patch file into the repository root and run:

```bash
git apply 0001-MPI-checker-implementation-with-rules-and-semantics-.patch
```

Verify:

```bash
git status
```

---

## Step 3: Configure Build

```bash
mkdir build

cd build

cmake -G Ninja \
  -DLLVM_ENABLE_PROJECTS="flang" \
  ../llvm
```

---

## Step 4: Build Flang

```bash
ninja flang-new
```

Executable:

```text
build/bin/flang-new
```

---

# Running the Analyzer

Example:

```bash
./build/bin/flang-new \
  -fsyntax-only \
  test.f90
```

Diagnostics will be printed during semantic analysis.

---

# Running Unit Tests

Example:

```bash
./build/bin/flang-new \
  -fsyntax-only \
  tests/unit/programs/test01_buffer_overflow.f90
```

Repeat similarly for all test programs.

---

# Running Integration Tests

```bash
./build/bin/flang-new \
  -fsyntax-only \
  tests/integration/programs/integration01_full_analysis.f90
```

```bash
./build/bin/flang-new \
  -fsyntax-only \
  tests/integration/programs/integration02_collective_patterns.f90
```

```bash
./build/bin/flang-new \
  -fsyntax-only \
  tests/integration/programs/integration03_datatypes_and_layouts.f90
```

---

# Test Suite

## Unit Tests

20 test programs covering:

* Buffer overflow
* Datatype mismatch
* Send/recv matching
* Optional arguments
* Derived types
* Collective analysis
* Loop analysis
* Communicator consistency

---

## Integration Tests

3 large programs combining multiple rules simultaneously.

---

## Limitation Tests

Demonstrate known limitations including:

* Wrapper detection
* Custom MPI datatypes
* Assumed-shape arrays
* Deep interprocedural analysis
* Complex rank predicates

---

# NAS Benchmark Survey

A source-level evaluation was performed on:

* NAS CG
* NAS MG
* NAS EP

Observed MPI patterns:

* MPI_Send
* MPI_Irecv
* MPI_Wait
* MPI_Bcast
* MPI_Barrier
* MPI_Reduce
* MPI_Allreduce
* MPI_Init
* MPI_Finalize
* MPI_Abort

These communication patterns align with the implemented rule set and demonstrate applicability to real-world MPI applications.

---

# Limitations

Current limitations include:

* Full interprocedural analysis is not implemented.
* Custom MPI datatypes cannot be validated precisely.
* Complex rank predicates are handled conservatively.
* Wrapper functions are reported as potential MPI wrappers.
* Runtime-dependent communicator behavior cannot be fully resolved statically.

---

# Author

Sharanya Narendran

MPI Semantic Analyzer for LLVM Flang
Internship Project
