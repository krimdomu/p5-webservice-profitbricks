#
# (c) Jan Gehring <jan.gehring@inovex.de>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks;

use strict;
use warnings;

use Data::Dumper;
use WebService::ProfitBricks::Class;

use WebService::ProfitBricks::Base;
use WebService::ProfitBricks::Connection;

use base qw(WebService::ProfitBricks::Base);

our $VERSION = "0.0.1";

my $user;
my $password;

sub construct {
   my ($self, @data) = @_;

   $self->connection(WebService::ProfitBricks::Connection->new(user => $user, password => $password));

   if(! @data) {
      return;
   }

   my ($pkg_name) = [ split(/::/, ref($self)) ]->[-1];
   my $get_data_func_name = "get$pkg_name";
   my $get_data_func_key   = lcfirst($pkg_name) . "Id";

   # later, this should be rewritten so it will only call the soap iface 
   # if the data someone wanted to use is not present yet
   $self->find_by_id($self->$get_data_func_key);

   return $self;
}

sub find_by_id {
   my ($self, $id) = @_;
   
   my ($pkg_name) = [ split(/::/, ref($self)) ]->[-1];
   my $get_data_func_name = "get$pkg_name";
   my $get_data_func_key   = lcfirst($pkg_name) . "Id";

   my $data = $self->connection->call($get_data_func_name, $get_data_func_key => $id);
   $self->set_data($data);

   return $self;
}

sub create {
   my ($self, %data) = @_;

   $self->set_data(\%data);

   my ($pkg_name) = [ split(/::/, ref($self)) ]->[-1];
   my $create_func_name = "create" . $pkg_name;

   my $ret_data = $self->connection->call($create_func_name, %data);

   $self->set_data($ret_data);

   return $self;
}

sub delete {
   my ($self) = @_;

   my ($pkg_name) = [ split(/::/, ref($self)) ]->[-1];
   my $delete_func_name = "delete" . $pkg_name;
   my $delete_param_name = lcfirst($pkg_name) . "Id";

   my $ret_data = $self->connection->call($delete_func_name, $delete_param_name => $self->$delete_param_name);

   return 1;
}

sub auth {
   my ($class, $_user, $pass) = @_;

   $user = $_user;
   $password = $pass;
}

sub import {
   my ($class, @names) = @_;

   my ($caller_pkg) = caller;

   no strict 'refs';

   for my $name (@names) {
      
      *{ $caller_pkg . "::" . $name } = sub {
         my $pkg = __PACKAGE__ . "::$name";
         eval "use $pkg";
         if($@) {
            die($@);
         }

         shift;
         return $pkg->new(@_);
      };

   }

}

1;
