#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Server;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attr qw/serverId
        serverName
        cores
        ram
        ips
        lanId
        osType
        internetAccess
        dataCenterId
        dataCenterVersion
        bootFromImageId
        provisioningState/;

serializer xml => { container => "arg0" };

belongs_to datacenter => "WebService::ProfitBricks::DataCenter" => { through => "dataCenterId" };

1;
