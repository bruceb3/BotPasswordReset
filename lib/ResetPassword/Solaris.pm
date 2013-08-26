
package ResetPassword::Solaris;

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw( reset_password );

use ResetPassword;
use RemoteCommand;

sub reset_password {

    my ($expect, $username, $password) = @_;

    die "Solaris::reset_password no username\n" unless defined $username; 
    die "Solaris::reset_password no password\n" unless defined $password; 

    my $rmcmd = RemoteCommand->new({ expect => $expect });
    my $rt;

    try {
        $rmcmd->run({
            execute => 'uname -r',
            error_message => 'uname failed'
        });

        if ($rmcmd->rt->first_line eq '5.10') {
            my $passhistory = '/etc/security/passhistory';
            my $tmpfile = '/tmp/bot.passhistory';
            $rmcmd->run({
                execute => "egrep \"^$username\" $passhistory",
                error_message => 'grep failed on passhistory: ',
                failure => 'ignore'
            });
            if ($rmcmd->rt->ok and defined $rmcmd->rt->first_line) {
                $rmcmd->run({
                    execute => "sed '/^$username:/d' $passhistory > $tmpfile",
                    error_message => 'sed failed on passhistory: ',
                })->run({
                    execute => "mv $tmpfile $passhistory",
                    error_message => 'failed to update passhistory: ',
                })->run({
                    execute => "rm $tmpfile",
                    error_message => 'clean up failed passhistory',
                    failure => 'ignore'
                });
            }
        }
        $rt = ResetPassword::reset_password($expect, $username, $password);
    };

    return defined $rt ? $rt : $rmcmd->rt;
}

1;
