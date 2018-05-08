#!/usr/bin/perl -w
# start_dns_dhcp_services - Starts DNS & DHCP services
#
# Author : Prabhu Rajadurai & Madhu Kumar
#
use strict;
use warnings;
use Infoblox;
my $host_ip   = $ARGV[0] || die "Usage : $0 <Grid_VIP>\n";
my $flag = 0;

# Creates Session
my $session = Infoblox::Session->new(
    master   => $host_ip,
    username => "admin",
    password => "infoblox"
    );
unless ($session) {
    die(qq(constructor for session failed: ),
        join(":", Infoblox::status_code(), Infoblox::status_detail()));
}

# Gets all the DNS Members
my @retrieved_objs = $session->get(
    object       => "Infoblox::Grid::Member::FileDistribution",
    );
# Starts DNS Service on Members
foreach (@retrieved_objs) {
    if($_->enable_http() eq "false") {
        $_->enable_http("true");
        $flag = 1;
    }
    $session->modify($_) or die("modify member DNS failed: ", $session->status_code() . ":" . $session->status_detail());
    print "DNS Service Started successfully on " . $_->name() . "\n";
}
