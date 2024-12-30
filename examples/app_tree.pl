#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Plack::App::Tree::View;
use Plack::Runner;
use Tags::Output::Indent;
use Tree;

# Tree example.
my $tree = Tree->new('Root');
my %node;
foreach my $node_string (qw/H I J K L M N O P Q/) {
         $node{$node_string} = Tree->new($node_string);
}
$tree->add_child($node{'H'});
$node{'H'}->add_child($node{'I'});
$node{'I'}->add_child($node{'J'});
$node{'H'}->add_child($node{'K'});
$node{'H'}->add_child($node{'L'});
$tree->add_child($node{'M'});
$tree->add_child($node{'N'});
$node{'N'}->add_child($node{'O'});
$node{'O'}->add_child($node{'P'});
$node{'P'}->add_child($node{'Q'});

# Run application.
my $app = Plack::App::Tree::View->new(
        'css' => CSS::Struct::Output::Indent->new,
        'generator' => 'Plack::App::Tree::View',
        'tags' => Tags::Output::Indent->new(
                'preserved' => ['style'],
                'xml' => 1,
        ),
        'tree' => $tree,
)->to_app;
Plack::Runner->new->run($app);

# Output:
# HTTP::Server::PSGI: Accepting connections at http://0:5000/

# > curl http://localhost:5000/
# TODO