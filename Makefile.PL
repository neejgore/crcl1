use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
    'DBIx::Class' => '0',
    'DBIx::Class::TimeStamp' => 0,
    'Modern::Perl' => '0',
    'Getopt::Long' => '0',
    'Pod::Usage' => '0',
    'WWW::Mechanize' => '0', 
    'YAML' => '0',
    'Web::Scraper' => '0',
    'FindBin' => '0',
    'JSON::XS' => '0',
    'Text::CSV_XS' => '0',
    'DateTime' => '0',
    'Facebook::Graph' => '0',
    'Log::Any::App' => '0',
  },
  test      => {TESTS => 't/*.t'}
);
