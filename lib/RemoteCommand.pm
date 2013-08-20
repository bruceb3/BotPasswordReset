package RemoteCommand;
use Mouse;
use strict;
use warnings;
use Bot::Exceptions;

use Carp;

sub run {
    my ($self, $args) = @_;
    _ensure_vaild_args($args);
    _set_default_success_definition($args);
    my $expect = $self->expect;
    $self->rt( $expect->execute({ command => $self->{command} }) );
    $self->handle_possible_errors;
    return $self;
}

sub handle_possible_errors {
    my $self = shift;
}

sub _ensure_vaild_args {
    my ($self, $args) = @_;
    for my $arg ( _list_of_valid_args() ) {
        unless (defined $args->{$arg}) {
            BadArguement->throw(UserErrorMessage => "RemoteCommand::run missing '$arg' arg")
        }
    }
    if (defined $args->{success}) {
        BadArguement->throw(UserErrorMessage => "RemoteCommand::run unrecognised value for success")
            unless _success_value_valid($args->{success});
    }
}

sub _list_of_valid_args {
    return qw[ execute error_message failure ];
}

sub _set_default_success_definition {
    my $args = shift;
    $args->{success} = _default_success_defintion() if (not defined $args->{success});
}

sub _success_value_valid {
    my $value = shift;
    return grep { $_ eq $value } _valid_values_for_success();
}

sub _default_success_defintion {
    return 'worked';
}

sub _valid_values_for_success {
    return qw( 'worked' 'ok' 'ignore' );
}


has 'expect' => (
    is => 'rw',
    default => sub { croak "No expect instance supplied" },
);

has 'rt' => (
    is => 'rw',
    default => undef,
);

1;
