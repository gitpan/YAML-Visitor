package YAML::Visitor;
use strict;
use warnings;
use YAML::Syck;
our $VERSION = '0.00003';

sub new {
    my $class = shift;
    my %args  = @_;

    my $self = bless {}, $class;
    $self->{callback} =
      ref $args{callback} eq 'CODE' ? $args{callback} : sub { $_ };
    $self;
}

sub visit {
    my $self = shift;
    my %args = @_;

    my $config;
    if ( exists $args{file} ) {
        $config = YAML::Syck::LoadFile( $args{file} );
    }
    elsif ( exists $args{data} ) {
        $config = YAML::Syck::Load( $args{data} );
    }
    else {
        die("read error: Can not Load yaml");
    }

    return $self->_visit($config);
}

sub _visit {
    my $self   = shift;
    my $config = shift;
    my $filter = $self->{callback};

    if ( ref $config eq 'HASH' ) {
        for my $key ( keys %$config ) {
            if (   ref $config->{$key} eq 'ARRAY'
                || ref $config->{$key} eq 'HASH' )
            {
                $config->{$key} = $self->_visit( $config->{$key} );
            }
            else {
                $config->{$key} = $filter->( $config->{$key} );
            }
        }
    }
    elsif ( ref $config eq 'ARRAY' ) {
        for ( 0 .. ( scalar(@$config) - 1 ) ) {
            if ( ref $config->[$_] eq 'ARRAY' || ref $config->[$_] eq 'HASH' ) {
                $config->[$_] = $self->_visit( $config->[$_] );
            }
            else {
                $config->[$_] = $filter->( $config->[$_] );
            }
        }
    }

    return $config;
}

1;
__END__

=head1 NAME

YAML::Visitor - Like visitor style traversal for yaml 

=head1 SYNOPSIS

  use YAML::Visitor;

  my $visitor = YAML::Visitor->new(
      callback => sub {
          my $value = shift:
          if (defined $value) {
              $value =~ s/path_to/path/ge;
          }
          $value;
      }
  );

  my $config = $visitor->visit( file => $path );
  my $config = $visitor->visit( data => $yaml );

=head1 DESCRIPTION

YAML::Visitor is like visitor style traversal for yaml

=head1 METHODS

=head2 new( callback => sub {...} )

=head2 visit( file => $path or data => $yaml );

=head1 AUTHOR

Kazuhiro Nishikawa E<lt>kazuhiro.nishikawa@gmail.comE<gt>

=head1 SEE ALSO

L<Data::Visitor>
L<YAML::Syck>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
