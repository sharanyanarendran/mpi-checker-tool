! Limitation: Assumed-shape arrays are not fully modeled and may be treated as dynamic buffers.

program limitation04

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: a(10)

call foo(a)

contains

subroutine foo(x)

  implicit none

  integer :: x(:)

  call mpi_send(x, size(x), MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

end subroutine foo

end