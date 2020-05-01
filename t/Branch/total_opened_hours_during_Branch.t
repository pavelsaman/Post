use Test::More qw(no_plan);
use utf8;

use Branch::Branch;

my $class         = 'Branch::Branch';
my $test_data  = {    
    name          => q{Depo Praha 701},
    zip           => q{10003},
    type          => q{depo},
    address       => q{Sazečská 598/7, Malešice, 10003, Praha},
    city          => q{Praha},
    city_part     => q{Malešice},
    geo_x         => q{1044557.63},
    geo_y         => q{735997.36},
    opening_hours => {
        Monday    => [q{08:00}, q{12:00}],
        Tuesday   => [],
        Wednesday => [q{08:00}, q{11:00}, q{13:00}, q{16:00}],
        Thursday  => [],
        Friday    => [],
        Saturday  => [],
        Sunday    => [q{08:00}, q{12:00}]
    }
};

my $branch = $class->new({ hashref => $test_data });
isa_ok($branch, $class);

###############################################################################
# the whole week

is($branch->total_opened_hours_during_week(), 14);

###############################################################################
# working week

is($branch->total_opened_hours_during_working_week(), 10);

###############################################################################
# working week

is($branch->total_opened_hours_during_weekend(), 4);