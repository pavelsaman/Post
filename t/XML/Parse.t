use Test::More qw(no_plan);
use utf8;

use XML::Parse;

my $class     = 'XML::Parse';
my $test_data = '<?xml version="1.0" encoding="UTF-8"?>
<zv xmlns="http://www.cpost.cz/schema/aict/zv_2"
    xmlns:xsi="http://www.cpost.cz/schema/aict/zv_2" xsi:schemaLocation="http://www.cpost.cz/schema/aict/zv_2">
    <generated>2020-04-13T17:52:16</generated>
    <row>
        <PSC>10003</PSC>
        <NAZEV>Depo Praha 701</NAZEV>
        <ADRESA>Sazečská 598/7, Malešice, 10003, Praha</ADRESA>
        <TYP>depo</TYP>
        <OTEV_DOBY>
            <den name="Pondělí">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Úterý">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Středa">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Čtvrtek">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Pátek">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Sobota"/>
            <den name="Neděle"/>
        </OTEV_DOBY>
        <SOUR_X>1044557.63</SOUR_X>
        <SOUR_Y>735997.36</SOUR_Y>
        <OBEC>Praha</OBEC>
        <C_OBCE>Malešice</C_OBCE>
    </row>
    <row>
        <PSC>10004</PSC>
        <NAZEV>Praha 104</NAZEV>
        <ADRESA>Nákupní 389/3, Štěrboholy, 10004, Praha</ADRESA>
        <TYP>posta</TYP>
        <OTEV_DOBY>
            <den name="Pondělí">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Úterý">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Středa">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Čtvrtek">
                <od_do>
                    <od>08:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Pátek">
                <od_do>
                    <od>08:00</od>
                    <do>12:00</do>
                </od_do>
                <od_do>
                    <od>13:00</od>
                    <do>16:00</do>
                </od_do>
            </den>
            <den name="Sobota"/>
            <den name="Neděle"/>
        </OTEV_DOBY>
        <SOUR_X>1045845</SOUR_X>
        <SOUR_Y>734386.14</SOUR_Y>
        <OBEC>Praha</OBEC>
        <C_OBCE>Štěrboholy</C_OBCE>
    </row>
</zv>';

###############################################################################
# new object

my $parse = $class->new({ xml => $test_data });
isa_ok($parse, $class);

###############################################################################
# correct outcome

my $expected_outcome = {
    1 => {
        name          => q{Depo Praha 701},
        zip           => q{10003},
        type          => q{depo},
        address       => q{Sazečská 598/7, Malešice, 10003, Praha},
        city          => q{Praha},
        city_part     => q{Malešice},
        geo_x         => q{1044557.63},
        geo_y         => q{735997.36},
        opening_hours => {
            Monday    => [q{08:00}, q{16:00}],
            Tuesday   => [q{08:00}, q{16:00}],
            Wednesday => [q{08:00}, q{16:00}],
            Thursday  => [q{08:00}, q{16:00}],
            Friday    => [q{08:00}, q{16:00}],
            Saturday  => [],
            Sunday    => []
        }
    },
    2 => {
        name          => q{Praha 104},
        zip           => q{10004},
        type          => q{posta},
        address       => q{Nákupní 389/3, Štěrboholy, 10004, Praha},
        city          => q{Praha},
        city_part     => q{Štěrboholy},
        geo_x         => q{1045845},
        geo_y         => q{734386.14},
        opening_hours => {
            Monday    => [q{08:00}, q{16:00}],
            Tuesday   => [q{08:00}, q{16:00}],
            Wednesday => [q{08:00}, q{16:00}],
            Thursday  => [q{08:00}, q{16:00}],
            Friday    => [q{08:00}, q{12:00}, q{13:00}, q{16:00}],
            Saturday  => [],
            Sunday    => []
        }
    }
};

my $look_for = {
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

is_deeply($parse->parse($look_for), $expected_outcome);

###############################################################################
# default encoding

my $parse = $class->new({ xml => $test_data });
isa_ok($parse, $class);

is($parse->get_encoding(), q{utf-8});

###############################################################################
# custom encoding

my $parse = $class->new({ xml => $test_data, encoding => q{unicode} });
isa_ok($parse, $class);

is($parse->get_encoding(), q{unicode});