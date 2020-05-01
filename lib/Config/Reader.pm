package Config::Reader;

use strict;
use warnings;
use Readonly;
use Class::Std;

our $VERSION = 0.002;

###############################################################################
{
    Readonly my $BASE_URL  => q{napostu.ceskaposta.cz};
    Readonly my $RESOURCE  => q{/vystupy/balikovny.xml};  
    Readonly my $ENCODING  => q{utf-8};  
    Readonly my $LOOK_FOR  => {
        root               => q{/zv/row},
        name               => q{./NAZEV},
        zip                => q{./PSC},
        address            => q{./ADRESA},
        type               => q{./TYP},
        geo_x              => q{./SOUR_X},
        geo_y              => q{./SOUR_Y},
        city               => q{./OBEC},
        city_part          => q{./C_OBCE},
        opening_hours      => q{./OTEV_DOBY/den[@name="{S}"]/od_do},
        opening_hours_from => q{./od},
        opening_hours_to   => q{./do}
    };    

    sub get_base_url {
        return $BASE_URL;
    }

    sub get_base_url_with_protocol {
        return join q{}, q{http://}, $BASE_URL;
    }

    sub get_resource {
        return $RESOURCE;
    }

    sub get_encoding {
        return $ENCODING;
    }

    sub get_branch_xpath {
        return $LOOK_FOR;
    }
}

1;

__END__