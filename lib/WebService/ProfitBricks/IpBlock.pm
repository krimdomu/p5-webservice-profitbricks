#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::IpBlock;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attrs qw/blockId 
        region
        publicIps
        blockSize
        region/;

does list => { through => "getAllPublicIpBlocks" };

does find => { code => sub {
   my ($self, $search) = @_;
   my @blocks = $self->list;
   
   for my $block (@blocks) {
      for my $public_ip (@{ $block->publicIps }) {
         if($public_ip->{ip} eq $search) {
            return $block;
         }
      }
   }
}};

sub save {
   my ($self) = @_;
   my $data = $self->connection->call("reservePublicIpBlock", blockSize => $self->blockSize, region => $self->region);
}

sub reserve {
   my ($self) = @_;
   $self->save;
}

sub release {
   my ($self) = @_;
   my $data = $self->connection->call("releasePublicIpBlock", blockId => $self->blockId);
}

1;
