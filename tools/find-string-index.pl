#!/usr/bin/perl

# this script tries to find the specified string in the specified file
# and outputs the index where the string is first found. note that the file
# can be binary, and a binary string can be specified using perl escape
# mechanism. for example, with the following command,
#
#   ./find-string-index.pl '\x1f\x8b' foo
#
# the script will return the index of the 2-byte binary string (gzip magic)
# in file foo. if the string is not found, it outputs nothing.

use strict;

my $pattern = '';
eval "\$pattern = \"$ARGV[0]\"";
my $plen = length($pattern);
my $file = $ARGV[1];
die "File \"$file\" cannot be read" if (! -r $file);

my $fh;
die "Can't open $file: $!" if (!open($fh, '<', $file));
my $buf;

my $pos = 0;
my $bsize = 16384;
while (read($fh, $buf, $bsize) > 0) {
  my $idx = index($buf, $pattern);
  if ($idx >= 0) {
    print ($pos + $idx);
    exit;
  }
  $pos += ($bsize - $plen);
  seek($fh, $pos, 0);
}

