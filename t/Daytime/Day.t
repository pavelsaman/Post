use Test::More qw(no_plan);

use Daytime::Day qw(:all);

my $DAYS_IN_A_WEEK = 7;

###############################################################################
# get_czech_day

is(get_czech_day("Monday"), "Pondělí");

###############################################################################
# get_all_eng_days - array context

my @eng_days = get_all_eng_days();
is(ref \@eng_days, ref []);
is(scalar @eng_days, $DAYS_IN_A_WEEK);

###############################################################################
# get_all_eng_days - scalar context

is(get_all_eng_days(), $DAYS_IN_A_WEEK);

###############################################################################
# get_all_cze_days - array context

my @cze_days = get_all_cze_days();
is(ref \@cze_days, ref []);
is(scalar @cze_days, $DAYS_IN_A_WEEK);

###############################################################################
# get_all_cze_days - scalar context

is(get_all_cze_days(), $DAYS_IN_A_WEEK);

###############################################################################
# day_exists - it does exist

is(day_exists("Monday"), "Monday");

###############################################################################
# day_exists - it doesn't exist

is(day_exists("Mon"), undef);

###############################################################################
# day_exists - no day passed

is(day_exists(), undef);

###############################################################################
# aliases

my $yesterday = DateTime->now()->subtract(days => 1)->day_name;
my $today = DateTime->now()->day_name;
my $tomorrow = DateTime->now()->add(days => 1)->day_name;

is(get_day_name(q{Yesterday}), $yesterday);
is(get_day_name(q{Today}), $today);
is(get_day_name(q{Tomorrow}), $tomorrow);
is(get_day_name(q{T}), undef);