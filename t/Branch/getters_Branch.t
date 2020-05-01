use Test::More qw(no_plan);

use Branch::Branch;

my $class         = 'Branch::Branch';
my $method        = 'is_open';
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
        Friday    => [q{08:00}, q{16:00}],
        Saturday  => [],
        Sunday    => []
    }
};

my $branch = $class->new({ hashref => $test_data });
isa_ok($branch, $class);

###############################################################################
# opening hours

my $expected_result = {
    "Monday"    => ["08:00", "16:00"],
    "Tuesday"   => ["08:00", "16:00"],
    "Wednesday" => ["08:00", "11:00", "13:00", "16:00"],
    "Thursday"  => ["08:00", "16:00"],
    "Friday"    => ["08:00", "16:00"],
    "Saturday"  => [],
    "Sunday"    => []
};

is_deeply($branch->get_opening_hours(), $expected_result);

###############################################################################
# geo

my $expected_result = {
    "x" => 1044557.63,
    "y" => 735997.36
};

is_deeply($branch->get_geo(), $expected_result);

###############################################################################
# zip

is($branch->get_zip(), "10003");

###############################################################################
# name

is($branch->get_name(), "Depo Praha 701");

###############################################################################
# address

isnt($branch->get_address(), undef);

###############################################################################
# type

is($branch->get_type(), "depo");

###############################################################################
# city

is($branch->get_city(), "Praha");

###############################################################################
# city_part

isnt($branch->get_city_part(), undef);