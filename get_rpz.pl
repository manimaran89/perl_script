 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.35.118.9",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 
my @result_array = $session->get(
     object => "Infoblox::DNS::Zone",
     name   => "fire.com",
     #rpz_type => "FIREEYE",
     #view   => "default"
 );
 my $for_obj = $result_array[0];
 unless($for_obj){
        die("Get zone test.com failed: ",
        $session->status_code() . ":" . $session->status_detail());
        }
 print "Get test.com zone object found at least 1 matching entry\n";
 
print Dumper $for_obj;
