#!/usr/bin/env perl


use strict; use warnings;

use Test::More tests => 9;
use Test::Spec;
use Try::Tiny;

BEGIN {
    use_ok('RemoteCommand');
}

describe "run" => sub {
    describe "missing expect instance" => sub {
        my $caught_something = 0;
        try {
            my $rc = RemoteCommand->new;
        } catch {
            ok($_ =~ /expect/);
            $caught_something = 1;
        };
        is($caught_something, 1, "missing expect instance");
    };
    
    describe "invalid args" => sub {
        my $rc = RemoteCommand->new({ expect => 'foobar' });
        describe "execute" => sub {
            my $caught_something = 0;
            try {
                $rc->run({ error_message => '', failure => '' });
            } catch {
                ok($_->isa('BadArguement'));
                $caught_something = 1;
            };
            is($caught_something, 1, "invalid arg: missing execute arg");
        };

        describe "error_message" => sub {
            my $caught_something = 0;
            try {
                $rc->run({ execute => '', failure => '' });
            } catch {
                ok($_->isa('BadArguement'));
                $caught_something = 1;
            };
            is($caught_something, 1, "invalid arg: missing error_message arg");
        };

        describe "failure" => sub {
            my $caught_something = 0;
            try {
                $rc->run({ execute => '', error_message => '' });
            } catch {
                ok($_->isa('BadArguement'));
                $caught_something = 1;
            };
            is($caught_something, 1, "invalid arg: missing failure arg");
        };
    };
};

