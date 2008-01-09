#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Plugin::Assets' );
}

diag( "Testing Catalyst::Plugin::Assets $Catalyst::Plugin::Assets::VERSION, Perl $], $^X" );
