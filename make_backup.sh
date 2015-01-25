#!/bin/bash

fig stop
archive_filename=phabricator-backup.tar

docker run --volumes-from dockerphabricator_data_1 -v $(pwd):/backup/ ubuntu tar cvf /backup/${archive_filename} /var/lib/mysql /opt/phabricator/conf /etc/ssl/spistresci

fig up -d

bakthat backup --prompt no $archive_filename

rm $archive_filename
