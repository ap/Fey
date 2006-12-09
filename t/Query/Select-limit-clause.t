use strict;
use warnings;

use lib 't/lib';

use Q::Test;
use Test::More tests => 3;

use Q::Literal;
use Q::Query;


my $s = Q::Test->mock_test_schema_with_fks();

{
    my $q = Q::Query->new( dbh => $s->dbh() )->select();

    eval { $q->limit() };
    like( $@, qr/0 parameters/,
          'at least one parameter is required for limit()' );
}

{
    my $q = Q::Query->new( dbh => $s->dbh() )->select();

    $q->limit(10);

    is( $q->_limit_clause(), 'LIMIT 10',
        'simple limit clause' );
}

{
    my $q = Q::Query->new( dbh => $s->dbh() )->select();

    $q->limit( 10, 20 );

    is( $q->_limit_clause(), 'LIMIT 10 OFFSET 20',
        'limit clause with offset' );
}