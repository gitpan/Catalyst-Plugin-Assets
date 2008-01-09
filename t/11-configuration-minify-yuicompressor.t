#!perl -w
BEGIN {
    use Test::More;
    plan skip_all => 'install ./yuicompressor.jar to enable this test' and exit unless -e "./yuicompressor.jar"
}

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More qw/no_plan/;
use Catalyst::Test 'TestCatalystMinifyYUICompressor';

my $scratch = TestCatalystMinifyYUICompressor->scratch;
my $response;
ok($response = request('http://localhost/'));

ok($response = request('http://localhost/fruit-salad'));
is($response->content, <<_END_);
<link rel="stylesheet" type="text/css" href="http://localhost/assets.css" />
<script src="http://localhost/assets.js" type="text/javascript"></script>
_END_

is($scratch->read("root/assets.css"), "div.auto{font-weight:bold;color:green;}div.apple{color:red;}div.apple{color:blue;}");
is($scratch->read("root/assets.js"), 'function calculate(){return 1*30/23}var auto=8+4;alert("Automatically "+auto);var apple=1+4;alert("Apple is "+apple)')
