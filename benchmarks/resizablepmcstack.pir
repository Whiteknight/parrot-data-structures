.sub main :main
    .local pmc pds
    pds = loadlib "./dynext/pds_group"
    if pds goto has_pds_group
    exit 1
  has_pds_group:
    push_pop_benchmarks("ResizablePMCStack", 1000000, 0)
    push_pop_rapidfire("ResizablePMCStack",  1000000, 0)
    say ""
.end

.include "benchmarks/benchmarker.pir"
