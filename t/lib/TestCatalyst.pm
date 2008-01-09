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

__END__

my $scratch = Directory::Scratch->new;
$scratch->create_tree({
    (map { $_ => "/* Test css file for $_ */\n" } map { "root/static/$_.css" } qw/apple auto yui-compressor concat/),
    (map { $_ => "/* Test js file for $_ */\n" } map { "root/static/$_.js" } qw/apple auto yui-compressor concat/),
});

sub scratch {
    return $scratch;
}

TestCatalyst->config(
    home => $scratch->base,
    name => 'TestCatalyst',
    debug => 1,
);

TestCatalyst->setup(qw/Assets/);

sub auto : Private {
    my ($self, $catalyst) = @_;
    $catalyst->assets->include("static/auto.css");
}

sub default : Private {
    my ($self, $catalyst) = @_;
    
    $catalyst->response->output('Nothing happens.');
}

sub fruit_salad : Path('fruit-salad') {
    my ($self, $catalyst) = @_;
    
    $catalyst->assets->include("static/banana.js");
    $catalyst->assets->include("static/apple.css");
    $catalyst->response->output($catalyst->assets->export);
}

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

__END__

use File::Spec::Functions;
use FindBin;

our $VERSION = '0.01';

TestApp->config(
    name => 'TestApp',
    debug => 1,
);

my @plugins = qw/Static::Simple/;

# load the SubRequest plugin if available
eval { 
    require Catalyst::Plugin::SubRequest; 
    die unless Catalyst::Plugin::SubRequest->VERSION ge '0.08';
};
push @plugins, 'SubRequest' unless ($@);

TestApp->setup( @plugins );

sub incpath_generator {
    my $c = shift;
    
    return [ $c->config->{root} . '/incpath' ];
}

sub default : Private {
    my ( $self, $c ) = @_;
    
    $c->res->output( 'default' );
}

sub subtest : Local {
    my ( $self, $c ) = @_;

    $c->res->output( $c->subreq('/subtest2') );
}

sub subtest2 : Local {
    my ( $self, $c ) = @_;
    
    $c->res->output( 'subtest2 ok' );
}

sub serve_static : Local {
    my ( $self, $c ) = @_;
    
    my $file = catfile( $FindBin::Bin, 'lib', 'TestApp.pm' );
    
    $c->serve_static_file( $file );
}

sub serve_static_404 : Local {
    my ( $self, $c ) = @_;
    
    my $file = catfile( $FindBin::Bin, 'lib', 'foo.pm' );
    
    $c->serve_static_file( $file );
}

1;
