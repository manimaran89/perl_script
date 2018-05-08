 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.39.52.37",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
# print "Session created successfully\n";
 my $response = $session->clear_dns_cache(
      member          => "10.2.0.76",
      domain          => "a528796.ravi.com",
      clear_full_tree => "false",
);

 unless($response) {
      die("Clear the domain from DNS cache failed ",Infoblox::status_code() . ":" . Infoblox::status_detail());
 }

 print "DNS member object modified successfully \n";
