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
    print_partial_result(targettype, "push batch", numtrials, $N3)
    print_partial_result(targettype, "shift batch", numtrials, $N4)
    print_partial_result(targettype, "batch total", numtrials, $N5)
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
    print_partial_result(targettype, "push batch", numtrials, $N3)
    print_partial_result(targettype, "pop batch", numtrials, $N4)
    print_partial_result(targettype, "batch total", numtrials, $N5)
.end

.sub push_pop_rapidfire
    .param string targettype
    .param int numtrials
    .param int preallocate

    $P0 = new [targettype]
    $I0 = numtrials

    $N0 = time

    if preallocate goto preallocate_storage
    goto have_storage
  preallocate_storage:
    $P0 = 1
  have_storage:

    $P1 = new ['Integer']
  loop_top:
    push $P0, $P1
    $P2 = pop $P0
    $I0 = $I0 - 1
    if $I0 == 0 goto loop_bottom
    goto loop_top
  loop_bottom:

    $N1 = time
    $N2 = $N1 - $N0

    print_partial_result(targettype, "push/pop rapidfire", numtrials, $N2)
.end

.sub push_shift_rapidfire
    .param string targettype
    .param int numtrials
    .param int preallocate

    $P0 = new [targettype]
    $I0 = numtrials

    $N0 = time

    if preallocate goto preallocate_storage
    goto have_storage
  preallocate_storage:
    $P0 = 1
  have_storage:

    $P1 = new ['Integer']
  loop_top:
    push $P0, $P1
    $P2 = shift $P0
    $I0 = $I0 - 1
    if $I0 == 0 goto loop_bottom
    goto loop_top
  loop_bottom:

    $N1 = time
    $N2 = $N1 - $N0

    print_partial_result(targettype, "push/shift rapidfire", numtrials, $N2)
.end


.sub print_partial_result
    .param string targettype
    .param string operation
    .param int numtrials
    .param num totaltime


    $I0 = length operation
    $I1 = 25 - $I0
    $S0 = repeat " ", $I1
    print "("
    print targettype
    print ") "
    print operation
    print $S0
    print numtrials
    print ": "
    say totaltime
.end
