package Fey::Column::Alias;

use strict;
use warnings;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_ro_accessors
    ( qw( alias_name column ) );

use Class::Trait ( 'Fey::Trait::ColumnLike' );

use Fey::Exceptions qw( object_state_error );
use Fey::Validate
    qw( validate
        SCALAR_TYPE
        COLUMN_TYPE );

use Fey::Column;

{
    for my $meth ( qw( name type generic_type length precision
                       is_auto_increment is_nullable table ) )
    {
        eval <<"EOF";
sub $meth
{
    shift->column()->$meth(\@_);
}
EOF
    }
}

{
    my %Numbers;
    my $spec = { column     => COLUMN_TYPE,
                 alias_name => SCALAR_TYPE( optional => 1 ),
               };
    sub new
    {
        my $class = shift;
        my %p     = validate( @_, $spec );

        unless ( $p{alias_name} )
        {
            my $name = $p{column}->name();
            $Numbers{$name} ||= 1;

            $p{alias_name} = $name . $Numbers{$name}++;
        }

        return bless \%p, $class;
    }
}

sub is_alias { 1 }

sub sql { $_[1]->quote_identifier( $_[0]->alias_name() ) }

sub sql_with_alias
{
    my $sql =
        $_[1]->quote_identifier( undef,
                                 $_[0]->_containing_table_name_or_alias(),
                                 $_[0]->name(),
                               );

    $sql .= ' AS ';
    $sql .= $_[1]->quote_identifier( $_[0]->alias_name() );

    return $sql;
}

sub sql_or_alias { goto &sql }

sub id
{
    my $self = shift;

    my $table = $self->table();

    object_state_error
        'The id() method cannot be called on a column alias object which has no table.'
            unless $table;

    return $table->id() . '.' . $self->alias_name();
}


1;

__END__

=head1 NAME

Fey::Column - Represents an alias for a column

=head1 SYNOPSIS

  my $alias = $user_id_col->alias();

=head1 DESCRIPTION

This class represents an alias for a column. Column aliases allow you
to use the same column in different ways multiple times in a query,
which makes certain types of queries simpler to express.

=head1 METHODS

=head2 Fey::Column::Alias->new()

This method constructs a new C<Fey::Column::Alias> object. It takes
the following parameters:

=over 4

=item * column - required

This is the C<Fey::Column> object which we are aliasing.

=item * alias_name - optional

This should be a valid column name for your DBMS. If not provided, a
unique name is automatically created.

=back

=head2 $alias->name()

This returns the name of the column for which this object is an alias.

=head2 $alias->alias_name()

Returns the name for this alias.

=head2 $alias->type()

=head2 $alias->generic_type()

=head2 $alias->length()

=head2 $alias->precision()

=head2 $alias->is_auto_increment()

=head2 $alias->is_nullable()

=head2 $alias->default()

Returns the specified attribute for the column, just like the
C<Fey::Column> methods of the same name.

=head2 $alias->table()

Returns the C<Fey::Table> object to which the column alias belongs, if
any.

=head2 $alias->is_alias()

Always returns false.

=head2 $alias->sql()

=head2 $alias->sql_with_alias()

=head2 $alias->sql_or_alias()

Returns the appropriate SQL snippet for the alias.

=head2 $alias->id()

Returns a unique identifier for the column. This method throws an
exception if the alias does not belong to a table.

=head1 TRAITS

This class does the C<Fey::Trait::ColumnLike> trait.

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=head1 BUGS

See C<Fey::Core> for details on how to report bugs.

=head1 COPYRIGHT & LICENSE

Copyright 2006-2007 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
