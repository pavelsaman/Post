use Test::More qw(no_plan);

use Branch::OpeningHour;

my $class                  = 'Branch::OpeningHour';
my $method                 = 'get_all_times';
my @expected_opening_hour  = ("09:00", "11:00");
my @expected_opening_hours = ("09:00", "11:00", "13:00", "19:00");

###############################################################################
# gets one opening hour

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:00"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
my $i = 0;
foreach $oh (@{ $opening_hour->$method() }) {
    is($oh, $expected_opening_hour[$i]);
    $i++;
}

###############################################################################
# gets two opening hours

my $mock_test_data = {
                      Day => "Monday",
                      OpeningHours => ["09:00", "11:00", "13:00", "19:00"]
                     }
                     ;

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
my $i = 0;
foreach $oh (@{ $opening_hour->$method() }) {
    is($oh, $expected_opening_hours[$i]);
    $i++;
}

###############################################################################
# gets one sorted opening hour

my $mock_test_data = { Day => "Monday", OpeningHours => ["11:00", "09:00"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
my $i = 0;
foreach $oh (@{ $opening_hour->$method() }) {
    is($oh, $expected_opening_hour[$i]);
    $i++;
}

###############################################################################
# gets two sorted opening hours

my $mock_test_data = {
                      Day => "Monday",
                      OpeningHours => ["19:00", "11:00", "13:00", "09:00"]
                     }
                     ;

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
my $i = 0;
foreach $oh (@{ $opening_hour->$method() }) {
    is($oh, $expected_opening_hours[$i]);
    $i++;
}