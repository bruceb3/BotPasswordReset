
package ResetPassword::Solaris;

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw( reset_password );

use ResetPassword;

sub reset_password {

    my ($expect, $username) = shift;

    my $passhistory = '/etc/security/passhistory';
    my $tmpfile = '/tmp/bot.passhistory';
    my $rmcmd = RemoteCommand->new({ expect => $expect });

    $rmcmd->run({ command => 'uname -r' });
    if ($rmcmd->rt->first_line eq '5.10') {
    }
    else {
    }

#    my $remove_user_from_passhistory = RemoteCommand->new({ expect => RemCmd->expect });

#    $remove_user_from_passhistory->run({
#            execute => 'egrep /^$username/ $passhistory',
#            error_message => 'grep failed on passhistory: ',
#            failure => 'throw'
#        })->run({
#            execute => "sed '/^$username:/d' $passhistory > $tmpfile",
#            error_message => 'sed failed on passhistory: ',
#            failure => 'throw'
#        })->run({
#            execute => "mv $tmpfile $passhistory",
#            error_message => 'failed to update passhistory: ',
#            failure => 'throw'
#        })->run({
#            execute => "rm $tmpfile",
#            error_message => 'clean up failed passhistory',
#            failure => 'ignore'
#        });
#
#    return $remove_user_from_passhistory->rt;

     return $rmcmd->rt;
}

1;
