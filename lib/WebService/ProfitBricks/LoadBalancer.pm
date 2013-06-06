#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::LoadBalancer;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attrs qw/loadBalancerId
        dataCenterId 
        loadBalancerName 
        loadBalancerAlgorithm
        ip
        lanId
        serverIds/;

serializer xml => { container => "arg0" };

belongs_to datacenter => "WebService::ProfitBricks::DataCenter" => { through => "dataCenterId" };

1;
