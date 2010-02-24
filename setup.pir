#!/usr/bin/env parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

See F<runtime/library/distutils.pir>.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    .local pmc config
    config = new 'Hash'
    config['name'] = 'parrot-data-structures'
    config['abstract'] = 'Data structures library for the Parrot VM'
    config['authority'] = 'http://github.com/Whiteknight'
    config['description'] = 'Data structures library for the Parrot VM'
    $P1 = split ';', 'stack;queue;array'
    config['keywords'] = $P1
    config['license_type'] = 'Artistic License 2.0'
    config['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    config['copyright_holder'] = 'Andrew Whitworth'
    config['checkout_uri'] = 'git://github.com/Whiteknight/parrot-data-structures.git'
    config['browser_uri'] = 'http://github.com/Whiteknight/parrot-data-structures'
    config['project_uri'] = 'http://github.com/Whiteknight/parrot-data-structures'

    # build
    $P2 = new 'Hash'
    $P3 = split "\n", <<'SOURCES'
src/pmc/resizablepmcstack.pmc
src/pmc/resizablepmcstack2.pmc
src/pmc/fixedpmcstack.pmc
src/pmc/resizablepmcqueue.pmc
src/pmc/fixedpmcqueue.pmc
src/pmc/fixedpmcqueue2.pmc
src/pmc/fixedpmcqueue3.pmc
SOURCES
    $S0 = pop $P3
    $P2['pds_group'] = $P3
    config['dynpmc'] = $P2

    # test
    $P4 = new 'Hash'
    $P4['t/Glue.pbc'] = 't/Glue.pir'
    config['pbc_pir'] = $P4

    $S0 = get_nqp()
    config['harness_exec'] = $S0
    config['harness_files'] = 't/*.t t/pmc/*.t'

    .tailcall setup(args :flat, config :flat :named)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
