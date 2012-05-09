package SixteenColors::Paste::Schema::Result::Paste;

use strict;
use warnings;

use parent qw( DBIx::Class );

use Encode::Base58 ();
use Number::Bytes::Human ();

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'paste' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    url_fragment => {
        data_type   => 'varchar',
        size        => 256,
        is_nullable => 1,
    },
    filename => {
        data_type   => 'varchar',
        size        => 256,
        is_nullable => 0,
    },
    filesize => {
        data_type     => 'bigint',
        is_nullable   => 0,
        default_value => 0,
    },
    title => {
        data_type   => 'varchar',
        size        => 256,
        is_nullable => 1,
    },
    views => {
        data_type     => 'bigint',
        is_nullable   => 0,
        default_value => 0,
    },
    ctime => {
        data_type     => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->add_unique_constraint( [ 'url_fragment' ] );

sub insert {
    my ( $self, @args ) = @_;
    $self->next::method( @args );
    $self->update(
        { url_fragment => Encode::Base58::encode_base58( $self->id ) } );
    return $self;
}

sub filename_ext {
    my $self = shift;
    my ( $ext ) = $self->filename =~ m{\.([^.]+)$};
    return $ext;
}

sub filesize_text {
    my $self = shift;
    return  Number::Bytes::Human::format_bytes( $self->filesize );
}

1;
