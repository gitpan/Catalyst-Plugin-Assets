package Catalyst::Plugin::Assets;

use warnings;
use strict;

=head1 NAME

Catalyst::Plugin::Assets - Manage and minify .css and .js assets in a Catalyst application

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    # In your Catalyst application... 

    use Catalyst qw/-Debug Assets Static::Simple/;
    # Static::Simple is not *required*, but C::P::Assets does not serve files by itself!
    
    # This is all you need. Now your $catalyst object will now have an ->assets method.

    # Sometime during the request ...

    sub some_action : Local {
        my ($self, $catalyst) = @_;
        
        ...

        $catalyst->assets->include("stylesheet.css");

        ...
    }

    # Then, in your .tt (or whatever you're using for view processing):

    <html>
    <head><title>[% title %]</title>

    [% catalyst.assets.export %]

    </head>
    <body>

    ...
    
=head1 DESCRIPTION

Catalyst::Plugin::Assets integrates L<File::Assets> into your Catalyst application. Essentially, it provides a unified way to include .css and .js assets from different parts of your program. When you're done processing a request, you can use $catalyst->assets->export() to generate HTML or $catalyst->assets->exports() to get a list of assets.

In addition, C::P::Assets includes support for minification via YUI compressor, L<JavaScript::Minifier>, and L<CSS::Minifier> (and a rudimentary concatenation filter)

Note that Catalyst::Plugin::Assets does not serve files directly, it will work with Static::Simple or whatever static-file-serving mechanism you're using.

=head2 A brief description of L<File::Assets>

File::Assets is a tool for managing JavaScript and CSS assets in a (web) application. It allows you to "publish" assests in one place after having specified them in different parts of the application (e.g. throughout request and template processing phases).

File::Assets has the added bonus of assisting with minification and filtering of assets. Support is built-in for YUI Compressor (L<http://developer.yahoo.com/yui/compressor/>), L<JavaScript::Minifier>, and L<CSS::Minifier>. Filtering is fairly straightforward to implement, so it's a good place to start if need a JavaScript or CSS preprocessor (e.g. something like HAML L<http://haml.hamptoncatlin.com/>)

=head1 CONFIGURATION

    path        # A path to automatically look for assets under (e.g. "/static" or "/assets")

                # This path will be automatically prepended to includes, so that instead of
                # doing ->include("/static/stylesheet.css") you can just do ->include("stylesheet.css")
                

    output      # The path to output the results of minification under (if any).

                # For example, if output is "built/" (the trailing slash is important), then minified assets will be
                # written to "root/<assets-path>/built/..."


    minify      # '1' to use JavaScript::Minifier and CSS::Minifier for minification
                # 'yui-compressor:<path-to-yui-compressor-jar>' to use YUI Compressor

=cut

use File::Assets;
use base qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/_assets/);

=head1 METHODS

=cut

sub setup {
    my $catalyst = shift;
    
    $catalyst->NEXT::setup(@_);
    
    my $config = $catalyst->config->{assets} ||= {};
    
    $config->{stash_var} = "assets" unless exists $config->{stash_var};
}

sub prepare {
    my $self = shift;
    
    my $catalyst = $self->NEXT::prepare(@_);

    $catalyst->assets; # Instantiate some new assets to use for this request

    return $catalyst;
}

=head2 assets

Return the L<File::Assets> object that exists throughout the lifetime of the request

=cut

sub assets {
    my $self = shift;
    return $self->{_assets} ||= do {
        my $assets = $self->make_assets;
        my $config = $self->config->{assets};
        if (defined (my $stash_var = $config->{stash_var})) {
            $self->stash->{$stash_var} = $assets;
        }
        $assets;
    }
}

sub make_assets {
    my $self = shift;

    my $config = $self->config->{assets};
    my $path = $config->{path};
    my $output = $config->{output};

    my $assets = File::Assets->new(base => [ $self->uri_for("/"), $self->path_to("root"), $path ]);

    if (my $minify = $config->{minify}) {
        my @filter;
        if (ref $minify eq "HASH" && ! $minify->{disable}) {
            for(qw/css js/) {
                push @filter, [ $minify->{$_}, type => $_, output => $output ] if $minify->{$_};
            }
        }
        elsif (ref $minify eq "ARRAY") {
            if ($minify->[0] && ref $minify->[0] eq "HASH") {
                for my $filter (@$minify) {
                    my %filter = %$filter;
                    $filter = delete $filter{filter};
                    push @filter, [ $filter, output => $output, %filter ];
                }
            }
            else {
                push @filter, [ @$minify, type => $_, output => $output ] for qw/css js/;
            }
        }
        else {
            if ($minify =~ m/^\s*(?:on|yes|true|1)\s*$/i) {
                push @filter, [ qw/minifier-js type js/, output => $output ];
                push @filter, [ qw/minifier-css type css/, output => $output ];
            }
            elsif ($minify =~ m/^\s*(?:off|no|false|0)\s*$/i) {
            }
            else {
                push @filter, [ $minify, type => $_, output => $output ] for qw/css js/;
            }
        }

        $assets->filter(@$_) for @filter;
    }

    if (my $customize = $config->{customize}) {
        $customize->($assets, $self);
    }

    return $assets;
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-plugin-assets at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Plugin-Assets>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Plugin::Assets


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Plugin-Assets>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Plugin-Assets>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Plugin-Assets>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Plugin-Assets>

=back

=head1 SEE ALSO

L<File::Assets>, L<JavaScript::Minifier>, L<CSS::Minifier>, L<http://developer.yahoo.com/yui/compressor/>, L<Catalyst>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Catalyst::Plugin::Assets
