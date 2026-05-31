! Limitation: User-defined MPI datatypes created at runtime cannot be fully validated statically.

program limitation03

implicit none

integer, parameter :: MPI_COMM_WORLD = 0
integer, parameter :: MPI_INTEGER = 1

integer :: ierr
integer :: a(5)
integer :: newtype

call MPI_Type_create_struct( &
     1, &
     (/5/), &
     (/0/), &
     (/MPI_INTEGER/), &
     newtype, ierr)

call mpi_send(a, 1, newtype, 1, 0, MPI_COMM_WORLD)

end