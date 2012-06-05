#
# This file is part of Text-CGILike
#
# This software is copyright (c) 2011 by Geistteufel <geistteufel@celogeek.fr>.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package Text::CGILike;

# ABSTRACT: Wrapper to create text file using the CGI syntax

use strict;
use warnings;
use Moo;
use Text::Format;

our $VERSION = '0.1';    # VERSION

our ( @ISA, @EXPORT, %EXPORT_TAGS );

BEGIN {
    require Exporter;

    my @html2    = qw/start_html end_html hr h1 ul li br/;
    my @netscape = qw/center/;

    @ISA         = qw(Exporter);
    @EXPORT      = ( @html2, @netscape );
    %EXPORT_TAGS = (
        'html2'    => [@html2],
        'netscape' => [@netscape],
        'standard' => [@EXPORT]
    );
}

my $_DEFAULT_CLASS;

has 'columns' => (
    is      => 'rw',
    default => sub {80},
);

sub DEFAULT_CLASS {
    return _self_or_default(shift);
}

sub start_html {
    my ( $self, $text ) = _self_or_default(@_);
    $self->{_start_html} = $text;
    return $self->hr . $self->_center( "# ", " #", $text ) . $self->hr . "\n";
}

sub end_html {
    my ($self) = _self_or_default(@_);
    my $text = $self->{_start_html} || "END";
    return "\n" . $self->hr . $self->_center( "# ", " #", $text ) . $self->hr;
}

sub h1 {
    my ( $self, $title ) = _self_or_default(@_);
    return $self->_left( "# ", $title ) . $self->br();
}

sub hr {
    my ($self) = _self_or_default(@_);

    return "#" x ( $self->columns ) . "\n";
}

sub br {
    return "\n";
}

sub center {
    my ( $self, $text ) = _self_or_default(@_);
    return $self->_center( '', '', $text );
}

sub ul {
    my ( $self, @li ) = _self_or_default(@_);
    return join( "", grep {defined} @li );
}

sub li {
    my ( $self, $li ) = _self_or_default(@_);
    my $TF
        = Text::Format->new(
        { firstIndent => 0, bodyIndent => 2, columns => $self->columns - 2 }
        );
    return "- " . $TF->format($li);
}

### PRIVATE ###

sub _self_or_default {
    my ( $may_class, @param ) = @_;
    if ( ref $may_class eq __PACKAGE__ ) {
        return ( $may_class, @param );
    }
    else {
        $_DEFAULT_CLASS ||= __PACKAGE__->new;
        return ( $_DEFAULT_CLASS, $may_class, @param );
    }
}

sub _center {
    my $self = shift;
    my ( $left, $right, $text ) = @_;
    $left  = "" unless defined $left;
    $right = "" unless defined $right;

    my $size = $self->columns - length($left) - length($right);
    my $TF   = Text::Format->new(
        { firstIndent => 0, bodyIndent => 0, columns => $size } );

    my @texts = $TF->format($text);
    return join(
        "",
        map {
            $_ = $TF->center($_);
            chomp;
            sprintf( $left . "%-" . $size . "s" . $right . "\n", $_ );
            } @texts
    );

}

sub _left {
    my $self = shift;
    my ( $left, $text ) = @_;
    $left = "" unless defined $left;

    my $size = $self->columns - length($left);
    my $TF   = Text::Format->new(
        { firstIndent => 0, bodyIndent => 0, columns => $size } );

    my @texts = $TF->format($text);
    return $left . join( "" . $left, @texts );

}

1;

=pod

=head1 NAME

Text::CGILike - Wrapper to create text file using the CGI syntax

=head1 VERSION

version 0.1

=head1 ATTRIBUTES

=head2 DEFAULT_CLASS

To change columns using keywords

    require Text::CGILike;
    Text::CGILike->import(':standard');

    require Term::Size;
    my ($columns) = Term::Size::chars();
    $columns ||= 80;

    my ($TCGI) = Text::CGILike->DEFAULT_CLASS;
    $TCGI->columns($columns);

=head1 SEE ALSO

L<CGI>

=head1 BUGS

Any bugs or evolution can be submit here :

L<Github|https://github.com/geistteufel/Text-CGILike>

=head1 AUTHOR

Geistteufel <geistteufel@celogeek.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Geistteufel <geistteufel@celogeek.fr>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__
