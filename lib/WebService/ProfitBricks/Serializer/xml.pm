#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Serializer::xml;

use strict;
use warnings;

use WebService::ProfitBricks::Class;

use WebService::ProfitBricks::Base;
use base qw(WebService::ProfitBricks);

attr qw/container/;

sub serialize {
   my ($self, $data) = @_;

   my @xml;
   
   if($self->container) {
      @xml = ("<arg0>");
   }

   for my $key (keys %{ $data }) {
      push(@xml, "<$key>" . $data->{$key} . "</$key>");
   }

   if($self->container) {
      push(@xml, "</arg0>");
   }

   return join("\n", @xml);
}

1;
