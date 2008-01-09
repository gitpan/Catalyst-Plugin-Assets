package TestCatalystMinifyYUICompressor;

use strict;

use base qw/TestCatalystBase/;

__PACKAGE__->setup_(
    assets => {
        minify => "yuicompressor:./yuicompressor.jar",
    },
);

1;
