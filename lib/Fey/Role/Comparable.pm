package Fey::Role::Comparable;

use strict;
use warnings;

use Fey::Policy;
use Moose::Role;


sub is_comparable { 1 }


1;

__END__

=head1 NAME

Fey::Trait::Comparable - A trait for things that can be part of a WHERE clause

=head1 SYNOPSIS

  use Class::Trait ( 'Fey::Trait::Comparable' );

=head1 DESCRIPTION

Classes which do this trait represent an object which can be compared
to a column in a C<WHERE> clause.

=head1 METHODS

This trait provides the following methods:

=head2 $object->is_comparable()

Returns true.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See C<Fey::Core> for details on how to report bugs.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
