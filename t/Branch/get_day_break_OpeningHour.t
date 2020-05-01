use Test::More qw(no_plan);

use Branch::OpeningHour;

my $class                  = 'Branch::OpeningHour';
my $method                 = 'get_day_break';

sub HAS_DAY_BREAK { 1 };
sub NO_DAY_BREAK  { 0 };

###############################################################################
# no day break

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:00"] };

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), NO_DAY_BREAK);

###############################################################################
# one day break

my $mock_test_data = { 
                       Day          => "Wednesday",
                       OpeningHours => ["09:00", "11:00", "13:00", "18:00"]
                     }
                     ;

my $opening_hour = $class->new($mock_test_data);

isa_ok($opening_hour, $class);
is($opening_hour->$method(), HAS_DAY_BREAK);