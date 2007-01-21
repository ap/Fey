package Fey::Trait::Query::HasWhereClause;

use strict;
use warnings;

use Class::Trait 'base';

use Fey::Query::Fragment::Where::Boolean;
use Fey::Query::Fragment::Where::Comparison;
use Fey::Query::Fragment::Where::SubgroupStart;
use Fey::Query::Fragment::Where::SubgroupEnd;


sub where
{
    my $self = shift;

    $self->_condition( 'where', @_ );

    return $self;
}


{
    my %dispatch = ( 'and' => '_and',
                     'or'  => '_or',
                     '('   => '_subgroup_start',
                     ')'   => '_subgroup_end',
                   );
    sub _condition
    {
        my $self = shift;
        my $key  = shift;

        if ( @_ == 1 )
        {
            if ( my $meth = $dispatch{ lc $_[0] } )
            {
                $self->$meth($key);
                return;
            }
        }

        if ( @{ $self->{$key} || [] }
             && ! (    $self->{$key}[-1]->isa('Fey::Query::Fragment::Where::Boolean')
                    || $self->{$key}[-1]
                            ->isa('Fey::Query::Fragment::Where::SubgroupStart')
                  )
           )
        {
            $self->_and($key);
        }

        push @{ $self->{$key} },
            Fey::Query::Fragment::Where::Comparison->new(@_);
    }
}

sub _and
{
    my $self = shift;
    my $key  = shift;

    push @{ $self->{$key} },
        Fey::Query::Fragment::Where::Boolean->new( 'AND' );

    return $self;
}

sub _or
{
    my $self = shift;
    my $key  = shift;

    push @{ $self->{$key} },
        Fey::Query::Fragment::Where::Boolean->new( 'OR' );

    return $self;
}

sub _subgroup_start
{
    my $self = shift;
    my $key  = shift;

    push @{ $self->{$key} },
        Fey::Query::Fragment::Where::SubgroupStart->new();

    return $self;
}

sub _subgroup_end
{
    my $self = shift;
    my $key  = shift;

    push @{ $self->{$key} },
        Fey::Query::Fragment::Where::SubgroupEnd->new();

    return $self;
}

sub _where_clause
{
    return unless $_[0]->{where};

    return ( 'WHERE '
             . ( join ' ',
                 map { $_->sql( $_[0]->quoter() ) }
                 @{ $_[0]->{where} }
               )
           )
}


1;

__END__
