use Test::More qw(no_plan);

use Branch::OpeningHour;

my $class                  = 'Branch::OpeningHour';
my $method                 = 'get_total_opened_hours';

###############################################################################
# total opened hours: 2 hours

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:00"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 2);

###############################################################################
# total opened hours: 2.5 hours

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:30"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 2.5);

###############################################################################
# total opened hours: 8 hours

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "17:00"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 8);

###############################################################################
# total opened hours: 8 hours; day break

my $mock_test_data = {
    Day => "Monday",
    OpeningHours => ["09:00", "12:00", "13:00", "18:00"]
};

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 8);

###############################################################################
# total opened hours: 8 hours; 2 day breaks

my $mock_test_data = {
    Day => "Monday",
    OpeningHours => ["09:00", "12:00", "13:00", "14:00", "15:00", "19:00"]
};

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 8);

###############################################################################
# closed the whole day

my $mock_test_data = { Day => "Sunday", OpeningHours => [] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), 0);
