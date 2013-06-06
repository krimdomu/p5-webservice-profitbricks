#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::DataCenter;

use strict;
use warnings;

use Data::Dumper;
use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attrs qw/dataCenterName
        dataCenterVersion
        dataCenterId 
        region 
        provisioningState/;

does find => { through => "dataCenterName" };
does list => { through => "getAllDataCenters" };

serializer "xml";

has_many server       => "WebService::ProfitBricks::Server"       => { through => "servers" };
has_many loadbalancer => "WebService::ProfitBricks::LoadBalancer" => { through => "loadBalancers" };
has_many storage      => "WebService::ProfitBricks::Storage"      => { through => "storages" };

sub wait_for_provisioning {
   my ($self) = @_;
   my $is_ready = 0;

   while($is_ready == 0) {
      $self->get_state;
      if(exists $self->{__data__}->{provisioningState} && $self->{__data__}->{provisioningState} eq "AVAILABLE") {
         $is_ready = 1;
         last;
      }

      sleep 3;
   }
}

sub get_state {
   my ($self) = @_;
   my $data = $self->connection->call("getDataCenterState", dataCenterId => $self->dataCenterId);
   $self->provisioningState($data);
}


1;
