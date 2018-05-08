#!/usr/bin/perl

 use strict;
 use Infoblox;
 use Data::Dumper;

 my $host_ip = "10.34.15.140";

 my $session = Infoblox::Session->new(
     master   => $host_ip,
     username => "admin",
     password => "infoblox"
 );

 unless ($session) {
     die(qq(constructor for session failed: ),
         join(":", Infoblox::status_code(), Infoblox::status_detail()));
 }
 print "Session created successfully \n";

 my $ospf_conf1 = Infoblox::Grid::Member::OSPF->new(
      'area_id' => '0.0.0.12',
      'is_ipv4' => 'true',
      'interface' => 'LAN_HA',
      'enable_bfd' => 'true',
      'bfd_template' => 'mani',
      'authentication_type' => 'none',
 );
 my $ospf_conf = Infoblox::Grid::Member::OSPF->new(
      'area_id' => '0.0.0.21',
      'is_ipv4' => 'false',
      'interface' => 'LAN_HA',
      'enable_bfd' => 'false',
      'bfd_template' => 'mani',
      'authentication_type' => 'none',
 );
my @arr;
push (@arr, $ospf_conf);
push (@arr, $ospf_conf1);

print Infoblox::status_code();
print Infoblox::status_detail();

 my $get_member = $session->get(
     object => "Infoblox::Grid::Member",
     name   => "ib-10-34-15-149.infoblox.com"
     );

 $get_member->ospf_list([@arr]);
# $get_member->ospf_list([$ospf_conf1]);

 $session->modify($get_member)
    or die("Modify grid member failed",
             $session->status_code() . ":" . $session->status_detail());

 print"Grid member modified successfully \n";

