use Test::More qw(no_plan);

use Daytime::Time qw(:all);

###############################################################################
# correct time

my $expected_time = "10:00";
is(is_allowed_time($expected_time), $expected_time);

###############################################################################
# correct time afternoon

my $expected_time = "19:00";
is(is_allowed_time($expected_time), $expected_time);

####

my $expected_time = "22:00";
is(is_allowed_time($expected_time), $expected_time);

###############################################################################
# incorrect time

my $expected_time = "1:00";
is(is_allowed_time($expected_time), undef);

####

my $expected_time = "9:00";
is(is_allowed_time($expected_time), undef);
