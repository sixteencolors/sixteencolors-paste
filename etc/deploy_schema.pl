#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use SixteenColors::Paste;

my $schema = SixteenColors::Paste->model( 'DB' )->schema;
$schema->deploy;
