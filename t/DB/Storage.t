use Test::More qw(no_plan);
use Test::MockModule;
use DBI;

use DB::Storage qw(save_branches);
use Post;

my $db_file  = q{db/post.sqlite};
my $driver   = q{SQLite};
my $dsn      = qq{DBI:$driver:dbname=$db_file};
my $userid   = q{};
my $password = q{};

###############################################################################
# db file exists and is writable

ok(-e $db_file and -w $db_file);

###############################################################################
# no data in the DB

my $db = DBI->connect($dsn, $userid, $password, { RaiseError => 1 });

# delete all
$db->do(q{delete from Branch});
$db->do(q{delete from OpeningHour});

my @rows_branch = $db->selectall_array(q{select * from Branch});
my @rows_opening_hour = $db->selectall_array(q{select * from OpeningHour});
is(scalar @rows_branch, 0);
is(scalar @rows_opening_hour, 0);

###############################################################################
# insert data

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

# create Post object
my $post = Post->new();
isa_ok($post, q{Post});

# save data into db
save_branches($post, $db_file);

# check data are in db
my @rows_branch = $db->selectall_array(q{select * from Branch});
my @rows_opening_hour = $db->selectall_array(q{select * from OpeningHour});
is(scalar @rows_branch, 2);
is(scalar @rows_opening_hour, 10);

$db->disconnect();