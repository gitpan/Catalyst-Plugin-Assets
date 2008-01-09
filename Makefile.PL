use inc::Module::Install;

name     'Catalyst-Plugin-Assets';
all_from 'lib/Catalyst/Plugin/Assets.pm';
author   'Robert Krimen <rkrimen@cpan.org>';

build_requires 'Test::More';
build_requires 'Directory::Scratch';
build_requires 'FindBin';
build_requires 'Catalyst::Test';

requires 'Catalyst';
requires 'Class::Accessor::Fast';
requires 'File::Assets';
requires 'JavaScript::Minifier';
requires 'CSS::Minifier';

auto_install;

WriteAll;

