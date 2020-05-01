package Daytime::Day;

use 5.030002;
use strict;
use warnings;
use Readonly;
use DateTime;

use Exporter 'import';
our @EXPORT    = qw();
our @EXPORT_OK = qw(get_czech_day
                    get_all_eng_days
                    get_all_cze_days
                    day_exists
                    get_day_number
                    get_day_name
                   )
                   ;
our %EXPORT_TAGS = (all => \@EXPORT_OK,
                    cze => [ qw(get_czech_day get_all_cze_days) ],
                    eng => [ qw(get_all_eng_days get_day_name) ],
                    ALL => \@EXPORT_OK,
                    CZE => [ qw(get_czech_day get_all_cze_days) ],
                    ENG => [ qw(get_all_eng_days get_day_name) ]
                   )
                   ;

our $VERSION = 0.007;

###############################################################################

Readonly my %CZECH_TRANSLATION_OF => (
    "Monday"    => "Pondělí",
    "Tuesday"   => "Úterý",
    "Wednesday" => "Středa",
    "Thursday"  => "Čtvrtek",
    "Friday"    => "Pátek", 
    "Saturday"  => "Sobota",
    "Sunday"    => "Neděle"
);

Readonly my %DAY_NUMBER_OF => (
    "Monday"    => 1,
    "Tuesday"   => 2,
    "Wednesday" => 3,
    "Thursday"  => 4,
    "Friday"    => 5,
    "Saturday"  => 6,
    "Sunday"    => 7
);

Readonly my %DAY_NAME_FOR => (
    "Yesterday" => sub { DateTime->now()->subtract(days => 1)->day_name },
    "Today"     => sub { DateTime->now()->day_name },
    "Tomorrow"  => sub { DateTime->now()->add(days => 1)->day_name }
);

###############################################################################

sub _defined {
    my ($p, $h) = @_;

    if (not defined $p) {
        return;
    }

    if (not defined $h->{$p}) {
        return;
    }

    return $p;
}

sub day_exists {
    my $day = _defined(shift, \%CZECH_TRANSLATION_OF);   

    return $day;
}

sub get_day_number {
    my $day = shift;

    if (not _defined($day, \%DAY_NUMBER_OF)) {
        return;
    }

    return $DAY_NUMBER_OF{$day};
}

sub get_day_name {
    my $alias = shift;

    if (not _defined($alias, \%DAY_NAME_FOR)) {
        return;
    }

    return $DAY_NAME_FOR{$alias}->();
}

sub get_all_eng_days {
    if (wantarray) {
        return keys %CZECH_TRANSLATION_OF;
    }

    return scalar keys %CZECH_TRANSLATION_OF;
}

sub get_czech_day {
    my $day = shift;

    if (not _defined($day, \%CZECH_TRANSLATION_OF)) {
        return;
    }

    return $CZECH_TRANSLATION_OF{$day};
}

sub get_all_cze_days {
    if (wantarray) {
        return values %CZECH_TRANSLATION_OF;
    }

    return scalar values %CZECH_TRANSLATION_OF;
}

1;

__END__