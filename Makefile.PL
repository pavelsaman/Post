use 5.030002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Post',
    ABSTRACT     => 'Query Czech Post branch information from official XML feed.',
    VERSION_FROM => 'lib/Post.pm',
    PREREQ_PM    => {
                      'XML::Twig'      => 3.52,
                      'Class::Std'     => 0.013,
                      'Readonly'       => 2.05,                     
                      'LWP::UserAgent' => 6.44,
                      'Readonly'       => 2.05,
                      'DBI'            => 1.643 
                    },
    AUTHOR       => 'Pavel Saman <pavelsamn@centrum.cz>',
    LICENSE      => 'perl',
    EXE_FILES    => ['bin/post'],
    test         => { TESTS => 't/*.t t/*/*.t' }
    #INST_SCRIPT  => '~/.local/bin'
);
