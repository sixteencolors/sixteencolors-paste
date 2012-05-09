package SixteenColors::Paste::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use Image::TextMode::Loader;
use Image::TextMode::Renderer::GD;
use HTML::FillInForm;

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    if( lc( $c->req->method ) eq 'post' && $c->req->params->{ file } ) {
        my $paste = $c->model( 'DB::Paste' )->create( {} );
        my $id = $paste->url_fragment;

        my $upload = $c->req->upload( 'file' );
        my( $ext ) = $upload->basename =~ m{\.([^.]+)$};
        $ext = lc( $ext );

        $upload->copy_to( $c->path_to( "root/static/paste/${id}.${ext}" ) );

        $c->stash(
            id => $id,
            template => 'uploaded.tt',
            url => $c->uri_for( '/', $id ),
        );
        return;
    }
}

sub instance :Chained('/') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $paste = $c->model( 'DB::Paste' )->find( { url_fragment => $id }, { key => 'paste_url_fragment' } );

    if( !$paste ) {
        $c->response->body( 'Page not found' );
        $c->response->status(404);
        return;
    }

    my $dir = Path::Class::Dir->new( $c->path_to( "root/static/paste/" ) );
    my $file;
    while( $file = $dir->next ) {
        last if $file->basename =~ m{^$id\.};
    }

    $c->stash(
        id => $id,
        file => $file,
        paste => $paste
    );
}

sub view :Chained('instance') PathPart('') Args(0) {
    my ( $self, $c) = @_;
    $c->stash( fillform => 1 );
}

sub render :Chained('instance') PathPart('render') Args(0) {
    my ( $self, $c ) = @_;

    my $opts      = $c->req->params;
    my $read_opts = { width => delete $opts->{ width } };

    my $file   = $c->stash->{ file };
    my $img    = Image::TextMode::Loader->load( [ "$file", $read_opts ] );
    my $render = Image::TextMode::Renderer::GD->new;

    $c->res->body( $render->fullscale( $img, $opts ) );
    $c->res->content_type( 'image/png' );
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->forward( 'render_view' );
    $c->fillform( $c->req->params ) if $c->stash->{ fillform };
}

sub render_view : ActionClass('RenderView') { }

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Paste::Controller::Root - Root Controller for SixteenColors::Paste

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=head2 default

Standard 404 error page

=head2 end

Attempt to render a view, if needed.

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
