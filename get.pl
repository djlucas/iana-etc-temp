#!/usr/bin/perl

use strict;
use Net::FTP;

my $host = "ftp.iana.org";
my $user = "anonymous";
my $password = "anonymous";
my $data = $ARGV[0];
my $dir = "assignments/$data";
my $filename = "$data.xml";

my $f = Net::FTP->new($host) or die "Can't open $host\n";
$f->login($user, $password) or die "Can't log $user in\n";

$f->cwd($dir) or die "Can't cwd to $dir\n";
$f->get($filename) or die "Can't get $filename from $dir\n";

