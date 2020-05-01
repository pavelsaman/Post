use Test::More qw(no_plan);
use utf8;

use Branch::Branch;

my $class         = 'Branch::Branch';
my $method        = 'is_closed_during';
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

sub OPEN   { 0 };
sub CLOSED { 1 };

###############################################################################
# branch is open - inside the range

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "07:00",
                     EndTime => "10:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is open - left boundary

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "08:00",
                     EndTime => "10:00"
                    }
                   ), OPEN);

###############################################################################
# branch is open - right boundary

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "12:00",
                     EndTime => "16:00"
                    }
                   ), OPEN);

###############################################################################
# branch is open - left and right boundary

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "08:00",
                     EndTime => "16:00"
                    }
                   ), OPEN);

###############################################################################
# branch is closed - not in range on the left

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "07:00",
                     EndTime => "14:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is open - not in range on the right

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "11:00",
                     EndTime => "18:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is closed - not in range on the left and right

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Monday",
                     StartTime => "06:00",
                     EndTime => "18:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is closed - not in range because of a day break

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Wednesday",
                     StartTime => "10:00",
                     EndTime => "15:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is closed - day break

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Wednesday",
                     StartTime => "11:00",
                     EndTime => "13:00"
                    }
                   ), CLOSED);

####

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Wednesday",
                     StartTime => "12:00",
                     EndTime => "12:00"
                    }
                   ), CLOSED);

###############################################################################
# branch is closed - not really a range

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Wednesday",
                     StartTime => "10:00",
                     EndTime => "10:00"
                    }
                   ), OPEN);

###############################################################################
# branch is open - weekend

my $branch = $class->new({ hashref => $test_data });

isa_ok($branch, $class);
is($branch->$method({
                     Day => "Sunday",
                     StartTime => "11:00",
                     EndTime => "13:00"
                    }
                   ), CLOSED);