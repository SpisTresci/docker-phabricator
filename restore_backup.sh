#!/bin/bash
docker run --volumes-from dockerphabricator_data_1 -v $(pwd):/backup ubuntu tar -vxjf /backup/phabricator-backup-latest.tar.bz2
