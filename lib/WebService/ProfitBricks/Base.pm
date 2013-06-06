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

sub get_data {
   my ($self) = @_;
   return $self->{__data__};
}

sub set_data {
   my ($self, $data) = @_;
   for my $key (keys %{ $data }) {
      $self->{__data__}->{$key} = $data->{$key};
   }
}

sub get_relations { return(); }

1;
