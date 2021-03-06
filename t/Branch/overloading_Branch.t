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
        Monday    => [q{08:00}, q{16:00}],
        Tuesday   => [q{08:00}, q{16:00}],
        Wednesday => [q{08:00}, q{16:00}],
        Thursday  => [q{08:00}, q{16:00}],
        Friday    => [q{08:00}, q{16:00}],
        Saturday  => [],
        Sunday    => []
    }
};

my $branch = $class->new({ hashref => $test_data });
isa_ok($branch, $class);

###############################################################################
# can't use boolean value on XML::Post::Branch object

my $boolean = eval{ !$branch };
my $error = $@;
like($error, qr/Can't get boolean value of Branch::Branch/);

###############################################################################
# stringify XML::Post::Branch to a hash

like($branch, qr/^\d+$/);