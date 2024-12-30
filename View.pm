package Plack::App::Tree::View;

use base qw(Plack::Component::Tags::HTML);
use strict;
use warnings;

use Plack::Util::Accessor qw(tree generator title);
use Tags::HTML::Tree 0.06;

our $VERSION = 0.01;

sub _css {
	my ($self, $env) = @_;

	$self->{'_tags_tree'}->process_css;

	return;
}

sub _prepare_app {
	my $self = shift;

	# Defaults which rewrite defaults in module which I am inheriting.
	if (! defined $self->generator) {
		$self->generator(__PACKAGE__.'; Version: '.$VERSION);
	}

	if (! defined $self->title) {
		$self->title('Tree view');
	}

	# Inherite defaults.
	$self->SUPER::_prepare_app;

	# Init tags helper for tree.
	$self->{'_tags_tree'} = Tags::HTML::Tree->new(
		'css' => $self->css,
		'tags' => $self->tags,
	);
	$self->{'_tags_tree'}->prepare;
	$self->script_js($self->{'_tags_tree'}->script_js);

	# Set Tree object to present.
	if (defined $self->tree) {
		$self->{'_tags_tree'}->init($self->tree);
	}

	return;
}

sub _tags_middle {
	my ($self, $env) = @_;

	$self->{'_tags_tree'}->process;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Plack::App::Tree::View - Plack application to view Tree object.

=head1 SYNOPSIS

 use Plack::App::Tree::View;

 my $obj = Plack::App::Tree::View->new(%parameters);
 my $psgi_ar = $obj->call($env);
 my $app = $obj->to_app;

=head1 DESCRIPTION

Plack application which prints tree. Record is defined by L<Tree> object.

=head1 METHODS

=head2 C<new>

 my $obj = Plack::App::Tree::View->new(%parameters);

Constructor.

=over 8

=item * C<tree>

Set L<Tree> object.

It's optional.

Default value is undef.

=item * C<css>

Instance of L<CSS::Struct::Output> object.

Default value is L<CSS::Struct::Output::Raw> instance.

=item * C<generator>

HTML generator string.

Default value is 'Plack::App::Tree::View; Version: __VERSION__'

=item * C<tags>

Instance of L<Tags::Output> object.

Default value is L<Tags::Output::Raw>->new('xml' => 1) instance.

=item * C<title>

Page title.

Default value is 'Tree view'.

=back

Returns instance of object.

=head2 C<call>

 my $psgi_ar = $obj->call($env);

Implementation of view page.

Returns reference to array (PSGI structure).

=head2 C<to_app>

 my $app = $obj->to_app;

Creates L<Plack> application.

Returns L<Plack::Component> object.

=head1 EXAMPLE

=for comment filename=app_tree.pl

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
 # <!DOCTYPE html>
 # <html lang="en">
 #   <head>
 #     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 #     <meta name="generator" content="Plack::App::Tree::View" />
 #     <meta name="viewport" content="width=device-width, initial-scale=1.0" />
 #     <script type="text/javascript">
 #       window.addEventListener('load', (event) => {
 #     let toggler =
 #       document.getElementsByClassName("caret");
 #     for (let i = 0; i <
 #       toggler.length; i++) {
 #         toggler[i].addEventListener("click",
 #       function()
 #       {
 #                   this.parentElement.querySelector(".nested").classList.toggle("active");
 #                   this.classList.toggle("caret-down");
 #         });
 #     }
 # });
 #     </script>
 #     <title>
 #       Tree view
 #     </title>
 #     <style type="text/css">
 # * {
 # 	box-sizing: border-box;
 # 	margin: 0;
 # 	padding: 0;
 # }
 # ul, .tree {
 # 	list-style-type: none;
 # 	padding-left: 2em;
 # }
 # .caret {
 # 	cursor: pointer;
 # 	-webkit-user-select: none;
 # 	-moz-user-select: none;
 # 	-ms-user-select: none;
 # 	user-select: none;
 # }
 # .caret::before {
 # 	content: "⯈";
 # 	color: black;
 # 	display: inline-block;
 # 	margin-right: 6px;
 # }
 # .caret-down::before {
 # 	transform: rotate(90deg);
 # }
 # .nested {
 # 	display: none;
 # }
 # .active {
 # 	display: block;
 # }
 # </style>
 #   </head>
 #   <body>
 #     <ul class="tree">
 #       <li>
 #         <span class="caret">
 #           Root
 #         </span>
 #         <ul class="nested">
 #           <li>
 #             <span class="caret">
 #               H
 #             </span>
 #             <ul class="nested">
 #               <li>
 #                 <span class="caret">
 #                   I
 #                 </span>
 #                 <ul class="nested">
 #                   <li>
 #                     J
 #                   </li>
 #                 </ul>
 #               </li>
 #               <li>
 #                 K
 #               </li>
 #               <li>
 #                 L
 #               </li>
 #             </ul>
 #           </li>
 #           <li>
 #             M
 #           </li>
 #           <li>
 #             <span class="caret">
 #               N
 #             </span>
 #             <ul class="nested">
 #               <li>
 #                 <span class="caret">
 #                   O
 #                 </span>
 #                 <ul class="nested">
 #                   <li>
 #                     <span class="caret">
 #                       P
 #                     </span>
 #                     <ul class="nested">
 #                       <li>
 #                         Q
 #                       </li>
 #                     </ul>
 #                   </li>
 #                 </ul>
 #               </li>
 #             </ul>
 #           </li>
 #         </ul>
 #       </li>
 #     </ul>
 #   </body>
 # </html>

=begin html

<a href="https://raw.githubusercontent.com/michal-josef-spacek/Plack-App-Tree-View/master/images/app_tree.png">
  <img src="https://raw.githubusercontent.com/michal-josef-spacek/Plack-App-Tree-View/master/images/app_tree.png" alt="Example screenshot" width="300px" height="300px" />
</a>

=end html

=head1 DEPENDENCIES

L<Plack::Component::Tags::HTML>,
L<Plack::Util::Accessor>,
L<Tags::HTML::Tree>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Plack-App-Tree-View>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2024 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
