#!/usr/bin/perl
use strict;

my $man = `nroff -man accelerando.1`;
$man =~ s/(.)\x{08}./$1/g;
$man =~ s/[^ \w,.\-:;'"()[]{}<>+=|\\`~!?\/@#$%^&*_]//g;

my $version = `perl accelerando -v`;
$version =~ m/((\d+\.)+\d+)/;
$version = $1;
# ... same logic as in Makefile

# doesn't actually do version

print clean_up_text($man);

#------------------

sub clean_up_text {
  # gets rid of Mac and Windows curly quotes
  # changes crlf to \n, etc.
  # converts utf8/Mac/Win m-dashes to --, and n-dashes to -
  my $text = shift;
  # curly quotes:
  $text =~ s/\xe2\x80(\x9c|\x9d)/"/g; # utf8 curly quotes
  $text =~ s/\xe2\x80(\x98|\x99)/'/g; # utf8 curly apostrophe/single quotes
  $text =~ s/\xef\xa3\xa7/--/g; # utf8 m-dash
  $text =~ s/\xe2\x80\x94/--/g; # another type of utf8 m-dash??
  $text =~ s/(\223|\224)/"/g; # octal; Windows curly quotes
  $text =~ s/(\221|\222)/'/g; # octal; Windows curly apostrophe/single quotes
  $text =~ s/\226/-/g; # Windows n-dash
  $text =~ s/\227/--/g; # Windows m-dash
  $text =~ s/(\xd2|\xd3)/"/g; # Mac curly quotes
  $text =~ s/(\xd4|\xd5)/"/g; # Mac curly apostrophe/single quotes
  $text =~ s/\xd0/-/g; # Mac n-dash
  $text =~ s/\xd1/--/g; # Mac m-dash
  $text =~ s/\xc9/.../g; # Mac ellipsis
  $text =~ s/\r\n/\n/g; # crlf -> newline
  $text =~ s/\r/\n/g; # cr -> newline
  $text =~ s/\342\200\220/-/g; # octal; some goofy version of a hyphen
  return $text;
}
