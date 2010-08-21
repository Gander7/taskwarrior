#! /usr/bin/perl
################################################################################
## taskwarrior - a command line task list manager.
##
## Copyright 2006 - 2010, Paul Beckingham.
## All rights reserved.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 2 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, write to the
##
##     Free Software Foundation, Inc.,
##     51 Franklin Street, Fifth Floor,
##     Boston, MA
##     02110-1301
##     USA
##
################################################################################

use strict;
use warnings;
use Test::More tests => 7;

# Create the rc file.
if (open my $fh, '>', 'recur.rc')
{
  print $fh "data.location=.\n";
  close $fh;
  ok (-r 'recur.rc', 'Created recur.rc');
}

# Add a recurring task, then see how many future pending tasks are
# generated by default, and by overriding rc.recurrence.limit.
qx{../task rc:recur.rc add ONE due:tomorrow recur:weekly};
my $output = qx{../task rc:recur.rc long};
my @tasks = $output =~ /(ONE)/g;
is (scalar @tasks, 1, 'recurrence.limit default to 1');

$output = qx{../task rc:recur.rc rc.recurrence.limit:4 long};
@tasks = $output =~ /(ONE)/g;
is (scalar @tasks, 4, 'recurrence.limit override to 4');

# Cleanup.
unlink 'pending.data';
ok (!-r 'pending.data', 'Removed pending.data');

unlink 'completed.data';
ok (!-r 'completed.data', 'Removed completed.data');

unlink 'undo.data';
ok (!-r 'undo.data', 'Removed undo.data');

unlink 'recur.rc';
ok (!-r 'recur.rc', 'Removed recur.rc');

exit 0;

