#!/usr/bin/perl

use strict;
use Infoblox;

my $session = Infoblox::Session->new(
     master   => "10.35.135.15",
     username => "admin",
     password => "infoblox"
     );
 unless( $session ){
     die("Constructor for session failed:",
     Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print" Session object created successfully \n";


 my @result = $session->get(
     object => "Infoblox::Grid::DNS",
     name   => "Infoblox"
     );
 unless( @result ){
     die("Get grid DNS failed: ",
     $session->status_code() . ":" . $session->status_detail());
 }
 print" Get grid DNS object found at least 1 matching entry \n";
 my $grid_dns = $result[0];

  my $tsig_key = Infoblox::DNS::TSIGKey->new(
     key  => "Zx1jVJl7C58GT/sc7Q3ucA==",
     name => "rc-key1"
 );

my @arr;

for (my $j=0;$j<=8;$j++)
{
for (my $i=0;$i<=252;$i++)
{
	push (@arr, "1.1.$j.$i");
}
}
 $grid_dns->allow_query([@arr]);
 $grid_dns->allow_recursive_query("true");
# $grid_dns->allow_transfer([@arr]);
# $grid_dns->allow_update([@arr]);
 $grid_dns->filter_aaaa("YES");
 $grid_dns->filter_aaaa_list([@arr]);
 $grid_dns->recursive_query_list([@arr]);
 $grid_dns->enable_blackhole("true");
 $grid_dns->blackhole_list([@arr]);
 my $response = $session->modify($grid_dns);
  unless( $response ){
     die("Modify grid DNS failed: ",
     $session->status_code() . ":" . $session->status_detail());
  }
  print" Modify grid DNS successful \n";
