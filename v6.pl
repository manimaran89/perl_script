use strict;
use Infoblox;
use Data::Dumper;
use Socket qw(AF_INET6 inet_ntop inet_pton);
my $host=$ARGV[0];
#while(<>){
chomp($host);
print inet_ntop(AF_INET6, inet_pton(AF_INET6, $_)), "\n";
#} 
