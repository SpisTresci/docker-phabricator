#!/bin/bash

fig stop
archive_filename=phabricator-backup.tar

bakthat restore $archive_filename
docker run --volumes-from dockerphabricator_data_1 -v $(pwd):/backup ubuntu tar -vxf /backup/${archive_filename}

fig up -d

rm $archive_filename
