use Test::More qw(no_plan);
use utf8;

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
# no args

my $is_open = eval{ $branch->$method() };
my $error = $@;
like($error, qr/::$method\(\): no args passed/);

###############################################################################
# empty hash

my $is_open = eval{ $branch->$method({}) };
my $error = $@;
like($error, qr/::$method\(\): wrong named arguments/);

###############################################################################
# wrong names of the keys

my $is_open = eval{ $branch->$method({ D => "Monday", T => "10:00"}) };
my $error = $@;
like($error, qr/::$method\(\): wrong named arguments/);

####

my $is_open = eval{ $branch->$method({ Day => "Monday", T => "10:00"}) };
my $error = $@;
like($error, qr/::$method\(\): wrong named arguments/);

####

my $is_open = eval{ $branch->$method({ Da => "Monday", Time => "10:00"}) };
my $error = $@;
like($error, qr/::$method\(\): wrong named arguments/);

###############################################################################
# wrong day name

my $is_open = eval{ $branch->$method({ Day => "Monda", Time => "10:00"}) };
my $error = $@;
like($error, qr/::$method\(\): wrong parameter values/);

###############################################################################
# wrong time format

my $is_open = eval{ $branch->$method({ Day => "Monday", Time => "9:00"}) };
my $error = $@;
like($error, qr/::$method\(\): wrong parameter values/);