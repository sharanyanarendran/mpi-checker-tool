program test10

if(rank==0) then
 call mpi_bcast(a,5,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
end if
end