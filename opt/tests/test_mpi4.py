#!/usr/bin/env python
# -*- coding: utf-8 -*-



import sys
import pickle

from util import Timer


#_______________________________________________________________________________
# Parse input arguments
#

test_bcast  = False
test_gather = False

if "bcast" in sys.argv:
    test_bcast = True

if "gather" in sys.argv:
    test_gather = True

#-------------------------------------------------------------------------------


def fn_payload(i):
    return 0.5*i

n_payload = 100


#_______________________________________________________________________________
# Time MPI initialization
#

t = Timer()

from mpi4py import MPI
comm     = MPI.COMM_WORLD
mpi_rank = comm.Get_rank()
mpi_size = comm.Get_size()

duration_init = t.total()

#-------------------------------------------------------------------------------


#_______________________________________________________________________________
# Time MPI Bcast
#

if mpi_rank == 0:
    payload = [fn_payload(i) for i in range(n_payload)]
else:
    payload = None

comm.Barrier()

t = Timer()

if test_bcast:
    payload = comm.bcast(payload, root=0)

duration_bcast = t.total()

# validate results
if test_bcast:
    if mpi_rank != 0:
        assert all(p == fn_payload(i) for i, p in enumerate(payload))

#-------------------------------------------------------------------------------


#_______________________________________________________________________________
# Time MPI Gather
#

payload = [fn_payload(i) for i in range(n_payload)]

comm.Barrier()

t = Timer()

if test_gather:
    all_payloads = comm.gather(payload, root=0)

duration_gather = t.total()

# validate results
if test_gather:
    if mpi_rank == 0:
        for i in range(mpi_size):
            assert all(
                p == fn_payload(j) for j, p in enumerate(all_payloads[i])
            )

#-------------------------------------------------------------------------------



#_______________________________________________________________________________
# Report results
#

report = dict(rank=mpi_rank, size=mpi_size, init=duration_init)

if test_bcast:
    report["bcast"] = duration_bcast

if test_gather:
    report["gather"] = duration_gather

with open(f"report_{mpi_rank}.pkl", "wb") as f:
    pickle.dump(report, f)


MPI.Finalize()
