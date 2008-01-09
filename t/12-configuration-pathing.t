#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More qw/no_plan/;
use Catalyst::Test 'TestCatalystPathing';

my $scratch = TestCatalystPathing->scratch;
my $response;
ok($response = request('http://localhost/'));

ok($response = request('http://localhost/fruit-salad'));
is($response->content, <<_END_);
<link rel="stylesheet" type="text/css" href="http://localhost/static/built/assets.css" />
<script src="http://localhost/static/built/assets.js" type="text/javascript"></script>
_END_

is($scratch->read("root/static/built/assets.css"), "div.auto{font-weight:bold;color:green;}div.apple{color:red;}div.apple{color:blue;}");
is($scratch->read("root/static/built/assets.js"), 'function calculate(){return 1*30/23;}
var auto=8+4;alert("Automatically "+auto);var apple=1+4;alert("Apple is "+apple);')
