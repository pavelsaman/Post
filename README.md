# Post

Query Czech Post branch information from official XML feed.

## Description

The **post** application retrieves information from [official Czech Post XML feed](http://napostu.ceskaposta.cz/vystupy/balikovny.xml) and presents them in
loosely structures text output.

Post app provides a bunch of command-line options for searching desired branches. They could be combined in any way, but there's always a logical AND between different commands (e.g. --name and --type) and a logical OR between same commands (e.g. --name and --name). So in order to search for all branches in Prague and Brno cities, you can issue the following command: `$ post --name Praha --name Brno`. If you, however, want to search for only branches in Prague and Brno that are of type `posta`, you would do that with the following command: `$ post --name Praha --name Brno --type posta`

For more information about the command-line options, run the app with --usage
or --help options.

## Instalation

Just like other Perl module:

```
$ perl Makefile.PL
$ make
$ make test
$ make install
```

Use `bin/post` as the frontend for this app, so it's useful to copy this script into `$PATH` or use `$ make INST_SCRIPT=<dir from $PATH>`

## Usage

```
Usage: post [-n <name>] [-nl <namelike>] [-a <address>] [-al <addresslike>]
            [-z <zip_code>] [-c <city] [-cl <citylike>] [-cp <citypart>]
            [-cpl <citypartlike>] [-t <type>] [-g <geo>] [-ot <openat>]
            [-ct <closedat>] [-od <openduring>] [-cd <closedduring>] 
            [-hdb <day>] [--all] [--store] [-db <db_file>]
```

## Options

```
Options:
        -n|--name <name>                   Name of a branch
        -nl|--namelike <namelike>          Name of a branch,
                                            performs =~ when searching
        -a|--address <address>             Address of a branch
        -al|--addresslike <addresslike>    Address of a branch,
                                            performs =~ when searching
        -z|--zip <zipcode>                 Zip code of a branch
        -c|--city <city>                   City of a branch
        -cl|--citylike <citylike>          City of a branch,
                                            performs =~ when searching 
        -cp|--citypart <citypart>          City part (district) of a branch
        -cpl|--citypartlike <citypartlike> City part (distict) of a branch,
                                            performs =~ when searching 
        -t|--type <type>                   Type of a branch (posta, depo, "" 
                                            which equals an unknown type)
        -g|--geo <geo>                     Geo info of a branch in the following
                                            format: lat=1044557.63 lon=735997.36
        -ot|--openat <openat>              Day and Time of a branch,
                                            in the following format:
                                           Day=Saturday Time:10:00
        -ct|--closedat <closedat>          Day and Time of a branch,
                                            in the following format:
                                           Day=Saturday Time:10:00
        -od|--openduring <openduring>      Day and Time of a branch,
                                            in the following format:
                                            Day=Saturday StartTime:10:00
                                            EndTime=18:00
        -cd|--closedduring <closedduring>  Day and Time of a branch,
                                            in the following format:
                                            Day=Saturday StartTime:10:00
                                            EndTime=20:00
        -hdb|--hasdaybreakon <day>         Day of a branch in the following
                                            format: Day=Monday 
        --all                              Returns all branches.
        --store                            Updates local SQLite DB of branches 
                                            and their opening hours 
        -db|--dbfile <db_file>             Path to a SQLite DB file.

        --version                          Prints version info  
        --usage                            Prints the usage summary of this help
        --help                             Prints this help message       
        --man                              Prints the complete manpage
                                            [not-yet-implemented]
```

## Examples

To see branches only in Prague that are open on Saturday between 10:00 and
12:00:

```
$ post --city Praha --openduring Day=Saturday StartTime=10:00 EndTime=12:00
```

To see branches closed on Sunday at 1p.m.:

```
$ post -ct Day=Sunday Time=13:00
```
To see branches closed tomorrow at 1p.m.:

```
$ post -ct Day=Tomorrow Time=13:00
```
You can use one of the following 3 aliases: Yesterday, Today, Tomorow.

To see all depo branches in Ostrava:

```
$ post -t depo -c Ostrava
```

## Official XML feed

http://napostu.ceskaposta.cz/vystupy/balikovny.xml

## More information

Read more information in `doc/` folder.