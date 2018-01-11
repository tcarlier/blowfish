#!/usr/bin/perl -w

# Filename: blowfish.pl

use English;
use strict;

use Crypt::Blowfish;
use lib "../lib";
use lib "./lib";
use  MyLog;

# ----------------- Set the default variables ---------------------------------

my $debug  = 0;        # BOOL: undef or 0 is debug off, default is off
my $password;          # STR:  password

# ----------------- Usage and Process Command Line  ---------------------------

my(%Option, $commandLine );

sub PrintUsage # ($cmdLine )
{
  my($cmdLine ) = @_;

  print STDERR "Your command-line: [$cmdLine]\n" if $cmdLine;

  my $usage = <<USAGE;

SYNTAX:        $PROGRAM_NAME [ -debug ] [ -help ] PASSWORD

DESCRIPTION:   template for creating perl scripts.

OPTIONS:
               debug  Send debug messages to STDERR.
               help   Send this message to STDOUT.

PARAMETERS:
               PASSWORD An 8 character password

EXAMPLES:

NOTES:

USAGE

  print STDERR "$usage\n";

}

sub ProcessCmdLine
{

  use Getopt::Long qw(GetOptions);

  my(%OptionArg ) = (
                      "debug"  => \$Option{debug},
                      "help"   => \$Option{help},
                     );

  $commandLine = "$PROGRAM_NAME @ARGV";

  my($GetoptsRet ) = Getopt::Long::GetOptions(%OptionArg );

  if (! $GetoptsRet ) {
    MyLog::Error("GetOptions() failed.  ARGV = <@ARGV>" );
    PrintUsage();
    exit;
  }

  if ($Option{help} )
  {
    PrintUsage($commandLine );
    exit 0;
  }

  if ($Option{debug} )
  {
    MyLog::Debug("Running in debug mode" );
    $debug  = 1;
  }

  my $expectedArgs = 1;
  if ($expectedArgs == @ARGV )
  {
    $password = shift @ARGV;
  }
  elsif (@ARGV > $expectedArgs )
  {
    MyLog::Error("Too many command line arguments" );
    PrintUsage();
    exit 1;
  }
  else # (@ARGV > $expectedArgs )
  {
    MyLog::Error("Missing command line arguments" );
    PrintUsage();
    exit 1;
  }

}

# ----------------- Subroutines ------------------------------------------------

# ----------------- Main program begins ----------------------------------------

ProcessCmdLine();

my $key = "123456781245678";
my $cipher = new Crypt::Blowfish $key; 

my $ciphertext = $cipher->encrypt($password);
my $plaintext  = $cipher->decrypt($ciphertext);

print "Original password:  \'$password\'\n";
print "Encrypted password: \'$ciphertext\'\n";
print "Decrypted password: \'$plaintext\'\n";


