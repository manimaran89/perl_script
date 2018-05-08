use strict;
use warnings;
use Infoblox;
use Data::Dumper;
#refers to Infoblox Appliance IP address
my $host_ip = "10.35.106.6";
#Create a session to the Infoblox appliance
my $session = Infoblox::Session->new(
     master   => $host_ip,
     username => "admin",
     password => "infoblox"
);
unless ($session) {
       die("Construct session failed: ",
               Infoblox::status_code() . ":" . Infoblox::status_detail());
}
print "Session created successfully\n";
my @retrieved_objs = $session->get(
     object => "Infoblox::Grid::MSServer::DHCP",
     address => "10.102.30.157"
    );
 my $msserver = $retrieved_objs[0];

 unless ($msserver) {
     die("Get grid MS DNS server object failed: ",
            $session->status_code() . ":" . $session->status_detail());
 }
print Dumper $msserver;
=cc
my $login = $msserver->login_name();
#print $login;
$msserver->login_name("newtest");
my $res = $session->modify($msserver);
=cut
