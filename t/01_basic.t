use strict;
use Test::More tests => 6;
use YAML::Visitor;

{
    my $visitor = YAML::Visitor->new(
        callback => sub {
            my $value = shift;
            if ( defined $value ) {
                $value =~ s/world/japan/g;
            }
            return $value;
        }, 
    );

    isa_ok( $visitor, 'YAML::Visitor' );

    my $yaml = q/
        string: world 
    /;

    my $config = $visitor->visit( data => $yaml );
    is ( $config->{string}, 'japan', 'yaml' );

    $config = $visitor->visit( file => 't/01_basic.yml' );
    is ( $config->{hash}, 'hoge', 'file' );

    eval { $visitor->visit() };
    like( $@, qr/read error:/, 'read error' );
}

{
    my $visitor = YAML::Visitor->new(
        callback => sub {
            my $value = shift;
            if ( defined $value ) {
                $value =~ s/foo/boo/g;
                $value =~ s/hoge/poge/g;
            }
            return $value;
        },
    );
    
    my $config = $visitor->visit( file => 't/01_basic.yml' );

    is( $config->{array}->[0], 'boo', 'params' );
    is( $config->{hash}, 'poge', 'params' );
}



