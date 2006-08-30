package Q::Column::Alias;

use strict;
use warnings;

use base 'Q::Accessor';
__PACKAGE__->mk_ro_accessors
    ( qw( alias_name column ) );

use Q::Exceptions qw( object_state_error );
use Q::Validate
    qw( validate
        SCALAR_TYPE
        COLUMN_TYPE );

use Q::Column;

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

sub id
{
    my $self = shift;

    my $table = $self->table();

    object_state_error
        'The id() method cannot be called on a column alias object which has no table.'
            unless $table;

    return $table->id() . '.' . $self->alias_name();
}

sub is_alias { 1 }

sub isa
{
    my $self  = shift;
    my $class = shift;

    return 1 if $class eq 'Q::Column';

    return $self->SUPER::isa($class);
}


1;

__END__