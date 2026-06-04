# IMPLEMENTATION.md

# MPI Semantic Analyzer for LLVM Flang — Implementation Details

## 1. Overview

The implementation extends LLVM Flang's semantic analysis phase with MPI-specific verification capabilities.

The implementation consists of:

* MPICallSite
* MPICallVisitor
* RuleEngine
* Diagnostic Generation
* JSON Export
* VS Code Integration Prototype

---

# 2. Source Files Added

## MPI Call Extraction

flang/include/flang/MPICallSite.h

flang/lib/Semantics/mpi-checker.cpp

## Rule Analysis

flang/lib/Semantics/rule-engine.h

flang/lib/Semantics/rule-engine.cpp

## Flang Integration

flang/lib/Semantics/semantics.cpp

flang/lib/Semantics/CMakeLists.txt

---

# 3. MPICallSite Implementation

MPICallSite stores extracted MPI metadata.

Key fields:

* functionName
* lineNumber
* bufferName
* datatype
* count
* communicator
* tag
* partnerRank
* isCollective
* isContiguous
* isDerivedType
* isInsideLoop

This serves as the internal communication representation.

---

# 4. Parse Tree Visitor Implementation

The MPICallVisitor traverses the Flang parse tree.

Steps:

1. Identify procedure references.
2. Determine whether the procedure is an MPI routine.
3. Extract MPI arguments.
4. Resolve semantic properties.
5. Create MPICallSite objects.

Collected calls are stored in:

std::vector<MPICallSite>

---

# 5. Rule Engine Implementation

The RuleEngine analyzes the collected call sites.

Main entry point:

analyze(std::vector<MPICallSite>& calls)

The function executes all implemented rules.

Generated violations are stored as:

std::vector<MPIError>

---

# 6. Implemented Rules

## Buffer Overflow Rule

Verifies:

count <= buffer size

Detects:

* Static overflow
* Potential dynamic overflow

---

## Datatype Mismatch Rule

Checks compatibility between:

Fortran type

and

MPI datatype

Supported:

* INTEGER
* REAL
* COMPLEX

---

## Non-Contiguous Buffer Rule

Detects array sections with non-unit stride.

Example:

a(1:10:2)

---

## Send/Receive Matching Rule

Verifies:

* Count agreement
* Datatype agreement
* Matching communication pairs

---

## Collective Reachability Rule

Detects collectives inside rank-dependent control flow.

---

## Collective Ordering Rule

Compares collective sequences across branches.

---

## Communicator Consistency Rule

Verifies that all participating ranks use identical communicators.

---

## Derived Type Rule

Checks:

* BIND(C) interoperability
* Layout safety

---

## Optional Argument Rule

Verifies MPI API usage.

Examples:

* Missing status
* Invalid argument count

---

# 7. Suggestion Generation

Each MPIError includes a suggestion field.

Examples:

DatatypeMismatch

Suggestion:

Use MPI_REAL

BufferOverflow

Suggestion:

Reduce count or increase buffer size

The suggestion framework improves usability by providing actionable guidance.

---

# 8. JSON Export Implementation

Diagnostics are converted into MPIDiagnostic objects.

Each diagnostic contains:

* file
* line
* column
* severity
* ruleId
* message
* suggestion

The diagnostics are exported through:

writeDiagnosticsJSON()

Output:

mpi-diagnostics.json

---

# 9. Metrics Framework

Additional MPI usage metrics are computed.

Metrics include:

* Total MPI calls
* Collectives
* Point-to-point operations
* Communicators
* Loop depth
* Derived type usage

These statistics provide insight into communication behavior.

---

# 10. VS Code Extension Implementation

A prototype VS Code extension was developed.

Responsibilities:

* Invoke Flang
* Read diagnostic JSON
* Convert JSON to VS Code diagnostics
* Populate Problems panel
* Display editor annotations

The extension demonstrates practical usability of generated diagnostics.

---

# 11. Build Integration

The new source files are registered through:

flang/lib/Semantics/CMakeLists.txt

and compiled as part of FortranSemantics.

No modifications were required outside the semantic analysis subsystem.

---

# 12. Summary

The implementation successfully embeds MPI-aware static analysis into LLVM Flang while maintaining a modular architecture that supports future extension.
