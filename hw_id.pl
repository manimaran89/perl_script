#!/usr/bin/perl
my $hw_id = $ARGV[0];
print "--$hw_id--";
my $scp_output = system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root@10.35.105.5 ./generatelic -p sw_tp -i 564d9de74b5cdd311e049417397f6488 > a.out");
my $scp_output = system("ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o UserKnownHostsFile=/dev/null 2>/dev/null root@10.35.105.5 ps");
print $?;
