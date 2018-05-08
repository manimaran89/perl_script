#!/usr/bin/perl

use Carp;
use utf8;
use Infoblox;
use Getopt::Std;

my $session = Infoblox::Session->new(
	"master" => "10.34.9.75",       # IP address of Grid Master
	"username" => "admin",               # Username / Password of Grid Master
	"password" => "infoblox"
);

my @macObjs =  $session->search(
	object => "Infoblox::DHCP::MAC",
	mac => "11:22:33:44:55:66",
	filter => "mac");

print "length:" . @macObjs . "\n";
foreach my $macObj (@macObjs) {
	print "- " . $macObj->filter() . " / " . $macObj->mac() . "\n";
}
