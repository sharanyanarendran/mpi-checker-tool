program test03
real :: r(5)
call mpi_send(r,5,MPI_INTEGER,1,0,MPI_COMM_WORLD)
end