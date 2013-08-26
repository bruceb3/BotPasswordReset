
package ResetPassword;

our $VERSION = '1.0';

=head1 NAME

ResetPassword - Reset passwords on remote systems.

=cut

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw( reset_password );

use Expect;

BEGIN {
    *exp_continue = *Expect::exp_continue;
    *exp_continue_timeout = *Expect::exp_continue_timeout;
}


sub reset_password {
    my ($expect, $username, $password) = @_;

    $expect->send("passwd $username");
    my $status;
    $status = $expect->expect( 
        [ qr/[nN]ew [pP]assword:/m, sub {
                shift;
                $expect->send($password);
                exp_continue;
            }],

        [ qr/Re-enter New password:/m, sub {
                shift;
                $expect->send($password);
                exp_continue;
            }],
        [ $expect->shell_prompt(), sub { undef } ],
    );
    return $status;
}

1;
