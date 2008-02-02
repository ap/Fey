## no critic
package # Hide from PAUSE
    Fey::FakeDBI;

use strict;
use warnings;

# This package allows us to use a DBI handle in id(). Even though we
# may not be quoting properly for a given DBMS, we will still generate
# unique ids, and that's all that matters.

sub isa
{
    return 1 if $_[1] eq 'DBI::db';
}

sub quote_identifier
{
    shift;

    if ( @_ == 3 )
    {
        return q{"} . $_[1] . q{"} . q{.} . q{"} . $_[2] . q{"}
    }
    else
    {

        return q{"} . $_[0] . q{"};
    }
}

sub quote
{
    my $text = $_[1];

    $text =~ s/"/""/g;
    return q{"} . $text . q{"};
}

1;

__END__