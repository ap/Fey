package Fey::SQL::Where;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.44';

use Fey::Types;

use Moose 2.1200;
use MooseX::SemiAffordanceAccessor 0.03;
use MooseX::StrictConstructor 0.13;

with 'Fey::Role::SQL::HasWhereClause';

with 'Fey::Role::SQL::HasBindParams' => { -excludes => 'bind_params' };

with 'Fey::Role::SQL::Cloneable';

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Represents a "stand-alone" WHERE clause

__END__

=head1 SYNOPSIS

  my $sql = Fey::SQL->new( dbh => $dbh );

  # WHERE Machine.machine_id = 2
  $sql->where( $machine_id, '=', 2 );

=head1 DESCRIPTION

This class represents a stand-alone C<WHERE> clause. This allows you
pass a condition as part of an outer join.

=head1 METHODS

This class provides the following methods:

=head2 Constructor

To construct an object of this class, call C<< $query->where() >> on
a C<Fey::SQL> object.

=head2 $where->where()

See the L<Fey::SQL section on WHERE Clauses|Fey::SQL/WHERE Clauses>
for more details.

=head2 $where->bind_params()

See the L<Fey::SQL section on Bind Parameters|Fey::SQL/Bind
Parameters> for more details.

=head1 ROLES

This class does C<Fey::Role::SQL::HasWhereClause> role.

=head1 BUGS

See L<Fey> for details on how to report bugs.

=cut
