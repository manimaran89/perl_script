use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.35.0.226",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 my @retrieved_objs = $session->get(
     object => 'Infoblox::DTC::Pool',
     name   => 'pool1',
 );

my $object = $retrieved_objs[0];
unless($object){
        die("Get lbdn object failed: ",
                Infoblox::status_code(). ":" .Infoblox::status_detail());
    }
print Dumper $object;

