# A Shifter and Docker Container Optimized for Cray-MPICH

The Dockerfile builds MPICH and `mpi4py` following these instructions:
https://docs.nersc.gov/development/shifter/how-to-use/#using-mpi-in-shifter

The resulting image allows for Shifter to link `mpi4py` against Cray-MPICH at NERSC.

## Testing

Testing scripts (`opt/tests`) are included in the `PYTHONPATH`, `PATH`:
1. `test_mpi4.py` tests the performance of `mpi4py`. Each rank writes performance data to a `.pkl` file. Optional argumnets are: `bcast` and `gather` to also include `MPI_Bcast` and `MPI_Gather` tests.
2. `print_pkl.py` prints the output of pickled performance data
3. `analyze_mpi4.py` prints performance statistics of the `test_mpi4.py` outputs. Needs to be run from the directory containing the `.pkl` files.
