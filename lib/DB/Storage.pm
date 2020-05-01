package DB::Storage;

use 5.030002;
use strict;
use warnings;
use Readonly;
use DBI;
use Carp qw(croak);
use DateTime;
use Daytime::Day qw(get_day_number);

use Exporter 'import';
our @EXPORT    = qw();
our @EXPORT_OK = qw(save_branches);
our %EXPORT_TAGS = (all => \@EXPORT_OK, ALL => \@EXPORT_OK);

our $VERSION = 0.001;

Readonly my $driver   => q{SQLite};
Readonly my $dsn      => qq{DBI:$driver:dbname=};
Readonly my $userid   => q{};
Readonly my $password => q{};

Readonly my $insert_branch => qq{
    insert into Branch (Name, Type, Address, City, CityPart, ZipCode,
        Latitude, Longitude, LastUpdated)
    values (?, ?, ?, ?, ?, ?, ?, ?, ?)
};
Readonly my $insert_opening_hour => qq{
    insert into OpeningHour (BranchId, DayOfWeekNumber, Begin, End)
    values (?, ?, ?, ?)
};

sub save_branches {
    my $post_obj_ref = shift;
    my $db_file      = shift;

    croak __PACKAGE__ . ":: no db file" if not defined $db_file;
    croak __PACKAGE__ . ":: cannot write into db"
        if not -e $db_file or not -w $db_file;

    my $db = DBI->connect($dsn . $db_file, $userid, $password,
        { RaiseError => 1 }
    ) or croak __PACKAGE__ . ":: " . $DBI::errstr;

    # get current datetime in UTC
    my $datetime = DateTime->now()->iso8601() . 'Z';

    # get all branches
    my $branches = $post_obj_ref->get_all();

    # for every branch
    BRANCH:
    foreach my $b (@$branches) {
        # get latitude and longitude
        my $geo = $b->get_geo();
        # create bind values
        my @bind_vals = ($b->get_name(), $b->get_type(), $b->get_address(),
            $b->get_city(), $b->get_city_part(), $b->get_zip(),
            $geo->{x}, $geo->{y}, $datetime
        );         

        # insert or go to the next one if an error occured
        $db->do($insert_branch, {}, @bind_vals) or next BRANCH;

        # get BranchId
        my $branch_id = $db->last_insert_id();  

        # get all opening hours as a hash
        my $oh = $b->get_opening_hours();

        # save all opening hours into the DB 
        # for each day
        DAY:
        foreach my $d (keys %$oh) {
            # for each time
            TIME:
            foreach my $t (0..scalar @{ $oh->{$d} } - 2) {
                # create bind values
                my @bind_vals = ($branch_id, get_day_number($d),
                    $oh->{$d}->[$t], $oh->{$d}->[$t + 1]
                );

                # insert or go to the next one if an error occured
                $db->do($insert_opening_hour, {}, @bind_vals) or next TIME;
            }                
        }            
    }

    # disconnect
    $db->disconnect();
}

1;

__END__