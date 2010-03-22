.sub main :main
    .local pmc pds
    pds = loadlib "./dynext/pds_group"
    if pds goto has_pds_group
    exit 1
  has_pds_group:
    push_shift_benchmarks("FixedPMCQueue3", 100000, 1)
    push_shift_rapidfire("FixedPMCQueue3",  100000, 1)
    say ""
.end

.include "benchmarks/benchmarker.pir"
