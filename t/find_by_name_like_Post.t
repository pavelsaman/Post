use Test::More qw(no_plan);
use Test::MockModule;

use Post;

my $class     = 'Post';
my $method    = 'find_by_name_like';
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

# mock http req to get XML data
my $xml = Test::MockModule->new('Remote::Remote');
$xml->mock('request_xml', sub { return $test_data });

###############################################################################
# creates a new object

my $post = $class->new();

isa_ok($post, $class);

###############################################################################
# find_by_name()

# returns a list ref
my $branches = $post->$method(q{Praha});
# return an array
is(ref $branches, ref []);
# returns 2 branches
is(@$branches, 2);
# correct value
my @found = grep{ $_->get_name() eq q{Praha 104} } @$branches;
is($found[0]->get_name(), q{Praha 104});
my @found = grep{ $_->get_name() eq q{Depo Praha 701} } @$branches;
is($found[0]->get_name(), q{Depo Praha 701});

# returns a list ref - only one value
my $branches = $post->$method("Depo Praha 701");
# return an array
is(ref $branches, ref []);
# returns a correct count
is(@$branches, 1);
# correct value
is($branches->[0]->get_name(), q{Depo Praha 701});

# fails when no arg is passed
my $res = eval{ $post->$method() };
my $error = $@;
like($error, qr/no arg passed/);

# fails if a hash ref is passed
my $res = eval{ $post->$method({ zip => "Depo Praha 701"}) };
my $error = $@;
like($error, qr/hash ref passed/);

# fails if an array ref is passed
my $res = eval{ $post->$method(["Depo Praha 701"]) };
my $error = $@;
like($error, qr/array ref passed/);

