use strict;
use warnings;

use SixteenColors::Paste;

my $app = SixteenColors::Paste->apply_default_middlewares(SixteenColors::Paste->psgi_app);
$app;

