! Limitation: MPI calls hidden inside wrapper subroutines are not fully analyzed interprocedurally.

program limitation02

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: a(5)

call wrapper_send(a)

contains

subroutine wrapper_send(x)

  integer :: x(5)

  call mpi_send(x, 5, MPI_INTEGER, 1, 0, MPI_COMM_WORLD)

end subroutine wrapper_send

end

