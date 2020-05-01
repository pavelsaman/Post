package Daytime::Time;

use 5.030002;
use strict;
use warnings;
use Readonly;

use Exporter 'import';
our @EXPORT      = qw();
our @EXPORT_OK   = qw(is_allowed_time);
our %EXPORT_TAGS = (all => [ qw(is_allowed_time) ],
                    ALL => [ qw(is_allowed_time) ]
                   )
                   ;

our $VERSION = 0.003;

Readonly my $ALLOWED_TIME_FORMAT => qr/^[0-2][0-9][:][0-5][0-9]$/;

sub is_allowed_time {
    my $time = shift;

    if (not $time =~ $ALLOWED_TIME_FORMAT) {
        return;
    }

    return $time;
}

1;

__END__