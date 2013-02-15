#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::DataCenter;

use strict;
use warnings;

use WebService::ProfitBricks::Class;

use WebService::ProfitBricks::Base;
use base qw(WebService::ProfitBricks);

attr qw/dataCenterName
        dataCenterVersion
        dataCenterId 
        region 
        provisioningState/;

does find => { through => "dataCenterName" };
does list => { through => "getAllDataCenters" };

serializer "xml";

has_many server => "WebService::ProfitBricks::Server" => { through => "servers" };

1;
