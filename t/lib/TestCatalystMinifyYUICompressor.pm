package TestCatalystMinifyYUICompressor;

use strict;

use base qw/TestCatalystBase/;

__PACKAGE__->setup_(
    'Plugin::Assets' => {
        minify => "yuicompressor:./yuicompressor.jar",
    },
);

1;
