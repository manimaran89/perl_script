#!/usr/bin/perl
use Infoblox;
use LWP::Simple;
use Data::Dumper;
use Getopt::Std;
use File::Basename;
use Net::DNS;
use Net::Ping;
my  $upgrade;
my $host1_ip = $ARGV[0]; #Upgrade Path
my $path = $ARGV[1];     #path
my $session = Infoblox::Session->new (master => $host1_ip, username => "admin" ,  password => "infoblox");
unless ($session)
{
  die ("Constructor for session failed: ",
       Infoblox::status_code ().":".Infoblox::status_detail ());
}
print "Session created successfully.\n";
#Unsupported HW
print "Enabling upgrade support for -A appliances\n";
&support_A($host1_ip);

#Taking onedb, named.conf, dhcp.conf and database bacup before upgrade. 
#&capture_conf_ondb();

#Uploding Binary File
my $response1 = $session->import_data(type => 'upgrade', path => $path);
my $response = $session->grid_upgrade( action => 'UPLOAD');
unless ($response)
{
  die ("Upload failed: ",
       Infoblox::status_code ().":".Infoblox::status_detail ());
}
do 
{
  sleep(10);
  print "Uploading ...\n";
  $upgrade = $session->get(object => "Infoblox::Grid::UpgradeStatus");
}until  ( $upgrade->grid_state eq 'UPLOADED');

#Distributing Binary File after complition of Upload
my $response = $session->grid_upgrade( action => 'DISTRIBUTION_START');
unless ($response)
{
  die ("Distribution failed: ",
       Infoblox::status_code ().":".Infoblox::status_detail ());
}
   sleep(60);

#Skip OFFLINE Members Distribution.
&skip_offline();
do
{
  sleep(10);
  print "Distributing...\n";
  $upgrade = $session->get(object => "Infoblox::Grid::UpgradeStatus");
  print $upgrade ->distribution_state;
}until( $upgrade->distribution_state eq 'COMPLETED');
 

#Upgrade test

my $response = $session->grid_upgrade( action => 'UPGRADE_TEST_START');
unless ($response)
{
  die ("Upgrade TEST start failed: ",
       Infoblox::status_code ().":".Infoblox::status_detail ());
}


do
{
  sleep(5);
  print "Upgrade Test..\n";
  $upgrade = $session->get(object => "Infoblox::Grid::UpgradeStatus");
}until  ( $upgrade->upgrade_test_status eq 'COMPLETED');

  $upgrade = $session->get(object => "Infoblox::Grid::UpgradeStatus");
  if ($upgrade->message eq "UpgradeStatus.Value.UPGRADE_TEST_STATUS_COMPLETED_SUCCESSFULLY")
  {
    print "\nTriggered for Upgrade..";
    my $response = $session->grid_upgrade( action => 'UPGRADE');
       unless ($response)
       {
        die ("Upgrade failed: ",
            Infoblox::status_code ().":".Infoblox::status_detail ());
       }
  }
  else
  {
     print "\n Upgrade Test Failed: $upgrade->message ";
     exit(0);
  }

#Upgrade
#Wait until upgrade gets completed
my $ping;
my $rc=0;
do{
 do{
    sleep(120);
    print "Upgrading.....\n";
    $ping = Net::Ping->new("tcp", 5);
    $ping->port_number(scalar(getservbyname("domain", "tcp")));
 }until($ping->ping($host1_ip));
   sleep(180); #some times ip will be pingable but web server may not be running
  $rc=check_upgrde_status($host1_ip);
 }until($rc);


#Taking onedb, named.conf, dhcp.conf and database bacup after upgrade. 
#&capture_conf_ondb();
 
#Create new session

sub capture_conf_ondb
{
 my @members = $session->search (object => "Infoblox::Grid::Member", name =>".*");
 foreach my  $member_ele(@members)
 {
  my $member_name = $member_ele->name();
  my $ip = $member_ele->ipv4addr();
  my $ha_status = $member_ele->enable_ha();
  my $node1_ip = $member_ele->node1_lan();
  my $node2_ip = $member_ele->node2_lan();
 if ($ha_status eq 'true')
 {
 #Node1
   &download($node1_ip,$member_name,"ha");
 #Node2
   &download($node2_ip,$member_name,"ha" );
 }
 else
 {
   &download($ip,$member_name,"non_ha" );

 } 
 }  
}

sub download
{
 my $ip=shift;
 my $name=shift; 
 my $ha=shift; 
system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip mkdir -p /tmp/junk");
system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip /infoblox/one/bin/db_dump -svilVPd /tmp/junk");
system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip tar -cvzf /tmp/junk/onedb.tar.gz /tmp/junk/onedb.xml");
my $directory ="$name\_$ip\_$ha";
system("mkdir -p $directory");
system("scp -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip:/tmp/junk/onedb.tar.gz $directory");
system("scp -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip:/infoblox/var/dhcpd_conf/dhcpd.conf $directory");
system("scp -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$ip:/infoblox/var/named_conf/named.conf $directory");
}

sub support_A
{
 my $gm=shift;
 system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$gm touch /infoblox/var/nios_no_restrict_INFOBLOX");
 system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root\@$gm touch /infoblox/var/nios_no_restrict_VNIOS");
}

sub skip_offline
{
 my @members = $session->search (object => "Infoblox::Grid::Member", name =>".*");
 foreach my  $member_ele(@members)
 {
   my $member_name = $member_ele->name();
   my $replication_info = $member_ele->replication_info();
   my %status =  %$replication_info;
   if ($status{"member_rep_status"} eq "OFFLINE" )
   {
     print "\nSkipping distribution:$member_name";
     $session->skip_member_upgrade( member => $member_name);
     print  Infoblox::status_code ().":".Infoblox::status_detail ();
   }
 }
}

  

sub check_upgrde_status
{
  my $server = shift; 
  &download_perl_module($server);
#  system("/import/tools/qa/bin/getPAPI $server .");
   $session = Infoblox::Session->new (master => $host1_ip, username => "admin" ,  password => "infoblox");
   my $upgrade = $session->get(object => "Infoblox::Grid::UpgradeStatus");
     if ($upgrade->grid_state eq "UPGRADING_COMPLETE" )
     {
        print "Upgrade Status:Completed\n";
        return(1);
     }
     elsif ($upgrade->grid_state eq "UPGRADING" )
     {
        print "Upgrade Status:In Progress\n";
        return(0);
     }
     elsif ($upgrade->grid_state eq "UPGRADING_FAILED")
     {
        print "Upgrade Status:Failed  Please check logs for more information.\n";
        return(1);
     }
    
}


sub download_perl_module
{
my $server = shift;
my $URL="https://$server/api/dist/ppm/";
my $rc=`wget -nd -q -r -A "*.tar.gz" --no-check-certificate $URL`;
system("tar -xzf Infoblox-*.tar.gz");
system("cp -r blib/lib/Infoblox* . ");
system("cp Infoblox.pm Infoblox/ ");
system("rm blib Infoblox*tar.gz -rf");
}

