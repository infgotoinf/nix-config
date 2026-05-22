#!/usr/bin/env perl

use v5.42;

sub find_the_thing($directory, $thing) {
    opendir my $dir, $directory or die "Could not open $directory!";
    while ($_ = readdir $dir) {
        next if ($_ eq '.' or $_ eq '..');
        my $path = "$directory/$_";
        if (-d $path) {
            find_the_thing($path, $thing);
            next;
        }

        open my $fh, '<', $path;
        my $first_iter = true;
        while(my $line = <$fh>) {
            if ($line =~ /$thing/) {
                if ($first_iter) {
                    say "$path:";
                    $first_iter = false;
                }
                print $line;
            }
        }

        print "\n", '-' x 60 if not $first_iter;

        # say $_;
    }
}


if (@ARGV != 2 or not -d $ARGV[0]) {
    say "rec_grep [DIRECTORY] [THING]";
    exit;
}

find_the_thing($ARGV[0], $ARGV[1]);
