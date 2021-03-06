.sub main :main
    .local pmc pds
    pds = loadlib "./dynext/pds_group"
    if pds goto has_pds_group
    exit 1
  has_pds_group:
    push_pop_benchmarks("ResizablePMCArray", 1000000, 0)
    push_pop_rapidfire("ResizablePMCArray",  1000000, 0)
    say ""
    push_shift_benchmarks("ResizablePMCArray", 100000, 0)
    push_shift_rapidfire("ResizablePMCArray",  100000, 0)
    say ""
.end

.include "benchmarks/benchmarker.pir"
