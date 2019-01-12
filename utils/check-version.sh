#!/bin/sh
set -e

LAST_FULL_COMMIT=$(git ls-remote https://github.com/dimmsd/$1 refs/heads/master)
LAST_ACTUAL_COMMIT=$(echo $LAST_FULL_COMMIT | head -c 8)
#echo "!"$LAST_ACTUAL_COMMIT"!"

LAST_COMMIT=$(docker exec -it $2 /tmp/utils/show-version.sh)
#echo "!"$LAST_COMMIT"!"


if [ "$LAST_COMMIT" = "$LAST_ACTUAL_COMMIT" ]
then
    echo "Image $3 is actual"
else
    echo "Image $3 is not  actual. Use: docker pull $3"
fi
