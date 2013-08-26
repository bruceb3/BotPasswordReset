
package ResetPassword::AIX;

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

    my $rt;

    $rt = ResetPassword::reset_password($expect, $username, $password);
    if ($rt->worked) {
        $rt = $expect->execute({ command => 'pwdadm -c $username' });
    }

    return $rt;
}

1;
