package t::TestCatalystMinify1;

use strict;

use base qw/t::TestCatalystBase/;

__PACKAGE__->setup_(
    assets => {
        minify => 1,
    },
);

1;
