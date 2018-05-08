#!/usr/bin/perl
use strict;
use Infoblox;
use Data::Dumper;
use Getopt::Std;
use File::Basename;
my $host1_ip = $ARGV[0];
my $user = $ARGV[1];
my $pass = $ARGV[2];
my $argc = @ARGV;

if ($argc lt 1)
{
  print "\"Usage: ./download_support_bundle.pl  <Grid IP>   [<User Name> default value is 'admin']  [<Password> defalut value is 'infoblox'] \n";
  exit(0);
}
if ($user eq '')
{
  $user="admin";
}
if ($pass eq '')
{
 $pass ="infoblox";
}

my $date = `date +%m-%d-%y_%H-%M-%S`;
chomp($date);
my $dump_directory = "support_bundle_$date";
system ("mkdir -p $dump_directory");
print "Support bundle is downloaded into $dump_directory directory\n";
my $session = Infoblox::Session->new (master => $host1_ip, username => $user, password => $pass, timeout => "610000");
unless ($session)
{
  die ("Constructor for session failed: ",
       Infoblox::status_code ().":".Infoblox::status_detail ());
}

print "Session created successfully.\n";

my @members = $session->search (object => "Infoblox::Grid::Member", name =>".*");
foreach my  $member_ele(@members)
{
 my $member_ip = $member_ele->ipv4addr();
 my $member_name = $member_ele->name();
 my $path = "$dump_directory/$member_name\.tar\.gz";
 my $rc = $session->export_data(type=> "support_bundle", path=> "$path", member => $member_ip);
 print "Downloaded $path...\n";
 print "sleep 5 sec...\n"; 
 sleep(5);
}

print "Downloading Database Backup\n";
$session->export_data(
     type   => "backup",
     path   => "$dump_directory/database.tar.gz" );



