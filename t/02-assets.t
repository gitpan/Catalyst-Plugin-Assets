#!perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More qw/no_plan/;
use Catalyst::Test 'TestCatalyst';

my $response;
ok($response = request('http://localhost/'));

ok($response = request('http://localhost/fruit-salad'));
is($response->content, <<_END_);
<link rel="stylesheet" type="text/css" href="http://localhost/static/auto.css" />
<script src="http://localhost/static/auto.js" type="text/javascript"></script>
<script src="http://localhost/static/apple.js" type="text/javascript"></script>
<script src="http://localhost/static/banana.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="http://localhost/static/apple.css" />
_END_

SKIP: {
    skip 'install ./yuicompressor.jar to enable this test' unless -e "./yuicompressor.jar";

    ok($response = request('http://localhost/yui-compressor'));
    is($response->content, <<_END_);
<link rel="stylesheet" type="text/css" href="http://localhost/static/yui-compressor/assets.css" />
<script src="http://localhost/static/auto.js" type="text/javascript"></script>
<script src="http://localhost/static/yui-compressor.js" type="text/javascript"></script>
_END_
}

ok($response = request('http://localhost/concat'));
is($response->content, <<_END_);
<link rel="stylesheet" type="text/css" href="http://localhost/static/concat/assets.css" />
_END_

ok(TestCatalyst->scratch->exists("root/static/concat/assets.css"));
is(TestCatalyst->scratch->read("root/static/concat/assets.css"), <<_END_);
/* Test css file for auto.css */

div.auto {
    font-weight: bold;
    color: green;
}

/* Comment at the end */

/* Test js file for auto.js */

function calculate() {
    return 1 * 30 / 23;
}

var auto = 8 + 4;

alert("Automatically " + auto);

/* Test css file for root/static/concat.css */

/* Test js file for root/static/concat.js */
_END_

1;
