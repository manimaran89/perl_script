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
     object => "Infoblox::Grid::Member",
    # name   => "ib-10-35-0-48.infoblox.com"
 );

  unless ($object) {
       die("get Grid DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());
   }
  #print "Grid DNS get  successfull\n";
  #print Dumper $object;

  foreach ($object) {
  print $_->name();
  }
=cc
  $object->use_lan_ipv6_port("false");
  #Apply the changes
  $session->modify($object)
   or die("modify member DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());

   print "DNS member object modified successfully \n";
  print Dumper $object;
  =cut
