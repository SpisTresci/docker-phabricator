#!/bin/bash
timestamp=`date +"%Y%m%d%H%M%S"`
archive_filename=phabricator-backup-${timestamp}.tar.bz2
docker run -i -t --volumes-from dockerphabricator_data_1 -v $(pwd):/backup/ ubuntu tar jcvf /backup/${archive_filename} /var/lib/mysql /var/repo /opt/phabricator/conf
echo $archive_filename
ln -sf $archive_filename phabricator-backup-latest.tar.bz2
