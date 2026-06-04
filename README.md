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

The analyzer currently supports detection of:

* Buffer overflow and count mismatches
* MPI datatype compatibility violations
* Non-contiguous buffer usage
* Send/receive mismatches
* Collective reachability violations
* Collective ordering violations
* Communicator inconsistencies
* Loop-based collective hazards
* Derived type interoperability issues
* MPI optional argument misuse

Diagnostics include:

* Source location information
* Human-readable error descriptions
* Suggested remediation actions

The analyzer can additionally export diagnostics in JSON format for integration with external tooling and IDEs.

---

# Documentation

Detailed project documentation is available in:

* DESIGN.md — System architecture and design decisions
* IMPLEMENTATION.md — Technical implementation details
* EVALUATION.md — Testing methodology, results, limitations, and benchmark evaluation

---

# Repository Structure

```text
mpi-checker-tool/

├── 0001-MPI-checker-implementation-with-rules-and-semantics-.patch

├── README.md
├── DESIGN.md
├── IMPLEMENTATION.md
├── EVALUATION.md

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

## Clone LLVM

```bash
git clone https://github.com/llvm/llvm-project.git

cd llvm-project
```

## Apply the Patch

```bash
git apply 0001-MPI-checker-implementation-with-rules-and-semantics-.patch
```

Verify:

```bash
git status
```

---

# Configure and Build

```bash
mkdir build

cd build

cmake -G Ninja \
  -DLLVM_ENABLE_PROJECTS="flang" \
  ../llvm
```

Build Flang:

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

Diagnostics are produced during semantic analysis.

---

# Running Tests

## Unit Tests

```bash
./build/bin/flang-new \
  -fsyntax-only \
  tests/unit/programs/test03_datatype_mismatch.f90
```

## Integration Tests

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

Refer to EVALUATION.md for a complete description of the test suite and experimental results.

---

