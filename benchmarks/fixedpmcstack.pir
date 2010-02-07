.sub main :main
    .local pmc pds
    pds = loadlib "./dynext/pds_group"
    if pds goto has_pds_group
    exit 1
  has_pds_group:
    push_pop_benchmarks("FixedPMCStack", 1000000, 1)
    push_pop_rapidfire("FixedPMCStack",  1000000, 1)
    say ""
.end

.include "benchmarks/benchmarker.pir"
