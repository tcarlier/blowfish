#!/usr/bin/perl -w

use English;
use strict;

sub BEGIN
{
  if ( $0 =~ /\/bin\/.*$/ )
  {
    push @INC, "$'/lib";
  }
  else
  {
    push @INC, "../lib";
  }
}

use MyLog;

# ----------------- Set the default variables ---------------------------------

my $debug  = 0;        # BOOL: undef or 0 is debug off, default is off
my $file   = ".data";  # STR:  name of the file

# ----------------- Usage and Process Command Line  ---------------------------

my(%Option, $commandLine );

sub PrintUsage # ($cmdLine )
{
  my($cmdLine ) = @_;

  print STDERR "Your command-line: [$cmdLine]\n" if $cmdLine;

  my $usage = <<USAGE;

SYNTAX:        $PROGRAM_NAME [ -debug ] [ -help ] [ -file FILE ]

DESCRIPTION:   testing out the Data::Dumper module

OPTIONS:
              -debug  Send debug messages to STDERR.
              -help   Send this message to STDOUT.

              -file   FILE   Name of the data file

USAGE

  print STDERR "$usage\n";

}

sub ProcessCmdLine
{

  use Getopt::Long qw(GetOptions);

  my(%OptionArg ) = (
                      "debug"  => \$Option{debug},
                      "help"   => \$Option{help},
                      "file"   => \$Option{file},
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
    MyLog::Debug("Running in debug mode", $debug);
    $debug  = 1;
  }

  $file = $Option{file} if $Option{file};

  my $expectedArgs = 0;
  if ($expectedArgs == @ARGV )
  {
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

# ----------- setup a hash

my %myHash;
for ( my $i = 0 ; $i < 11; $i++ )
{
  for ( my $j = 0 ; $j < 11; $j++ )
  {
    $myHash{$i}{$j} = 1;
  }
}

# ----------- open the data file

use MyFile;

my $data = *DATA;
MyLog::Fatal("Unable to open data file") if (!MyFile::OpenFile($file,$data,1));

# ----------- dump the hash to the data file

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Sortkeys = 1;

print DATA Dumper(\%myHash);
close DATA;

# ----------- read the data from the file into a hash reference

my $newData = *NEW;
MyLog::Fatal("Unable to open data file") if (!MyFile::OpenFile($file,$newData));
my $string = join ("", <NEW>);
close NEW;
my $hNew = eval "no strict; $string";

# ----------- print the new hash

foreach my $key (sort { $a <=> $b } keys %{$hNew})
{
  print "$key\n";
  foreach my $record (sort { $a <=> $b } keys %{$$hNew{$key}})
  {
    print "  $record\n";
  }
}
