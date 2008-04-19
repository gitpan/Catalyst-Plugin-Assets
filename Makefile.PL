use inc::Module::Install;

name     'Catalyst-Plugin-Assets';
all_from 'lib/Catalyst/Plugin/Assets.pm';
author   'Robert Krimen <rkrimen@cpan.org>';

build_requires 'Test::More';
build_requires 'Directory::Scratch';
build_requires 'FindBin';
build_requires 'Catalyst::Test';
build_requires 'HTML::Declare';

requires 'Catalyst';
requires 'Class::Accessor::Fast';
requires 'File::Assets' => '0.056';
requires 'JavaScript::Minifier';
requires 'CSS::Minifier';

auto_install;

WriteAll;

