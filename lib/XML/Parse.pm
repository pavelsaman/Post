package XML::Parse;

use 5.030002;
use strict;
use warnings;
use Readonly;
use XML::Twig;
use Class::Std;
use Carp qw(croak);
use Daytime::Day qw(get_all_eng_days get_czech_day);

our $VERSION = 0.001;

###############################################################################
{
    Readonly my $DEFAULT_ENCODING  => q{utf-8};

    my %branches_xml_of :ATTR( :get<raw_xml>  );
    my %encoding_of_xml :ATTR( :get<encoding> );
    
    sub BUILD {
        my ($self, $ident, $args_ref) = @_;

        $branches_xml_of{$ident} = $args_ref->{xml};
        $encoding_of_xml{$ident} = $args_ref->{encoding} // $DEFAULT_ENCODING;

        return;
    }

    sub _sanity_check_look_for {
        my $look_for_ref = shift;

        if (not defined $look_for_ref->{root}
            or not defined $look_for_ref->{zip}
            or not defined $look_for_ref->{name}
            or not defined $look_for_ref->{address}
            or not defined $look_for_ref->{type}
            or not defined $look_for_ref->{geo_x}
            or not defined $look_for_ref->{geo_y}
            or not defined $look_for_ref->{city}
            or not defined $look_for_ref->{city_part}
            or not defined $look_for_ref->{opening_hours}) {
            croak __PACKAGE__ . "::_sanity_check_look_for: " . "missing keys";    
        }        

        return $look_for_ref;
    }

    sub parse {
        my $self         = shift;
        my $look_for_ref = _sanity_check_look_for(shift);

        my $ident = ident $self;
        my %branches = ();
        
        my $t = XML::Twig->new()->parse($branches_xml_of{$ident}, 
            ProtocolEncoding => $encoding_of_xml{$ident}
        );

        # basic branch info
        my $branch_id = 1;
        foreach my $branch_xml ($t->findnodes($look_for_ref->{root})) {
            my @el = $branch_xml->findnodes($look_for_ref->{name});
            $branches{$branch_id}{name} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{zip});
            $branches{$branch_id}{zip} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{type});
            $branches{$branch_id}{type} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{address});
            $branches{$branch_id}{address} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{city});
            $branches{$branch_id}{city} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{city_part});
            $branches{$branch_id}{city_part} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{geo_x});
            $branches{$branch_id}{geo_x} = $el[0]->string_value;

            @el = $branch_xml->findnodes($look_for_ref->{geo_y});
            $branches{$branch_id}{geo_y} = $el[0]->string_value;

            # opening hours
            my @days = get_all_eng_days();
            foreach my $d (@days) {
                my @opening_hours = ();

                my $czech_day = get_czech_day($d);
                my $xpath = $look_for_ref->{opening_hours};                
                $xpath =~ s/{S}/$czech_day/;

                foreach my $opening_hour_node ($branch_xml->findnodes($xpath)) {
                    my $node_from = $look_for_ref->{opening_hours_from};
                    @el = $opening_hour_node->findnodes($node_from);
                    push @opening_hours, $el[0]->string_value;

                    my $node_to = $look_for_ref->{opening_hours_to};
                    @el = $opening_hour_node->findnodes($node_to);
                    push @opening_hours, $el[0]->string_value;
                }

                $branches{$branch_id}{opening_hours}{$d} = \@opening_hours;
            }

            $branch_id++;
        }

        return \%branches;
    }
}

1;

__END__