# NAS Parallel Benchmark Evaluation

## Overview

To evaluate the applicability of the MPI semantic analyzer on realistic MPI applications, the NAS Parallel Benchmarks (NPB 3.4.4 MPI version) were compiled and executed using OpenMPI 5.0.9 on macOS ARM64. In addition to benchmark execution, selected benchmark source files were analyzed using the modified Flang frontend containing the MPI semantic checker.

## Experimental Setup

* NAS Parallel Benchmarks 3.4.4 (MPI Version)
* OpenMPI 5.0.9
* GNU Fortran (Homebrew GCC 15.2.0)
* Modified LLVM Flang Frontend with MPI Semantic Checker
* 4 MPI Processes
* Benchmark Class S

---

## Benchmark Execution Results

### CG (Conjugate Gradient)

* Processes: 4
* Runtime: 0.02 seconds
* Verification: SUCCESSFUL
* Performance: 4332.96 Mop/s

Observed MPI routines include MPI_Send, MPI_Irecv, MPI_Wait, MPI_Reduce, MPI_Bcast, MPI_Barrier, MPI_Init, and MPI_Finalize.

### EP (Embarrassingly Parallel)

* Processes: 4
* Runtime: 0.05 seconds
* Verification: SUCCESSFUL
* Performance: 682.90 Mop/s

Observed MPI routines include MPI_Allreduce, MPI_Reduce, MPI_Bcast, MPI_Init, and MPI_Finalize.

### MG (Multi-Grid)

* Processes: 4
* Runtime: < 0.01 seconds
* Verification: SUCCESSFUL
* Performance: 9989.72 Mop/s

Observed MPI routines include MPI_Bcast, MPI_Barrier, MPI_Abort, and communication routines used in multigrid computations.

### Summary

| Benchmark | Class | Processes | Verification | Runtime  |
| --------- | ----- | --------- | ------------ | -------- |
| CG        | S     | 4         | SUCCESSFUL   | 0.02 s   |
| EP        | S     | 4         | SUCCESSFUL   | 0.05 s   |
| MG        | S     | 4         | SUCCESSFUL   | < 0.01 s |

The successful execution of all three benchmarks confirms that the evaluation environment supports realistic MPI applications and representative communication patterns.

---

## Static Analysis Using the MPI Checker

Selected NAS benchmark source files were analyzed using the modified Flang frontend containing the MPI semantic analysis framework.

### CG Benchmark

The checker successfully parsed NAS CG source modules and extracted MPI communication calls. Analysis identified MPI_Abort invocations and generated diagnostics related to datatype validation.

### EP Benchmark

The checker successfully extracted MPI collective operations including MPI_Bcast, MPI_Allreduce, and MPI_Reduce. The rule engine generated diagnostics for datatype interpretation and wrapper-detection limitations, demonstrating successful application of the analysis framework to real MPI code.

### MG Benchmark

The checker successfully processed MG benchmark source files and extracted extensive MPI metadata, including communicator usage, datatypes, counts, and collective communication patterns. This benchmark demonstrated the scalability of the extraction framework on a larger code base.

---

## Discussion

The NAS benchmark evaluation demonstrates two complementary aspects of the project:

1. Successful execution of realistic MPI applications using standard NAS benchmark workloads.
2. Successful application of the MPI semantic analysis framework to real-world MPI source code.

The experiments show that the implemented checker operates beyond synthetic unit tests and can analyze communication patterns present in scientific HPC applications. The evaluation also exposed several practical limitations, including MPI argument interpretation challenges and inter-procedural analysis gaps, which provide opportunities for future improvement.
