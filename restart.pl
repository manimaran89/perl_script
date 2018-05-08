 use strict;
 use Infoblox;
 my $host1_ip =  "10.39.8.113";
 my $host1_fqdn =  "ib-10-39-8-113.infoblox.com";
 my $session = Infoblox::Session->new(
     master   => $host1_ip,
     username => "admin",
     password => "infoblox"
     );
 unless($session){
         die("Constructor for session failed: ",
                Infoblox::status_code(). ":" . Infoblox::status_detail());
 }
 print "Session created successfully.\n";

$session->restart();
print Infoblox::status_code() . ":" . Infoblox::status_detail();
