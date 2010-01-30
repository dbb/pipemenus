#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use POSIX qw(strftime);
use XML::Simple;
use Data::Dumper;

# Distro -------------------------------------------------------------------
open (my $issue, "<", "/etc/issue");
my $distro;
while (<$issue>) {
  if (/^[^\s]/) {
    $distro = (split / /, ((split /\\/)[0]))[0];
    last;
   }
}
close $issue;

# Host ---------------------------------------------------------------------
my $host = `uname -n`;
chomp $host;

# Kernel -------------------------------------------------------------------
my $kernel = `uname -r`;
chomp $kernel;

# Load ---------------------------------------------------------------------
my $load = (split ' ', (split ':', `uptime`)[4])[0];
chop $load;

# Machine ------------------------------------------------------------------
my $machine = `uname -m`;
chomp $machine;

# Memory (active) ----------------------------------------------------------
open (my $meminfo, "<", "/proc/meminfo");
my $mem_act;
while (<$meminfo>) {
  chomp;
  if (/^Active:/) {
    $mem_act = int(((split)[-2])/1024);
    last;
  }
}
close $meminfo;

# Openbox theme ----------------------------------------------------------------------------
my $file = "$ENV{HOME}/.config/openbox/rc.xml";
my $xs1 = XML::Simple->new();
my $doc = $xs1->XMLin($file);
my $obtheme = $doc->{theme}->{'name'};

# OS -----------------------------------------------------------------------
my $os = `uname -o`;
chomp $os;

# Time ---------------------------------------------------------------------
my $time_date = strftime "%D, %R", localtime;

# Uptime -------------------------------------------------------------------
my $uptime = (split ' ', `uptime`)[0];


# Writing the pipemenu -----------------------------------------------------

print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print "<openbox_pipe_menu>\n";
print "<item label=\"+        $ENV{USER}\@$host        +\" />\n";
print "<separator />";
print "<item label=\"OS:      $distro $os $machine \" />\n";
print "<item label=\"Kernel:  $kernel \" />\n";
print "<item label=\"Uptime:  $uptime \" />\n";
print "<item label=\"Load:    $load \" />\n";
print "<item label=\"Mem:     $mem_act MB\" />\n";
print "<item label=\"Theme:   $obtheme \" />\n";
print "<separator />";
print "<item label=\"+        $time_date       +\" />\n";
print "</openbox_pipe_menu>\n";