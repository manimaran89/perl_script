use strict;
use Infoblox;
use Data::Dumper;
my $boolean="true";

my $session = Infoblox::Session->new(
                master   => "10.35.193.15", #appliance host ip
                username => "admin",       #appliance user login
                password => "infoblox"     #appliance password
 );
 unless ($session) {
        die("Construct session failed: ",
                Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
my @result_array = $session->get(
     object => " Infoblox::Grid::Reporting",
     #object => "Infoblox::Grid::Member::Reporting",
     #name => "member1.infoblox.com",
 );
 my $for_obj = $result_array[0];
 unless($for_obj){
        die("Get/Member reporting properties failed: ",
        $session->status_code() . ":" . $session->status_detail());
        }
 print "Get/Member reporting properties is sucess\n";

print Infoblox::status_code() . ":" . Infoblox::status_detail();
print Dumper @result_array;
