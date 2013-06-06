#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Nic;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attrs qw/nicId
        nicName
        serverId
        lanId
        internetAccess
        ip
        macAddress
       /;

serializer xml => { container => "arg0" };

belongs_to server => "WebService::ProfitBricks::Server" => { through => "serverId" };


#sub setInternetAccess {
#   my ($self, $has_access) = @_;
#
#   my $ret = $self->connection->call("setInternetAccess", nicId => $self->nicId, datacenterId => $self->server->dataCenterId, lanId => $self->lanId, internetAccess => $has_access);
#   print Dumper($ret);
#}

1;
