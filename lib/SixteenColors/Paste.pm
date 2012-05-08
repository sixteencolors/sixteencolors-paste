package SixteenColors::Paste;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'SixteenColors::Paste',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

sub fillform {
    my $c    = shift;
    my $fdat = shift || $c->request->parameters;
    my $additional_params = shift;

    return 1 unless ($c->response->{body});

    $c->response->output(
        HTML::FillInForm->new->fill(
            scalarref => \$c->response->{body},
            fdat      => $fdat,
            %$additional_params,
        ) || ''
    );
}

=head1 NAME

SixteenColors::Paste - Catalyst based application

=head1 SYNOPSIS

    script/sixteencolors_paste_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<SixteenColors::Paste::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
