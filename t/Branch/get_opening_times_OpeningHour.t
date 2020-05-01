use Test::More qw(no_plan);

use Branch::OpeningHour;

my $class                  = 'Branch::OpeningHour';
my $method                 = 'get_opening_times';

###############################################################################
# get one opening time

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:00"] };
my @expected_opening_times = ("09:00");

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
isnt(scalar @{ $opening_hour->$method() }, 0);

my $counter = 0;
foreach $opening_time (@{ $opening_hour->$method() }) {
    is($opening_time, $expected_opening_times[$counter]);
    $counter++;
}

###############################################################################
# get two opening times

my $mock_test_data = {
                      Day => "Monday",
                      OpeningHours => ["09:00", "11:00", "13:00", "19:00"]
                     }
                     ;
my @expected_opening_times = ("09:00", "13:00");

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
isnt(scalar @{ $opening_hour->$method() }, 0);

my $counter = 0;
foreach $opening_time (@{ $opening_hour->$method() }) {
    is($opening_time, $expected_opening_times[$counter]);
    $counter++;
}
