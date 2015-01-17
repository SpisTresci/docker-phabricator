#!/bin/bash

fig stop
archive_filename=phabricator-backup.tar.bz2

bakthat restore $archive_filename
docker run --volumes-from dockerphabricator_data_1 -v $(pwd):/backup ubuntu tar -vxjf /backup/${archive_filename}

fig up -d
