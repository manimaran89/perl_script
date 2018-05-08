use strict;
 use Infoblox;

use Data::Dumper;

my $session = Infoblox::Session->new(
                master   => "10.35.116.15", #appliance host ip
                username => "admin",       #appliance user login
                password => "infoblox"     #appliance password
 );
 unless ($session) {
        die("Construct session failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";

 my $ms_member = Infoblox::Grid::MSServer->new(
                                              address                  => '10.102.31.129',
                                              comment                  => 'This is an MS DNS Server',
                                              disable                  => 'true',
                                              extensible_attributes    => { Site => 'Main Office'},
                                              login                    => 'user',
                                              password                 => 'password',
                                              managing_member          => 'ib-10-35-116-15.infoblox.com',
                                              read_only                => 'false',
                                              synchronization_interval => 5,
                                              disable                  => 'false',
                                              logging_mode             => 'minimum',
                                              );
 unless($ms_member) {
        die("Construct MS Member object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "MS Member object created successfully\n";
 unless($session->add($ms_member)) {
        die("Add MS Member object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "MS Member object added successfully\n";
sleep(20);

my $grid_msserver_dns = $session->get(
     object    => "Infoblox::Grid::MSServer::DNS",
     server_ip => "10.102.31.129");

 $grid_msserver_dns->manage_dns('true');
 # Submit modification
 my $response = $session->modify( $grid_msserver_dns );

my $grid_msserver_dhcp = $session->get(
     object    => "Infoblox::Grid::MSServer::DHCP",
     address => "10.102.31.129");
#print Dumper $grid_msserver_dhcp;

$grid_msserver_dhcp->manage_dhcp('true');
 # Submit modification
my $response = $session->modify( $grid_msserver_dhcp );

