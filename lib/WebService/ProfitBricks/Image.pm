#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Image;

use strict;
use warnings;

use WebService::ProfitBricks::Class;
use base qw(WebService::ProfitBricks);

attr qw/imageId 
        name 
        imageType
        writeable
        cpuHotpluggable
        memoryHotpluggable
        region
        osType/;

does find => { through => "name" };
does list => { through => "getAllImages" };

has_many server => "WebService::ProfitBricks::Server" => {
   through => sub {
      my ($self) = @_;
      map { $_ = { serverId => $_ } } $self->serverIds;
   },
};

1;
