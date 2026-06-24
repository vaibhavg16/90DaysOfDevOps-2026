#!/bin/bash

function usage {
	echo "Usage: .backup.sh <path to your source> <path to your backup directory>"
    echo ""
    echo "  source-directory  : the folder you want to back up"
    echo "  backup-directory  : where the backup zip files will be saved"
    echo ""
    echo "Example: ./backup.sh /var/www/myapp /backups"
    echo ""
}

# ---------------Check argument provided---------------

if [ $# -ne 2 ]; then
 	
 	usage	
	exit 1
fi


SOURCE="$1"
timestamp=$(date "+%Y-%m-%d-%H-%M-%S")
DEST="$2"


# ─── Check source exists ────────────────────────────────────

check_source(){

	find $SOURCE &>/dev/null || { echo "Source directory doesn't exists"; exit 1; }
	find $DEST &>/dev/null || { echo "Destination directory doesn't exists"; exit 1; }
}

# ─── Create destination if it doesn't exist ─────────────────

mkdir -p "$DEST"

backup(){

	echo "----------Taking backup----------"

	tar -czf "$DEST/backup-${timestamp}.tar.gz" "$SOURCE" &>/dev/null	
	if [ $? -eq 0 ]; then
        	echo "Back Up Complete"
    	else
        	echo "Backup Failed!"
    	fi
    	
	echo ""
}

print_file(){
	echo "----------Backup Taken----------"
	cd $DEST
	ls -lh backup-${timestamp}.tar.gz | awk '{print "Archive Name:"$9,"\nSize:"$5}'
	cd 
	echo
}

delete(){
	archives=$(find $DEST -name "*.tar.gz" -mtime +14)
	if [ -n "$archives" ]; then
		echo "----------Removing Archives Older than 14 days"
		for files in $archives; 
		do
			rm -f $files
			echo "Removed Archive : $files"
		done
	fi

}



check_source
backup
print_file
delete

