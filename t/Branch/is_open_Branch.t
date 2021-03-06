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
        Saturday  => [q{08:00}, q{16:00}],
        Sunday    => [q{08:00}, q{16:00}]
    }
};

sub OPEN   { 1 };
sub CLOSED { 0 };

###############################################################################
# branch is open

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Monday", Time => "09:00" }), OPEN);
is($branch->$method({ Day => "Tomorrow", Time => "09:00" }), OPEN);
is($branch->$method({ Day => "Today", Time => "09:00" }), OPEN);
is($branch->$method({ Day => "Yesterday", Time => "09:00" }), OPEN);

# case-insenstivite
is($branch->$method({ Day => "monday", Time => "09:00" }), OPEN);
is($branch->$method({ Day => "tomorrow", Time => "09:00" }), OPEN);

###############################################################################
# branch is just open - lower limit

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Monday", Time => "08:00" }), OPEN);

###############################################################################
# branch is just open - upper limit

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Monday", Time => "16:00" }), OPEN);

###############################################################################
# branch is closed

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Monday", Time => "19:00" }), CLOSED);

###############################################################################
# branch is closed during a day break

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Wednesday", Time => "12:00" }), CLOSED);

###############################################################################
# branch is closed during a weekend

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({ Day => "Sunday", Time => "21:00" }), CLOSED);