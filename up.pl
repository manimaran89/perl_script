 use strict;
 use Infoblox;
 use Data::Dumper;
my $server_ip= $ARGV[0];
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => $server_ip,
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
# print "Session created successfully\n";
sub is_nios_up
{
    my($server_ip) = shift;
    if( !defined($server_ip) || ($server_ip eq ""))
    {
        print "ERROR: Detect invalid parameters. Server IP Required \n\n";
        return 1; # return fail
    }
        my $time_out = 600;     # Total elapsed time 300 secondes
        my $delay = 30;         # 60 seconds sleep time
        my $start_time = time();  # Wait up to 300 seconds for the machine to answer pings.
        my $elapsed_time = 0;
        my $RESPONSE = 0;

        while ($elapsed_time < $time_out) {
                $RESPONSE =`curl -s -k1 -u admin:infoblox -w '\nThe Response Code:%{http_code}\n' https://$server_ip/wapi/v1.2/grid | grep -oP 'The Response Code:\\K.*'`;
                print "Response : $RESPONSE";
                if ($RESPONSE == 200) {
                        $elapsed_time = time() - $start_time;
                        print localtime() . ": Machine is reachable on $server_ip after $elapsed_time seconds.\n";
                        return 0;
                }
$elapsed_time = time() - $start_time;
                print localtime() . ": still waiting for $server_ip to come online.  It's been $elapsed_time seconds so far ...\n";    
                sleep $delay;
         }
         print STDERR localtime() . ": waited too long for the $server_ip NIOS to come online.  Giving up.\n";
         return 1;
}

1;
 
#Apply the changes

#      my $MessageText = "$Code, $Status";
#      sleep 120;
      print localtime() . " : $server_ip : Is NIOS Up process started!!!\n";
      my $server_status = &is_nios_up($server_ip);
      if($server_status == 0){
          print localtime() . " : $server_ip : Up and Running!!!\n";
      }else{
          print localtime() . " : $server_ip : Not UP!!!\n";
      }


 #   if($result != 0)
 #   {
 #    $result=1;
 #   }  

   print "DNS member object modified successfully \n";
 # print Dumper $object;
 # =cut
