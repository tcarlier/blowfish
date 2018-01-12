# Filename: MyFile.pm

package MyFile;

use MyLog;

my $debug = $ENV{PROSYS_DEBUG_ON};

#-----------------Public Methods-----------------------------------------------

###############################################################################
#
# Public Method:  FileExists
#
# Description:    Check to see if the file exists
#
# Return:         Returns 1 if the file exists, else return 0
#
###############################################################################

sub FileExists # ($file)
{
  my $file   = shift;          # STRING: Name of the file

  if (-e $file)
  {
    if (-f $file)
    {
      return 1;
    }
    else
    {
      MyLog::Error ("File $file is not a file");
      return 0;
    }
  }
  return 0;
}

###############################################################################
#
# Public Method:  OpenFile
#
# Description:    Opens the file
#
# Return:         Returns 1 if file open is successful, else return 0
#
###############################################################################

sub OpenFile # ($file, $handle, $write)
{
  my $file     = shift;          # STR: Name of the data file
  my $handle   = shift;          # REF: IO Filehandle reference
  my $write    = @_ ? shift : 0; # STR: read=0, write=1, append=2, default is 0

  if (($write == 2) || ($write == 1))
  {
    if (-f "$file.bak")
    {
      if (not unlink "$file.bak")
      {
        MyLog::Error ("Unable to unlink $file.bak");
        return 0;
      }
    }

    if (-f "$file")
    {
      if (not rename "$file", "$file.bak")
      {
        MyLog::Error ("Unable to rename $file $file.bak");
        return 0;
      }
    }

    if (($write == 1) && (not open $handle, ">$file"))
    {
      MyLog::Error ("Unable to open $file for writing");
      return 0;
    }

    if (($write == 2) && (not open $handle, ">>$file"))
    {
      MyLog::Error ("Unable to open $file for appending");
      return 0;
    }

  }
  else # open for reading
  {
    if (-e $file)
    {
      if (not open $handle, "<$file")
      {
        MyLog::Error ("Unable to open $file for writing");
        return 0;
      }
    }
    else
    {
      MyLog::Error ("No $file to open for reading");
      return 0;
    }
  }

  return 1;

}

1;
