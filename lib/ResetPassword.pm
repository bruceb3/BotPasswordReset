
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
    my $number_of_passwords_given = 0;

    $expect->send("passwd $username");
    $expect->expect( 
        [ qr/[nN]ew [pP]assword:/m, sub {
                my ($pty) = @_;
                $number_of_passwords_given++;
                $pty->send($password);
                return exp_continue;
            }, $expect ],

        [ qr/Re-enter New password:/m, sub {
                my ($pty) = @_;
                $number_of_passwords_given++;
                $pty->send($password);
                return;
            }, $expect ]
    );
    my $status = $expect->wait_for_shell_prompt;
    return $status;
}

1;
