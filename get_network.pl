 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.35.118.13",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 my @retrieved_objs = $session->get(
     object     => "Infoblox::DHCP::Range",
     start_addr => "10.0.0.1",
 );
 my $object = $retrieved_objs[0];
 unless ($object) {
        die("Get DHCP Range failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "Get DHCP Range object found at least 1 matching entry\n";
 print Dumper $object;
