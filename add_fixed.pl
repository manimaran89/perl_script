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

 #Get Network View through the session
 my  @retrieved_objs = $session->get(
            object => "Infoblox::DHCP::View" ,
            name   => "default"
         );
 my $netview = $retrieved_objs[0];

my $fixed_addr = Infoblox::DHCP::FixedAddr->new(
     "ipv4addr"       => "21.0.0.12",
#     "mac"            => "00:00:00:11:22:33",
      match_client     => "RESERVED",
    #  "network_view"   => $netview
 );
 unless($fixed_addr) {
      die("Construct fixed address failed: ",
            Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Fixed address object created successfully\n";
 my $response = $session->add($fixed_addr)
