use Test::More qw(no_plan);
use utf8;

use Branch::Branch;

my $class         = 'Branch::Branch';
my $method        = 'total_opened_hours_on';
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
        Wednesday => [q{08:00}, q{11:00}, q{13:00}, q{16:00}],
        Thursday  => [q{08:00}, q{16:00}],
        Friday    => [q{08:00}, q{12:30}],
        Saturday  => [],
        Sunday    => []
    }
};

my $branch = $class->new({ hashref => $test_data });
isa_ok($branch, $class);

###############################################################################
# wrong day

my $is_open = eval{ $branch->$method() };
my $error = $@;
like($error, qr/::$method\(\): wrong day name/);

###############################################################################
# total opening hours on Friday: 4.5 hours

is($branch->$method("Friday"), 4.5);

###############################################################################
# total opening hours on Tuesday: 8 hours

is($branch->$method("Tuesday"), 8);

###############################################################################
# closed on a weekend

is($branch->$method("Saturday"), 0);

###############################################################################
# day break

is($branch->$method("Wednesday"), 6);
