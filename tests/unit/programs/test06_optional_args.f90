program test06
integer :: a(5)

call mpi_recv(a,5,MPI_INTEGER,0,0,MPI_COMM_WORLD)
end