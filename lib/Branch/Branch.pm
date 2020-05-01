package Branch::Branch;

use 5.030002;
use strict;
use warnings;
use Readonly;
use Class::Std;
use Hash::Util qw(hash_value);
use Carp qw(croak);
use Branch::OpeningHour 0.004;
use Daytime::Day 0.005 qw(:all);
use Daytime::Time 0.003 qw(is_allowed_time);

our $VERSION = 0.006;

###############################################################################
{
    sub OK  : PRIVATE { 1 };
    sub NOK : PRIVATE { 0 };
    sub _only_first_to_upper_case {  ucfirst lc $_[0] };

    # attributes
    my %zip_of           :ATTR( :get<zip>       );
    my %name_of          :ATTR;
    my %address_of       :ATTR( :get<address>   );
    my %type_of          :ATTR( :get<type>      );
    my %opening_hours_of :ATTR;
    my %geo_of           :ATTR;
    my %city_of          :ATTR( :get<city>      );
    my %city_part_of     :ATTR( :get<city_part> );

    Readonly my %PARAM_ERROR  => (
        "no_params"    => "no args passed",
        "wrong_args"   => "wrong named arguments",
        "wrong_values" => "wrong parameter values",
        "wrong_day"    => "wrong day name" 
    );

    sub BUILD {
        my ($self, $ident, $args_ref) = @_;

        $zip_of{$ident}       = $args_ref->{hashref}->{zip};
        $name_of{$ident}      = $args_ref->{hashref}->{name};
        $address_of{$ident}   = $args_ref->{hashref}->{address};
        $type_of{$ident}      = $args_ref->{hashref}->{type};
        $geo_of{$ident}{x}    = $args_ref->{hashref}->{geo_x};
        $geo_of{$ident}{y}    = $args_ref->{hashref}->{geo_y};
        $city_of{$ident}      = $args_ref->{hashref}->{city};
        $city_part_of{$ident} = $args_ref->{hashref}->{city_part};

        foreach my $d (keys %{ $args_ref->{hashref}->{opening_hours} }) {
            my $opening_hours = {
                Day => $d,
                OpeningHours => $args_ref->{hashref}->{opening_hours}->{$d}
            };
            $opening_hours_of{$ident}{$d}
                = Branch::OpeningHour->new($opening_hours);
        }
        
        return;
    }   

    sub DEMOLISH {
        my ($self, $ident) = @_;

        return;
    }  

    sub _sanity_check_is_open_param : PRIVATE {
        my $requested_datetime_ref = shift;

        croak __PACKAGE__ . "::is_open(): " . $PARAM_ERROR{no_params}
            if not defined $requested_datetime_ref;        

        if (not defined $requested_datetime_ref->{Day}
            or not defined $requested_datetime_ref->{Time}) {
            croak __PACKAGE__ . "::is_open(): " . $PARAM_ERROR{wrong_args};
        }

        $requested_datetime_ref->{Day} =
            _only_first_to_upper_case($requested_datetime_ref->{Day});

        if ((not day_exists($requested_datetime_ref->{Day})
             and not defined get_day_name($requested_datetime_ref->{Day}))
            or not is_allowed_time($requested_datetime_ref->{Time})) {
            croak __PACKAGE__ . "::is_open(): " . $PARAM_ERROR{wrong_values};
        }

        return $requested_datetime_ref;
    }

    sub _sanity_check_is_open_during_param : PRIVATE {
        my $requested_datetime_ref = shift;

        croak __PACKAGE__ . "::is_open_during(): " . $PARAM_ERROR{no_params}
            if not defined $requested_datetime_ref; 

        if (not defined $requested_datetime_ref->{Day}
            or not defined $requested_datetime_ref->{StartTime}
            or not defined $requested_datetime_ref->{EndTime}) {
            croak __PACKAGE__ . "::is_open_during(): "
                . $PARAM_ERROR{wrong_args};
        }

        $requested_datetime_ref->{Day} =
            _only_first_to_upper_case($requested_datetime_ref->{Day});

        if ((not day_exists($requested_datetime_ref->{Day})
             and not defined get_day_name($requested_datetime_ref->{Day}))
            or not is_allowed_time($requested_datetime_ref->{StartTime})
            or not is_allowed_time($requested_datetime_ref->{EndTime})) {
            croak __PACKAGE__ . "::is_open_during(): "
                . $PARAM_ERROR{wrong_values};
        }

        return $requested_datetime_ref;
    }

    sub _sanity_check_has_day_break_on : PRIVATE {
        my $requested_day_ref = shift;

        croak __PACKAGE__ . "::has_day_break_on(): "
            . $PARAM_ERROR{no_params}
                if not defined $requested_day_ref;        

        if (not defined $requested_day_ref->{Day}) {
            croak __PACKAGE__ . "::has_day_break_on(): "
                . $PARAM_ERROR{wrong_args};
        }

        $requested_day_ref->{Day} =
            _only_first_to_upper_case($requested_day_ref->{Day});

        if (not day_exists($requested_day_ref->{Day})) {
            croak __PACKAGE__ . "::has_day_break_on(): "
                . $PARAM_ERROR{wrong_values};
        }

        return $requested_day_ref;
    }    

    sub _get_total_hours : PRIVATE {
        my $self     = shift;
        my $args_ref = shift;

        my $ident = ident $self;

        my $total_opened_hours = 0;
        foreach my $day (@{ $args_ref->{Days} }) {
            $total_opened_hours
                += $opening_hours_of{$ident}{$day}->get_total_opened_hours();
        }

        return $total_opened_hours;
    }

    sub is_ok : BOOLIFY {
        my $self = shift;

        croak q{Can't get boolean value of Branch::Branch};
    }

    sub get_hash : STRINGIFY {
        my $self = shift;

        return hash_value($name_of{ident $self}
                          . $address_of{ident $self}
                          . $type_of{ident $self}
                          . $zip_of{ident $self}
                          . $city_of{ident $self}
                          . $city_part_of{ident $self}
                         )
        ;
    }

    sub is_open {
        my $self                   = shift;
        my $requested_datetime_ref = _sanity_check_is_open_param(shift);       

        my $day = get_day_name($requested_datetime_ref->{Day});
        my $opening_hour_obj_ref;
        if ($day) {
            $opening_hour_obj_ref = $opening_hours_of{ident $self}{$day};
        }
        else {
            $opening_hour_obj_ref      
                = $opening_hours_of{ident $self}{$requested_datetime_ref->{Day}};
        }
        
        my $opening_times_ref = $opening_hour_obj_ref->get_opening_times();
        my $closing_times_ref = $opening_hour_obj_ref->get_closing_times();

        for my $count (0..scalar @{ $opening_times_ref } - 1) {
            if ($requested_datetime_ref->{Time} ge $opening_times_ref->[$count]
                and $requested_datetime_ref->{Time}
                    le $closing_times_ref->[$count]) {
                return OK;
            }
        }

        return NOK;
    }

    sub is_closed {
        my $self                   = shift;
        my $requested_datetime_ref = shift;  

        my $branch_is_open = $self->is_open($requested_datetime_ref);

        return $branch_is_open ? NOK : OK; 
    }

    sub is_open_during {
        my $self                = shift;
        my $requested_range_ref = _sanity_check_is_open_during_param(shift);

        my $opening_hour_obj_ref            
            = $opening_hours_of{ident $self}{$requested_range_ref->{Day}};
        if (not defined $opening_hour_obj_ref) {
            $opening_hour_obj_ref
                = $opening_hours_of{ident $self}{
                    get_day_name($requested_range_ref->{Day})
                };
        }
        my $opening_times_ref = $opening_hour_obj_ref->get_opening_times();
        my $closing_times_ref = $opening_hour_obj_ref->get_closing_times();

        my $start_time = $requested_range_ref->{StartTime};
        my $end_time   = $requested_range_ref->{EndTime};
        for my $count (0..scalar @{ $opening_times_ref } - 1) {
            if ($start_time ge $opening_times_ref->[$count]
                and $end_time le $closing_times_ref->[$count]
                and $start_time le $end_time) {
                return OK;
            }
        }

        return NOK;
    }    

    sub is_closed_during {
        my $self                = shift;
        my $requested_range_ref = shift;  

        my $branch_is_open = $self->is_open_during($requested_range_ref);

        return $branch_is_open ? NOK : OK; 
    }

    sub get_name {
        my $self = shift;

        return $name_of{ident $self};
    }    

    sub get_opening_hours {
        my $self = shift;

        my %opening_hours = ();
        foreach my $day (keys %{ $opening_hours_of{ident $self} }) {
            $opening_hours{$day}
                = $opening_hours_of{ident $self}{$day}->get_all_times();
        }

        return \%opening_hours;
    }

    sub get_geo {
        my $self = shift;

        my %geo = %{ $geo_of{ident $self} };
        return \%geo;
    }    

    sub total_opened_hours_on {
        my $self = shift;
        my $day  = shift;

        if (not defined day_exists($day)) {
            croak __PACKAGE__ . "::total_opened_hours_on(): "
                . $PARAM_ERROR{wrong_day};
        }

        my $desired_day_opening_hours = $opening_hours_of{ident $self}->{$day};

        return $desired_day_opening_hours->get_total_opened_hours();
    }

    sub total_opened_hours_during_week {
        my $self = shift;       

        my @days = get_all_eng_days();
        return $self->_get_total_hours({ Days => \@days });
    }

    sub total_opened_hours_during_working_week {
        my $self = shift;        

        my @days = qw(Monday Tuesday Wednesday Thursday Friday);
        return $self->_get_total_hours({ Days => \@days });
    }

    sub total_opened_hours_during_weekend {
        my $self = shift;

        my @days = qw(Saturday Sunday);
        return $self->_get_total_hours({ Days => \@days });
    }    

    sub has_day_break_on {
        my $self              = shift;
        my $requested_day_ref = _sanity_check_has_day_break_on(shift);

        my $ident = ident $self;

        my $day = $requested_day_ref->{Day};
        my $has_day_break = $opening_hours_of{$ident}{$day}->get_day_break();
        return $has_day_break;
    }
}

1;

__END__

