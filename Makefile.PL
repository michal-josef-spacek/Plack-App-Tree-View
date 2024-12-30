use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Plack application for tree view.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Plack-App-Tree-View';
perl_version 5.008;
readme_from 'View.pm';
recursive_author_tests('xt');
requires 'Plack::Component::Tags::HTML' => 0;
requires 'Plack::Util::Accessor' => 0;
requires 'Tags::HTML::Tree' => 0.06;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Plack-App-Tree-View/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Plack-App-Tree-View';
resources 'repository' => 'git://github.com/michal-josef-spacek/Plack-App-Tree-View';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
