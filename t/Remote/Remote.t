use Test::More qw(no_plan);
use Test::MockModule;
use lib './t/Remote';
use MockHTTP;

use Remote::Remote qw(:test);

###############################################################################
 
my $class = 'Remote::Remote';
my $mock_xml_data = '<zv>
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
                    <do>11:00</do>
                </od_do>
                <od_do>
                    <od>13:00</od>
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
</zv>';

my $default_expected_base_url = q{http://napostu.ceskaposta.cz};
my $default_expected_resource = q{/vystupy/balikovny.xml};

# create a mock object
my $mock_http = MockHTTP->new();
# mock http get method
my $ua = Test::MockModule->new('LWP::UserAgent');
$ua->mock('get', sub { $mock_http });

###############################################################################
# request_xml - success

is(Remote::Remote::request_xml(), $mock_xml_data);

###############################################################################
# request_xml - success

# mock is_success method of my mock class
my $ua = Test::MockModule->new('MockHTTP');
$ua->mock('is_success', sub { 0 });

is(Remote::Remote::request_xml(), undef);

###############################################################################
# _choose_url - passed params has priority

is_deeply(Remote::Remote::_choose_url({ base_url => q{a}, resource => q{b} }),
    { base_url => q{a}, resource => q{b}, url => q{ab} });

####

is_deeply(Remote::Remote::_choose_url({ base_url => "a" }),
    {
        base_url => q{a},
        resource => $default_expected_resource,
        url      => join q{}, q{a}, $default_expected_resource
    }
);

####

is_deeply(Remote::Remote::_choose_url({ resource => q{b} }),
    {
        base_url => $default_expected_base_url,
        resource => q{b},
        url      => join q{}, $default_expected_base_url, q{b}
    }
);

###############################################################################
# _choose_url - no params == default params

is_deeply(Remote::Remote::_choose_url(),
    {
        base_url => $default_expected_base_url,
        resource => $default_expected_resource,
        url      => $default_expected_base_url . $default_expected_resource
    }
);

###############################################################################
# _choose_url - misspelled params == default params

is_deeply(Remote::Remote::_choose_url({ base => q{a}, res => q{b} }),
    {
        base_url => $default_expected_base_url,
        resource => $default_expected_resource,
        url      => $default_expected_base_url . $default_expected_resource
    }
);

###############################################################################
# _choose_url - not a hash ref

my $res = eval{ Remote::Remote::_choose_url([]) };
my $err = $@;

like($err, qr/not a hash reference/);

####

my $res = eval{ Remote::Remote::_choose_url(q{}, q{}) };
my $err = $@;

like($err, qr/not a hash reference/);
