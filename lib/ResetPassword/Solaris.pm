
package ResetPassword::Solaris;

use strict;
use warnings;

sub remove_user_from_passhistory {

    my ($username) = shift;

    my $passhistory = '/etc/security/passhistory';
    my $tmpfile = '/tmp/bot.passhistory';

    my $remove_user_from_passhistory = RemoteCommand->new({ expect => RemCmd->expect });

    $remove_user_from_passhistory->run({
            execute => 'egrep /^$username/ $passhistory',
            error_message => 'grep failed on passhistory: ',
            failure => 'throw'
        })->run({
            execute => "sed '/^$username:/d' $passhistory > $tmpfile",
            error_message => 'sed failed on passhistory: ',
            failure => 'throw'
        })->run({
            execute => "mv $tmpfile $passhistory";
            error_message => 'failed to update passhistory: ',
            failure => 'throw'
        })->run({
            execute => "rm $tmpfile",
            error_message => 'clean up failed passhistory',
            failure => 'ignore'
        });

    return $remove_user_from_passhistory->rt;
}

1;
