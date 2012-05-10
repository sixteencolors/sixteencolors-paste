package SixteenColors::Paste::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

use Time::Duration ();

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die         => 1,
    WRAPPER            => 'wrapper.tt',
    expose_methods     => [ 'time_duration' ],
);

sub time_duration {
    my ($self, $c, $dt) = @_;

    my $dur = time() - $dt->epoch;
    Time::Duration::ago( $dur, 1 );
}

=head1 NAME

SixteenColors::Paste::View::HTML - TT View for SixteenColors::Paste

=head1 DESCRIPTION

TT View for SixteenColors::Paste.

=head1 SEE ALSO

L<SixteenColors::Paste>

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
