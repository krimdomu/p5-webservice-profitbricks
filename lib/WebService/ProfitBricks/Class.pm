#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package WebService::ProfitBricks::Class;

use strict;
use warnings;

use Data::Dumper;
require Exporter;
use base qw(Exporter);
use vars qw(@EXPORT);

@EXPORT = qw(new attr does has_many belongs_to serializer);

my %FUNC_MAP;

$FUNC_MAP{list} = sub {
   my ($self, $caller_pkg, $option) = @_;

   if(! exists $option->{through}) {
      die("list: you have to define ,,through''.");
   }

   map { $_ = $caller_pkg->new(%{ $_ }) } $self->connection->call($option->{through});
};

$FUNC_MAP{find} = sub {
   my ($self, $caller_pkg, $option, $search) = @_;
   my $lookup_key = $option->{through};

   [ grep { $_->$lookup_key eq $search } $self->list ]->[0];
};

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;

   my $self = ref($that) ? $that : {};


   eval {
      if($proto->SUPER) {
         $self = $proto->SUPER::new(@_);
      }
   };

   bless($self, $proto);

   $self->set_data({ @_ });

   eval {
      $self->construct(@_);
   };

   return $self;
}

sub has_many {
   my ($what, $pkg_class, $options) = @_;

   my $what_pl = pluralize($what);

   my ($caller_pkg) = caller;
   my $through = $options->{through} || $what;

   eval "use $pkg_class";
   if($@) {
      die("has_many: no available class: $pkg_class found.\n$@");
   }

   no strict 'refs';

   # function to get related objects
   *{ $caller_pkg . "::" . $what_pl } = sub {
      my ($self) = @_;

      my $current_data = $self->get_data;

      my @data;
      #print Dumper($self);
      if(ref($through) eq "CODE") {
         @data = &{ $through }($self);
      }
      else {
         @data = @{ $current_data->{$through} || [] };
      }

      return map { $_ = $pkg_class->new(%{ $_ }) } @data;
   };

   # function to add related objects
   *{ $caller_pkg . "::" . $what } = sub {
      my ($self) = @_;

      my ($pkg_name) = [ split(/::/, ref($self)) ]->[-1];
      my $get_data_func_key   = lcfirst($pkg_name) . "Id";

      my $obj = $pkg_class->new($get_data_func_key => $self->$get_data_func_key);
      return $obj;
   };

   use strict;
}

sub belongs_to {
   my ($what, $pkg_class, $options) = @_;

   my ($caller_pkg) = caller;
   my $through = $options->{through} || $what;

   eval "use $pkg_class";
   if($@) {
      die("belongs_to: no available class: $pkg_class found.\n$@");
   }

   no strict 'refs';

   *{ $caller_pkg . "::" . $what } = sub {
      my ($self) = @_;
      return $pkg_class->new()->find_by_id($self->{__data__}->{$through});
   };

   use strict;
  
}

sub does {
   my ($what, $option) = @_;

   my ($caller_pkg) = caller;

   no strict 'refs';

   my $code = $FUNC_MAP{$what};

   if(! $code) {
      die("does: $what not valid.");
   }

   *{ $caller_pkg . "::" . $what } = sub {
      my ($self, @data) = @_;

      return &$code($self, $caller_pkg, $option, @data);
   };

   use strict;
}

sub attr {
   my (@has) = @_;
   my ($caller_pkg) = caller;

   no strict 'refs';

   for my $attr (@has) {
      *{ $caller_pkg . "::" . $attr } = sub {
         my ($self, $set) = @_;
         if(defined $set) {
            $self->{__data__}->{$attr} = $set;
         }

         return $self->{__data__}->{$attr};
      };
   }

   use strict;
}

sub serializer {
   my ($type, $options) = @_;

   my ($caller_pkg) = caller;

   my $pkg_class = "WebService::ProfitBricks::Serializer::$type";
   eval "use $pkg_class";
   if($@) {
      die("serializer: unknown class $pkg_class.\n$@");
   }

   no strict 'refs';
   *{ $caller_pkg . "::to_" . $type } = sub {
      my ($self) = @_;
      my $serializer = $pkg_class->new(%{ $options });
      return $serializer->serialize($self->get_data);
   };
   use strict;
}

# simple pluralize
sub pluralize {
   my ($name) = @_;

   if($name =~ m/s$/) {
      $name .= "es";
   }
   else {
      $name .= "s";
   }
}

1;
