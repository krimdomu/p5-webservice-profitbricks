#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Base;

use strict;
use warnings;

my $connection;

use WebService::ProfitBricks::Class;

sub connection {
   my ($self, $con) = @_;
   if($con) {
      $connection = $con;
   }

   return $connection;
}

sub set_data {
   my ($self, $data) = @_;
   for my $key (keys %{ $data }) {
      $self->{$key} = $data->{$key};
   }
}

1;
