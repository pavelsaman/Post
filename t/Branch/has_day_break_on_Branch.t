use Test::More qw(no_plan);
use utf8;

use Branch::Branch;

my $class         = 'Branch::Branch';
my $method        = 'has_day_break_on';
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
        Monday    => [q{08:00}, q{16:00}],
        Tuesday   => [q{08:00}, q{16:00}],
        Wednesday => [q{08:00}, q{12:00}, q{13:00}, q{16:00}],
        Thursday  => [q{08:00}, q{16:00}],
        Friday    => [q{08:00}, q{16:00}],
        Saturday  => [],
        Sunday    => []
    }
};

sub HAS_DAY_BREAK { 1 };
sub NO_DAY_BREAK  { 0 };

###############################################################################
# branch is open

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Monday"    }), NO_DAY_BREAK);
is($branch->$method({ Day => "Wednesday" }), HAS_DAY_BREAK);

