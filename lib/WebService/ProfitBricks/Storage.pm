#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Storage;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attrs qw/storageId
        storageName
        creationTime
        lastModificationTime
        provisioningState
        size
        serverId
        mountImage
        osType/;


serializer xml => { container => "arg0" };

belongs_to datacenter => "WebService::ProfitBricks::DataCenter" => { through => "dataCenterId" };

sub connect {
   my ($self, $server_id) = @_;
   my $data = $self->connection->call("connectStorageToServer", storageId => $self->storageId, serverId => $server_id);
   $self->provisioningState($data);
}

1;
