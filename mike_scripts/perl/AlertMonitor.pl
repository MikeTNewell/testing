#!/usr/local/bin/perl -w

#  trlogmon.p - Oracle alert log monitor
#
#  Synopsis:  Monitors the instance alertlog for ORA- errors (or anything else
#             you would like to look for).  When these errors are encountered,
#             email is sent to the DBA.
#
#  usage:  trlogmon.p -sleep <seconds>
#

=head1 NAME

trlogmon - Oracle alert log monitor

=head1 SYNOPSIS

trlogmon.p [-sleep <seconds>]

=head1 DESCRIPTION

Monitors the Oracle instance alert log for problems (i.e. ORA-00600, block 
corruption errors, etc).

The log file is monitored in a manner similar to the B<UNIX tail(1)> command,
using the '-f' switch.  This is done by resetting the error flag on the file
when EOF is encountered.

Problems are extracted via the use of B<regexes> to find the interesting lines 
in the alert log.

=head1  SEE ALSO

=over 4

=item 1

tail(1)

=item 2

The Perl Cookbook, ISBN 1-56592-243-3, Recipe #8.5, B<Tailing a Growing File>

=back 4

=head1 AUTHOR

Ron Reidy  rereidy@uswest.net

=cut

use strict;
use Carp;

use DBI;
use File::Basename;
use FileHandle;
use Getopt::Long;
use Net::SMTP;
use POSIX qw/uname/;

use vars qw/$dbh $scr $sleep_time/;

$scr = basename($0, '');

GetOptions('sleep:i', \$sleep_time);
$sleep_time = 60 if (!defined $sleep_time);

my $computer_name = (uname())[1];

$dbh = DBI->connect('dbi:Oracle:', 'wf_monitor', 'wf_monitor', 
		    {RaiseError => 0, PrintError => 0, AutoCommit => 0}) || 
       die "$scr: connect error on $computer_name [$DBI::errstr]";

my $alert_log = get_alert();
$dbh->disconnect;

my $alert_fh = new FileHandle $alert_log, "r";
die "$scr: cannot open \"$alert_log\" on $computer_name [$!]" if (!defined $alert_fh);

my @group;
my $starting = 0;

for (;;)
{
  while (<$alert_fh>)
  {
    # get a date tag for today
    my $today = localtime;
    $today =~ m/^(\S+\s+\S+\s+\d+)  # word (like Wed) followed by Mon and Day
		\s+\d+:\d+:\d+\s+   # the time - ignored
		(\d+)               # the year
	       /x;

    my $today_date_tag = $1 . ' ' .$2;

    # make a date tag for the current line read
    my $log_date_tag;
    if (m/^(\S+\s+\S+\s+\d+)  # word (like Wed) followed by Mon and Day
          \s+\d+:\d+:\d+\s+   # the time - ignored
	  (\d+)               # the year
	 /x)
    {
      $log_date_tag = $1 . ' ' . $2 if (defined $1 && defined $2);

      next if ($today_date_tag ne $log_date_tag);

      if ($starting == 1)
      {
        if (check_group(\@group, "ORA\-"))
	{
	  eval
	  {
	    my $smtp = Net::SMTP->new($::config->{email}->{SMTPHost});
	    if (!defined $smtp)
	    {
	      die "$scr: cannot create Net::SMTP object on $computer_name [$!]";
	    }

	    if ($smtp->mail(localhost))
		$smtp->to("xyz@email.com"))
	    {
	      $smtp->data();
	      $smtp->data("\nAlert log errors for $ENV{ORACLE_SID}:\n");
	      $smtp->data(@group);
	      $smtp->data("\n\n");
	    }
	    else
	    {
	      die "$scr: SMTP error for mail() or to() on $computer_name - " . $smtp->message;
            }

	    $smtp->quit();

	  };

	  print STDERR "$@\n" if $@;

	}

        $#group = -1;
	$starting = 0;
      }

      $starting = 1;
      push @group, $_;
    }
    else
    {
      push @group, $_ if ($starting == 1);
    }
  }

  sleep $sleep_time;
  $alert_fh->clearerr();

}

exit 0;

END
{
  $dbh->disconnect if (defined $dbh);
  undef $alert_fh if (defined $alert_fh);
}

#
# check_group - check the group of lines for errors
#
sub check_group
{
  my $group_list = shift;
  my $_regex = shift;

  my $found = 0;

  foreach (@$group_list)
  {
    if (m/$_regex/)
    {
      $found = 1;
      last;
    }
  }

  return $found;

}  # end of check_group

#
# get_alert_log - get the location of the alert log from the RDBMS
#
sub get_alert
{
  my $sth = $dbh->prepare(q{
	SELECT value 
	FROM   v$parameter 
	WHERE  name = 'background_dump_dest'}) || 
      die "$scr: prepare error on $computer_name [$DBI::errstr]";

  $sth->execute;
  my $row = $sth->fetchrow_hashref;
  $sth->finish;

  return $row->{VALUE} . "/alert_" . $ENV{ORACLE_SID} . ".log";

}  # end of get_alert

