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
      if(ref $data->{$key} eq "ARRAY") {
         for my $a (@{ $data->{$key} }) {
            push(@xml, "<${key}>");
            push(@xml, $a);
            push(@xml, "</${key}>");
         }
      }
      else {
         push(@xml, "<$key>" . $data->{$key} . "</$key>");
      }
   }

   if($self->container) {
      push(@xml, "</arg0>");
   }

   return join("", @xml);
}

1;
