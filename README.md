### What it does 
Gives you version controlled backups of your [Pinboard](http://pinboard.in/ "Pinboard") bookmarks

### What you will need
Git, Curl and Bash

### How to get started
Add your credentials to ~/.netrc
	
        machine pinboard.in login <pinboard-login> password <pinboard-password>

When you run the script a new git repo will be created in ~/.pinboard and the export will be saved as pinboard.html

Once you have verified everything is working, you may wish to set up a weekly cron:

        crontab -e
        0 12 * * 5 /path/to/pinboard-backup.sh 

### Changes
#### 2011-03-26

*  Script now outputs its status instead of going to syslog
*  Added a basic check to verify the retrieved filetype.
*  Renamed the backup file to pinboard.html. If you used a previous version and would like to retain your history:

        cd ~/.pinboard
        git mv pinboard.xml pinboard.html
        git commit -m "Renamed the exports file"

