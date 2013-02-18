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

attrs qw/serverId
        cores
        ram
        ips
        lanId
        osType
        internetAccess
        dataCenterId
        dataCenterVersion
        bootFromImageId
        nics
        provisioningState/;


attr serverName => { searchable => 1, find_by => "name", through => "datacenter" };

serializer xml => { container => "arg0" };

has_many eth => "WebService::ProfitBricks::Nic" => { through => "nics" };
belongs_to datacenter => "WebService::ProfitBricks::DataCenter" => { through => "dataCenterId" };


1;
