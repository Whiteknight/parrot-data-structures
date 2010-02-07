.sub push_shift_benchmarks
    .param string targettype
    .param int numtrials
    .param int preallocate

    $P0 = new [targettype]
    $P1 = new ['Integer']
    $P1 = 5
    $I0 = numtrials
    $N0 = time

    if preallocate goto preallocate_storage
    goto storage_is_ok
  preallocate_storage:
    $P0 = numtrials
  storage_is_ok:

  push_loop_top:
    push $P0, $P1
    $I0 = $I0 - 1
    if $I0 == 0 goto push_loop_bottom
    goto push_loop_top
  push_loop_bottom:
    $N1 = time
    $I0 = numtrials
  shift_loop_top:
    $P2 = shift $P0
    $I0 = $I0 - 1
    if $I0 == 0 goto shift_loop_bottom
    goto shift_loop_top
  shift_loop_bottom:
    $N2 = time
    $N3 = $N1 - $N0
    $N4 = $N2 - $N1
    $N5 = $N2 - $N0
    print_partial_result(targettype, "push ", numtrials, $N3)
    print_partial_result(targettype, "shift", numtrials, $N4)
    print_partial_result(targettype, "total", numtrials, $N5)
.end

.sub push_pop_benchmarks
    .param string targettype
    .param int numtrials
    .param int preallocate

    $P0 = new [targettype]
    $P1 = new ['Integer']
    $P1 = 5
    $I0 = numtrials
    $N0 = time

    if preallocate goto preallocate_storage
    goto storage_is_ok
  preallocate_storage:
    $P0 = numtrials
  storage_is_ok:

  push_loop_top:
    push $P0, $P1
    $I0 = $I0 - 1
    if $I0 == 0 goto push_loop_bottom
    goto push_loop_top
  push_loop_bottom:
    $N1 = time
    $I0 = numtrials
  shift_loop_top:
    $P2 = pop $P0
    $I0 = $I0 - 1
    if $I0 == 0 goto shift_loop_bottom
    goto shift_loop_top
  shift_loop_bottom:
    $N2 = time
    $N3 = $N1 - $N0
    $N4 = $N2 - $N1
    $N5 = $N2 - $N0
    print_partial_result(targettype, "push ", numtrials, $N3)
    print_partial_result(targettype, "pop  ", numtrials, $N4)
    print_partial_result(targettype, "total", numtrials, $N5)
.end

.sub print_partial_result
    .param string targettype
    .param string operation
    .param int numtrials
    .param num totaltime

    print "("
    print targettype
    print ") Time to "
    print operation
    print " "
    print numtrials
    print ": "
    say totaltime
.end
