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