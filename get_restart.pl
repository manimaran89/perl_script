 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.35.179.7",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
# print "Session created successfully\n";
 my $response = $session->clear_dns_cache(
      member          => "10.35.179.7",
      domain          => "arec.test.com",
      clear_full_tree => "false",
);

 unless($response) {
      die("Clear the domain foo.bar.com from DNS cache failed");
 }

 print "DNS member object modified successfully \n";
