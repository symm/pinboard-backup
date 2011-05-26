### What it does 
Gives you version controlled backups of your [Pinboard](http://pinboard.in/ "Pinboard") bookmarks

### What you will need
Git, Perl, LWP and SSLeay (apt-get install libcrypt-ssleay-perl)

### How to get started

Set your $username and $password in backup.pl
Run ./backup.pl and a new git repo will be created in ~/.pinboard. The exports will be saved here.

Once you have verified everything is working, you may wish to set up a weekly cron:

        crontab -e
        @weekly /path/to/backup.pl 

Changes to your bookmarks get saved as a new commit, so you can have a nice running history of saved links.

### Changes

#### 2011-05-26
*  Changes to the basic auth login on pinboard required a rewrite. We now use Perl LWP.
*  Script name is now backup.nl
*  .netrc credentils are no longer used
*  Currently does a html export and is saved as bookmarks.html. Support for other formats might come later. 
