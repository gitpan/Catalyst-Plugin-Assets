package t::TestCatalystMinifyYUICompressor;

use strict;

use base qw/t::TestCatalystBase/;

__PACKAGE__->setup_(
    'Plugin::Assets' => {
        minify => "yui-compressor:./yuicompressor.jar",
    },
);

1;
