use strict;
 use Infoblox;

use Data::Dumper;

my $session = Infoblox::Session->new(
                master   => "10.35.133.2", #appliance host ip
                username => "admin",       #appliance user login
                password => "infoblox"     #appliance password
 );
 unless ($session) {
        die("Construct session failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 my $ms_member = Infoblox::Grid::MSServer->new(
                                               address                  => '10.102.31.140',
                                               comment                  => 'basic member',
                                               disable                  => 'false',
#                                               extensible_attributes    => { Site => 'Somewhere'},
                                               login                    => 'frtest',
                                               password                 => 'Infoblox123',
                                               managing_member          => 'ib-10-35-133-2.infoblox.com',
                                               read_only                => 'false',
                                               synchronization_interval => 2,
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
 my $ms_dhcp = Infoblox::DHCP::MSServer->new(address => '10.102.31.140');
 unless($ms_dhcp) {
        die("Construct MS DHCP Member object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "MS DHCP Member object created successfully\n";

 my $network1 = Infoblox::DHCP::Network->new(
                                            network   => "10.0.0.0/255.255.0.0",
                                            comment   => "add network",
                                            members   => [$ms_dhcp],
                                           );
 unless($network1) {
        die("Construct DHCP Network object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Network object created successfully\n";
 unless($session->add($network1)) {
        die("Add DHCP Network object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "DHCP Network object added successfully\n";
 my $dhcp_range1 = Infoblox::DHCP::Range->new(
                                             end_addr                => "10.0.0.10",
                                             network                 => "10.0.0.0/16",
                                             start_addr              => "10.0.0.1",
                                             #disable                 => "true",
                                             member                  => $ms_dhcp,
                                            );
 unless($dhcp_range1) {
        die("Construct DHCP Range object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Range object created successfully\n";
 unless($session->add($dhcp_range1)) {
        die("Add DHCP Range object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "DHCP Range object added successfully\n";
 my $network2 = Infoblox::DHCP::Network->new(
                                            network   => "10.1.0.0/255.255.0.0",
                                            comment   => "add network",
                                            members   => [$ms_dhcp],
                                           );
 unless($network2) {
        die("Construct DHCP Network object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Network object created successfully\n";
 unless($session->add($network2)) {
        die("Add DHCP Network object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "DHCP Network object added successfully\n";
 my $dhcp_range2 = Infoblox::DHCP::Range->new(
                                             end_addr                => "10.1.0.30",
                                             network                 => "10.1.0.0/16",
                                             start_addr              => "10.1.0.21",
#                                             disable                 => "true",
                                             member                  => $ms_dhcp,
                                            );
 unless($dhcp_range2) {
        die("Construct DHCP Range object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Range object created successfully\n";
 unless($session->add($dhcp_range2)) {
        die("Add DHCP Range object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "DHCP Range object added successfully\n";

 my $superscope = Infoblox::DHCP::MSSuperscope->new(
                                                    name                  => 'test superscope',
                                                    comment               => 'test comment',
#                                                    disable               => 'true',
                                                    ranges                => [ $dhcp_range1, $dhcp_range2],
                                                    );
 unless($superscope) {
        die("Construct DHCP Superscope object failed: ",
             Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "DHCP Superscope object created successfully\n";
 unless($session->add($superscope)) {
        die("Add DHCP Superscope object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "DHCP Superscope object added successfully\n";

sleep 5;

my @retrieved_objs = $session->get(
     object => "Infoblox::DHCP::MSSuperscope",
     name   => "test superscope"
 );
 my $object = $retrieved_objs[0];
 unless ($object) {
        die("Get DHCP Superscope object failed: ",
             $session->status_code() . ":" . $session->status_detail());
 }
 print "Get DHCP Superscope object found at least 1 matching entry\n";


 print "zone #################################\n";
 print Dumper $object;
 print "zone #################################\n";
