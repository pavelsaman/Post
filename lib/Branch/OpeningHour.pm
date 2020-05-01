package Branch::OpeningHour;

use 5.030002;
use strict;
use warnings;
use Readonly;
use Class::Std;
use Carp qw(croak);
use Daytime::Day 0.005 qw(:cze);
use DateTime::Format::Strptime;
use Daytime::Time 0.003 qw(is_allowed_time);

our $VERSION = 0.005;

##############################################################################
{   
    Readonly my $ALLOWED_NUM_OF_PARAMS => 2;   
    Readonly my $TIME_FORMAT           => q{%H:%M};     

    Readonly my %PARAM_ERROR  => (
        "no_params"           => __PACKAGE__ . "::new(): missing param keys",
        "no_closing_time"     
            => __PACKAGE__ . "::new(): no closing time specified",
        "incorrect_day_name"  => __PACKAGE__ . "::new(): incorrect day name",
        "opening_hour_ref"   
            => __PACKAGE__ . "::new(): OpeningHours is not an array ref",
        "day_not_scalar"      => __PACKAGE__ . "::new(): Day is not a scalar",    
        "no_hash_ref"         
            => __PACKAGE__ . "::new(): param is not a hash ref",
        "wrong_param_keys"    => __PACKAGE__ . "::new(): wrong key names",
        "opening_hour_format" 
            => __PACKAGE__ . "::new(): wrong OpeningHours format"
    );

    sub HAS_DAY_BREAK : PRIVATE {  1             };
    sub NO_DAY_BREAK  : PRIVATE {  0             };
    sub ONE_HOUR      : PRIVATE { 60             };
    sub ODD           : PRIVATE { $_[0] % 2 != 0 };
    sub EVEN          : PRIVATE { $_[0] % 2 == 0 };
    
    my (%day_of, %czech_day_of, %opening_hours_of) :ATTRS;
    my %day_break_of                               :ATTR( :get<day_break> );

    sub BUILD {
        my $self     = shift;
        my $ident    = shift;
        my $args_ref = _sanity_check_params(shift);

        my @opening_times = sort @{ $args_ref->{OpeningHours} };

        $day_of{$ident}           = $args_ref->{Day};
        $czech_day_of{$ident}     = get_czech_day($args_ref->{Day});
        $opening_hours_of{$ident} = \@opening_times;
        $day_break_of{$ident}     = scalar @{ $args_ref->{OpeningHours} } > 2 
                                        ? HAS_DAY_BREAK : NO_DAY_BREAK;        

        return;
    }        

    sub _sanity_check_params : PRIVATE {
        my $param_ref = shift;        

        croak $PARAM_ERROR{no_params}
            if scalar keys %{ $param_ref } < $ALLOWED_NUM_OF_PARAMS;

        croak $PARAM_ERROR{wrong_param_keys}
            if not defined $param_ref->{Day};

        croak $PARAM_ERROR{wrong_param_keys}
            if not defined $param_ref->{OpeningHours};

        my $day = $param_ref->{Day};
        croak $PARAM_ERROR{day_not_scalar}
            if not ref \$day eq "SCALAR";

        croak $PARAM_ERROR{incorrect_day_name}
            if not defined get_czech_day($param_ref->{Day});

        croak $PARAM_ERROR{opening_hour_ref}
            if not ref $param_ref->{OpeningHours} eq ref [];

        croak $PARAM_ERROR{no_closing_time}
            if ODD(scalar @{ $param_ref->{OpeningHours} });

        foreach my $opening_time (@{ $param_ref->{OpeningHours} }) {
            croak $PARAM_ERROR{opening_hour_format}
                if not is_allowed_time($opening_time);
        }

        return $param_ref;
    }

    sub _get_times : PRIVATE {
        my $self     = shift;
        my $func_ref = shift;

        my @opening_times = ();
        my $counter = 0;
        foreach my $time (@{ $opening_hours_of{ident $self} }) {
            if ($func_ref->($counter)) {
                push @opening_times, $time;
            }

            $counter++;
        }

        return \@opening_times;
    }

    sub get_all_times {
        my $self = shift;

        my @opening_hours = @{ $opening_hours_of{ident $self} };
        return \@opening_hours;
    }    

    sub get_opening_times {
        my $self = shift;

        return $self->_get_times(\&EVEN);
    }

    sub get_closing_times {
        my $self = shift;

        return $self->_get_times(\&ODD);
    }

    sub get_total_opened_hours {
        my $self = shift;

        my $total_opened_time_in_minutes = 0;
        my $parser = DateTime::Format::Strptime->new(pattern => $TIME_FORMAT);

        # for all pairs of opening anc closing times
        TIME:
        for my $c (0..scalar @{ $opening_hours_of{ident $self} } - 1) {
            # skip closing times
            next TIME if ODD($c);

            # get opening and closing time
            my $start = $opening_hours_of{ident $self}->[$c];
            my $end   = $opening_hours_of{ident $self}->[$c + 1];

            # cerate datetime objects
            my $t1 = $parser->parse_datetime($start);
            my $t2 = $parser->parse_datetime($end);

            # count difference
            my $diff = $t2 - $t1;
            # get the difference in minutes
            $total_opened_time_in_minutes
                += (($diff->hours * ONE_HOUR) + $diff->minutes);
            
        }      

        # return the difference in hours
        return $total_opened_time_in_minutes / ONE_HOUR;
    }    
}

1;

__END__