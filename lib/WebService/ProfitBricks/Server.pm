#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Server;

use strict;
use warnings;

use WebService::ProfitBricks::Class;

use WebService::ProfitBricks::Base;
use base qw(WebService::ProfitBricks);

attr qw/serverId
        serverName
        ips
        osType
        dataCenterId
        dataCenterVersion
        provisioningState/;

belongs_to datacenter => "WebService::ProfitBricks::DataCenter" => { through => "dataCenterId" };

1;
