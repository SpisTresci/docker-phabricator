#!/bin/bash

fig stop
archive_filename=phabricator-backup.tar.bz2

docker run -i -t --volumes-from dockerphabricator_data_1 -v $(pwd):/backup/ ubuntu tar jcvf /backup/${archive_filename} /var/lib/mysql /var/repo /opt/phabricator/conf

fig up -d

bakthat backup --prompt no $archive_filename
