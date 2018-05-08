 use strict;
 use Infoblox;
 use Data::Dumper;
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
# print "Session created successfully\n";
 my $object = $session->get(
     object => "Infoblox::DNS::Zone",
     name   => "10.in-addr.arpa"
 );

  unless ($object) {
       die("get Grid DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());
   }
  print "Grid DNS get  successfull\n";
 my $trap_notifications = $object->member_soa_mnames();
 my $notifications = $trap_notifications->name("xyz");

 # print Dumper $object;
 # $object->soa_refresh(2200);
 # $object->forwarders(["10.120.20.28"]);
 # $object->allow_recursive_query("true");
 # $object->recursive_query_list(["any"]);
 #  $object->allow_transfer(["any"]);

  #$object->use_lan_ipv6_port("false");
  #Apply the changes
 $session->modify($notifications)
   or die("modify member DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());

   print "DNS member object modified successfully \n";
 # print Dumper $object;
 # =cut
