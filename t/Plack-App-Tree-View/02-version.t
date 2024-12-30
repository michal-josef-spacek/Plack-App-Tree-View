use strict;
use warnings;

use Plack::App::Tree::View;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Plack::App::Tree::View::VERSION, 0.01, 'Version.');
