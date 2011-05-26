#!/usr/bin/env perl
# https://github.com/symm/pinboard-backup
# Performs version controlled backup of your http://pinboard.in/ bookmarks
use strict;
use LWP;
use Crypt::SSLeay;
###########################
# Set your credentials here
my $username = "";
my $password = "";
###########################
my $dest_dir = "$ENV{HOME}/.pinboard/";
my $user_agent = "PinboardBackup 0.3";
my $login_url = "https://pinboard.in/auth/";
my $bookmarks_url = "https://pinboard.in/export/format:html/";
my $logout_url = "http://pinboard.in/logout/";

# Check for empty credentials
if (!$username || !$password){
  print "Please edit $0 to include your pinboard.in username and password\n";
  exit 1;
}

chdir($dest_dir);
# Check for our Git repo
if(-d $dest_dir){
  system('git status > /dev/null 2>&1');
  if ($? != 0){
    print "Sorry, ".$dest_dir." does not appear to be a valid Git repo, bailing!\n";
    exit 1;
  }
}else{
  # Otherwise, start a new one.
  system('git init '.$dest_dir);
  if ($? != 0){
    print "Error making a Git repo, bailing!\n";
    exit 1;
  }
}

my $ua = LWP::UserAgent->new;
$ua->agent($user_agent);
$ua->cookie_jar( {} );

# Login to the site
my $req = HTTP::Request->new(POST => $login_url);
$req->content_type('application/x-www-form-urlencoded');
$req->content('username='.$username.'&password='.$password);
my $response = $ua->request($req);

# fetch the bookmark export
my $bookmarks = HTTP::Request->new(GET => $bookmarks_url);
$response = $ua->request($bookmarks);

if ($response->is_success){
  open (DEST, ">".$dest_dir."bookmarks.html");
  print DEST $response->content;
  close (DEST);

  chdir($dest_dir);
  system('git add bookmarks.html >/dev/null 2>&1');
  system('git commit -m "Pinboard Backup" >/dev/null 2>&1');
  if ($? == 0){
    print "Your bookmarks are now safe and sound.\n";
  }elsif ($? == 256){
    print "Nothing new to backup :)\n";
  }else{
    print "There was an error saving your bookmarks.";
  }
}
else{
  print STDERR "Error fetching bookmarks.\n";
  print $response->status_line;
}

$ua->request( HTTP::Request->new(GET => $logout_url) );
