use Test::More qw(no_plan);

use Branch::OpeningHour;

my $class      = 'Branch::OpeningHour';
my $method     = 'new';

###############################################################################
# successfully creates an object with no day break

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00", "11:00"] };

my $opening_hour = $class->$method($mock_test_data);

isa_ok($opening_hour, $class);

###############################################################################
# successfully creates an object with a day break

my $mock_test_data = { 
                       Day          => "Monday",
                       OpeningHours => ["09:00", "11:00", "13:00", "18:00"]
                     }
                     ;

my $opening_hour = $class->$method($mock_test_data);

isa_ok($opening_hour, $class);

###############################################################################
# successfully creates an object with no opening hours

my $mock_test_data = { Day => "Monday", OpeningHours => [] };

my $opening_hour = $class->$method($mock_test_data);

isa_ok($opening_hour, $class);

###############################################################################
# empty hash ref

my $opening_hour = eval{ $class->$method({}) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): missing param keys/);

###############################################################################
# only one parameter

my $mock_test_data = { Day => "Monday" };

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): missing param keys/);

###############################################################################
# odd number of opening times

my $mock_test_data = { Day => "Monday", OpeningHours => ["09:00"] };

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): no closing time specified/);

####

my $mock_test_data = { 
                       Day          => "Monday",
                       OpeningHours => ["09:00", "11:00", "13:00"]
                     }
                     ;

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): no closing time specified/);

###############################################################################
# wrong day name

my $mock_test_data = { Day => "SDay", OpeningHours => ["09:00", "11:00"] };

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): incorrect day name/);

###############################################################################
# opening hours is not an array ref

my $mock_test_data = { Day => "Sunday", OpeningHours => "09:00" };

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): OpeningHours is not an array ref/);

###############################################################################
# day is not a scalar

my $mock_test_data = { Day => ["Sunday"], OpeningHours => ["09:00", "11:00"] };

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): Day is not a scalar/);

###############################################################################
# param is not a hash ref

my $mock_test_data = [];

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/must be hash reference/);

####

my $mock_test_data = "abc";

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/must be hash reference/);

###############################################################################
# param has more keys => success, anything > 2 is ignored

my $mock_test_data = { 
                       Day          => "Monday",
                       OpeningHours => ["09:00", "11:00"],
                       Ignored      => 12
                     }
                     ;

my $opening_hour = $class->$method($mock_test_data);

isa_ok($opening_hour, $class);

###############################################################################
# params are misnamed

my $mock_test_data = { 
                       Day          => "Monday",
                       OpeningHour  => ["09:00", "11:00"]
                     }
                     ;

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): wrong key names/);

###############################################################################
# opening hours do not comply with a regex ^[0-2][0-9][:][0-5][0-9]$

my $mock_test_data = { 
                       Day           => "Monday",
                       OpeningHours  => ["9:00", "11:00"]
                     }
                     ;

my $opening_hour = eval{ $class->$method($mock_test_data) };
my $error = $@;

is($opening_hour, undef);
like($error, qr/::new\(\): wrong OpeningHours format/);