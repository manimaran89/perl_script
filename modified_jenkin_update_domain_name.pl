#!/usr/bin/perl -w

use strict;
use Infoblox;
use Data::Dumper;

my $master_ip = $ARGV[0];

print"----------------------------------------\n";
print "Master IP:" . $master_ip;
print"\n----------------------------------------\n";


my $session = Infoblox::Session->new(
     master   => $master_ip,
     username => "admin",
     password => "infoblox"
 );

unless($session){
     die("Construct session failed: ",
     $session->status_code() . ":" . $session->status_detail());
 }

print"-----------------Session Status-----------------------\n";
print Infoblox::status_detail();

#print "\nSession created successfully\n";
print"\n----------------------------------------\n";

     my @retrieved_objs = $session->get(
       object       => "Infoblox::Grid::Member",
     );
foreach (@retrieved_objs) {
  #print $_->name();
  print"\n----------------------------------------\n";
  #if ($_->name =~ m/master/i) {
        my $ipaddr = $_->ipv4addr();
        $ipaddr =~ tr/./-/;
        print "\n**$ipaddr**\n";
        $_->name("ib-$ipaddr.infoblox.com");
        $session->modify($_);
  #}

}

@retrieved_objs = $session->get(
       object       => "Infoblox::Grid::Member",
     );
foreach (@retrieved_objs) {
  print $_->name();
  print"\n----------------------------------------\n";
  #print $_->name(0);
}
