package Remote::Remote;

use strict;
use warnings;
use 5.030002;
use Readonly;
use Class::Std;
use LWP::UserAgent;
use Carp qw(croak);
use Config::Reader 0.002;

our $VERSION = 0.006;

###############################################################################
{
    sub _choose_url {
        my $args_ref = shift;

        if (defined $args_ref and not ref $args_ref eq ref {}) {
            croak __PACKAGE__ . ": not a hash reference";
        }

        my %args = ();
        $args{base_url} = $args_ref->{base_url}
            || Config::Reader::get_base_url_with_protocol();
        $args{resource} = $args_ref->{resource} || Config::Reader::get_resource();
        $args{url}      = join q{}, $args{base_url}, $args{resource};

        return \%args;
    }

    sub request_xml {
        my $args_ref = _choose_url(shift);        

        # issue the request
        my $ua = LWP::UserAgent->new(protocols_allowed => ['http', 'https']);
        my $res = $ua->get($args_ref->{url});

        # return xml data
        if ($res->is_success) {
            return $res->decoded_content;
        }

        return; 
    }
}

1;

__END__