# Filename: MyLog.pm

package MyLog;

# -----------------------------------------------------------------------------
# Name:        Info
#
# Description: Print info message to STDERR and return
#
# -----------------------------------------------------------------------------

sub Info # ( $message )
{
  my $message = shift @_;
  print STDERR "Info: $message\n";
  return;
}

# -----------------------------------------------------------------------------
# Name:        Debug
#
# Description: Print error message to STDERR and return
#
# -----------------------------------------------------------------------------

sub Debug # ( $message, [$debug] )
{
  my $message = shift @_;
  my $debug   = @_ ? shift : 0;
  print STDERR "Debug: $message\n" if ($debug);
  return;
}

# -----------------------------------------------------------------------------
# Name:        Error
#
# Description: Print error message to STDERR and return
#
# -----------------------------------------------------------------------------

sub Error # ( $message )
{
  my $message = shift @_;
  print STDERR "Error: $message\n";
  return;
}

# -----------------------------------------------------------------------------
# Name:        Fatal
#
# Description: Print error message to STDERR and exit with error code 1
#
# -----------------------------------------------------------------------------

sub Fatal # ( $message )
{
  my $message = shift @_;
  print STDERR "Error: $message\n";
  exit 1;
}

# -----------------------------------------------------------------------------
# Name:        FatalShellError
#
# Description: Print command output to STDERR and exit 1
# -----------------------------------------------------------------------------

sub FatalShellError # ( $thisCommand, @thisOuput )
{
  my $thisCommand  = shift @_;
  my @thisOutput   =       @_;

  print STDERR "Fatal Error Executing: $thisCommand\n\n";

  foreach ( @thisOutput )
  {
    print STDERR "$_\n";
  }

  exit 1;
}

1;

