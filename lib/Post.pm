package Post;

use 5.030002;
use strict;
use warnings;
use Readonly;
use Class::Std;
use Carp qw(croak);
use XML::Parse 0.001;
use Branch::Branch 0.005;
use Config::Reader 0.002;
use Remote::Remote 0.006;

our $VERSION = 0.011;

###############################################################################
{
    sub is_empty { scalar @{ $_[0] } == 0 };

    my %branches_xml_of :ATTR;
    my %branches_of     :ATTR;

    sub BUILD {
        my ($self, $ident, $args_ref) = @_;
        
        my $xml_branches = Remote::Remote::request_xml();
        $branches_xml_of{$ident} = XML::Parse->new({
            xml      => $xml_branches,
            encoding => Config::Reader::get_encoding()
        });
        $self->_build_branches(
            $branches_xml_of{$ident}->parse(Config::Reader::get_branch_xpath())
        );

        return;
    }    

    sub _build_branches : PRIVATE {
        my $self          = shift;
        my $branches_ref  = shift;        

        # create branches
        foreach my $branch (values %$branches_ref) {
            my $branch_obj = Branch::Branch->new({ hashref => $branch });
            $branches_of{ident $self}{$branch_obj} = $branch_obj;
        }           
    }

    sub _return_undef_or_all : PRIVATE {
        my $self    = shift;
        my $arr_ref = shift;
        
        if (is_empty($arr_ref)) {
            return;
        }

        return $arr_ref;
    }

    sub _sanity_check_scalar_param {
        my $arg = shift;

        if (not defined $arg) {
            croak __PACKAGE__ . ": no arg passed";
        }

        if (ref $arg eq ref {}) {
            croak __PACKAGE__ . ": hash ref passed";
        }

        if (ref $arg eq ref []) {
            croak __PACKAGE__ . ": array ref passed";
        }        
        
        return $arg;        
    }

    sub get_raw_xml {
        my $self = shift;

        return $branches_xml_of{ident $self}->get_raw_xml();
    }

    sub print_branches_names {
        my $self = shift;

        foreach my $branch_name (keys %{ $branches_of{ident $self} }) {
            printf "%s\n", $branch_name;
        }
    }

    sub find_by_zip {
        my $self = shift;
        my $zip  = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_zip() eq qq{$zip} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_name {
        my $self = shift;
        my $name = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_name() eq qq{$name} }
                            values %{ $branches_of{ident $self} };
        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_name_like {
        my $self = shift;
        my $name = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_name() =~ qr{$name} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_address {
        my $self    = shift;
        my $address = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_address() eq qq{$address} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_address_like {
        my $self    = shift;
        my $address = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_address() =~ qr{$address} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_type {
        my $self = shift;
        my $type = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_type() eq qq{$type} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_geo {
        my $self     = shift;
        my $args_ref = shift;

        my @branches = grep{ $_->get_geo()->{x} eq $args_ref->{lat}
                             and $_->get_geo()->{y} eq $args_ref->{lon} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_city {
        my $self = shift;
        my $city = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_city() eq qq{$city} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_city_like {
        my $self = shift;
        my $city = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_city() =~ qr{$city} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_city_part {
        my $self      = shift;
        my $city_part = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_city_part() eq qq{$city_part} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_city_part_like {
        my $self      = shift;
        my $city_part = _sanity_check_scalar_param(shift);

        my @branches = grep{ $_->get_city_part() =~ qr{$city_part} }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_open_at {
        my $self     = shift;
        my $args_ref = shift; # { Day => "", Time => "" }

        my @branches = grep{ $_->is_open($args_ref) }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_closed_at {
        my $self     = shift;
        my $args_ref = shift; # { Day => "", Time => "" }

        my @branches = grep{ $_->is_closed($args_ref) }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_open_during {
        my $self     = shift;
        my $args_ref = shift; # { Day => "", StartTime => "", EndTime => "" }

        my @branches = grep{ $_->is_open_during($args_ref) }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_closed_during {
        my $self     = shift;
        my $args_ref = shift; # { Day => "", StartTime => "", EndTime => "" }

        my @branches = grep{ $_->is_closed_during($args_ref) }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub find_by_day_break_on {
        my $self     = shift;
        my $args_ref = shift; # { Day => "" }

        my @branches = grep{ $_->has_day_break_on($args_ref) }
                            values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }

    sub get_all {
        my $self = shift;

        my @branches = values %{ $branches_of{ident $self} };

        return $self->_return_undef_or_all(\@branches);
    }
}

1;

__END__
