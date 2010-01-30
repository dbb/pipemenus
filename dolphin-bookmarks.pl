#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use XML::Simple;

my $file_manager = "dolphin";
my $file = "$ENV{HOME}/.local/share/user-places.xbel";
my $places = XMLin("$file", forcearray => [ qw(href title) ]);

my %menu_items;
foreach my $key (@{$places->{bookmark}}) {
  $menu_items{$key->{'title'}[0]} = $key->{'href'};
}

print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<openbox_pipe_menu>\n";

foreach my $key (sort keys %menu_items) {
  print "<item label=\"".$key."\">\n";
  print " <action name=\"Execute\">\n";
  print "  <execute>\n";
  print "   ".$file_manager." ".$menu_items{$key}."\n";
  print "  </execute>\n";
  print " </action>\n";
  print "</item>\n";
}

print "</openbox_pipe_menu>\n";