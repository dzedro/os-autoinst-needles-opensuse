# SUSE's openQA tests
#
# Copyright © 2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Checking if it is possible to install packages in repo with libsolv
# Maintainer: Anton Smorodskyi<asmorodskyi@suse.com>

use base "consoletest";
use testapi;
use utils;
use strict;
use serial_terminal 'select_virtio_console';

sub run {
    my ($self) = @_;
    select_virtio_console();
    my $installcheck_script = 'installcheck_hpc_module.sh';
    assert_script_run("wget --quiet " . data_url($installcheck_script) . " -O $installcheck_script");
    assert_script_run("chmod +x $installcheck_script");
    my $rez = script_run("./$installcheck_script " . get_var('ARCH') . " > installcheck_result.txt");
    if ($rez != 0) {
        upload_logs('./installcheck_result.txt', failok => 1);
        die('There are failures! Check installcheck_result.txt for details');
    }
}

1;
