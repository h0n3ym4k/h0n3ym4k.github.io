#!/usr/bin/perl -W

use strict;
use warnings;

my $email_sender_installed = eval { require Email::Sender; 1 };
my $mail_sender_installed = eval { require Mail::Sender; 1 };

if ($email_sender_installed) {
    print "Email::Sender is installed\n";
} elsif ($mail_sender_installed) {
    print "Mail::Sender is installed\n";
} else {
    print "Neither Email::Sender nor Mail::Sender is installed\n";
}