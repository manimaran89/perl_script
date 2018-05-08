 use strict;

 use Infoblox;
use Data::Dumper;
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

my @result_array = $session->get(
     object => "Infoblox::Grid::Member",
     name   => "ib-10-39-8-113.infoblox.com",
     #     view   => "default"
      );

my $for_obj = $result_array[0];
my @result_array1 = $session->get(
     object => "Infoblox::Grid::Member",
     name   => "ib-10-39-8-113.infoblox.com",
     #     view   => "default"
      );

my $for_obj1 = $result_array1[0];



my %data=(
'force_restart' => 'false',   
#'members' => [$for_obj], 
'services' => ['ALL']
);

#$session->restart(force_restart=>"true",members=>["10.34.158.91"]);
$session->restart(%data);

#print Dumper %data;
#print Infoblox::status_code() . ":" . Infoblox::status_detail();

print $session->status_code();
print $session->status_detail();


