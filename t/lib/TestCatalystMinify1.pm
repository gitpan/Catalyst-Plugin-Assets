package TestCatalystMinify1;

use strict;

use base qw/TestCatalystBase/;

__PACKAGE__->setup_(
    assets => {
        minify => 1,
    },
);

1;
