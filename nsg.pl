 use strict;
 use Infoblox;
 use Getopt::Std;

 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => shift,
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 my $master = Infoblox::DNS::Member->new(
     name     => shift,
     ipv4addr => shift,
     stealth  => "false"
 );
my $member1 = Infoblox::DNS::Member->new(
     name     => shift,
     ipv4addr => shift,
     stealth  => "false"
 );

 my $nsg1 = Infoblox::Grid::DNS::Nsgroup->new(
     name    => "ns_group_2",
     multiple_primaries => [$master,$member1]
 );
 unless ($nsg1) {
    die("Construct Nsgroup failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 my $response = $session->add( $nsg1 );
 print "Nsgroup object created successfully\n";


=cc
    my $nameserver = Infoblox::DNS::Nameserver->new(
     name      => "member.com",
     ipv4addr  => "10.35.115.16",
     stealth   => "false",
#     TSIGname  => "tsig_name",
#     TSIGkey   => "ZX1jVJl7C58GT/sc7Q3uca==",
 );
 unless ($nameserver){
      die("Construct Nameserver failed: ",
            Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
=cut

