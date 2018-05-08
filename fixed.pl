#PROGRAM STARTS: Include all the modules that will be used
 use strict;
 use Infoblox;

 #Create a session to the Infoblox appliance

 my $session = Infoblox::Session->new(
                master   => shift, #appliance host ip
                username => "admin",       #appliance user login
                password => "infoblox"     #appliance password=============================check this=========================================================
 );

 unless ($session) {
        die("Construct session failed: ",
                Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";


my $fixed_addr = Infoblox::DHCP::FixedAddr->new(
     "ipv4addr"       => "21.0.0.12",
      match_client     => "RESERVED",
);
 unless($fixed_addr) {
      die("Construct fixed address failed: ",
            Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Fixed address object created successfully\n";
 my $response = $session->add($fixed_addr)
