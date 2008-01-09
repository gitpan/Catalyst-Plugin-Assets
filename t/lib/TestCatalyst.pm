package TestCatalyst;

use strict;

use base qw/TestCatalystBase/;

__PACKAGE__->setup_;

sub yui_compressor : Path('yui-compressor') {
    my ($self, $catalyst) = @_;
    
    $catalyst->assets->filter("yuicompressor:./yuicompressor.jar" => output => "static/yui-compressor/", type => "css");
    $catalyst->assets->include("static/yui-compressor.css");
    $catalyst->assets->include("static/yui-compressor.js");
    $catalyst->response->output($catalyst->assets->export);
}

sub concat : Path('concat') {
    my ($self, $catalyst) = @_;
    
    $catalyst->assets->filter(concat => output => "static/concat/");
    $catalyst->assets->include("static/concat.css");
    $catalyst->assets->include("static/concat.js");
    $catalyst->response->output($catalyst->assets->export);
}

1;
