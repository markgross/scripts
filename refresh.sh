#!/bin/sh

top=`pwd`

QUEUE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git"
STABLE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
MIRROR_DIR="/x/mark/$HOME/mirror"
MIRROR="$MIRROR_DIR/linux-stable.git"

mkdir -p $MIRROR_DIR
cd $MIRROR_DIR
git clone --mirror $STABLE
cd $MIRROR
git fetch --all
cd $top

git clone $QUEUE

cd stable-queue
git fetch
git checkout stable/master
trees=`ls -d review-* queue-*`
cd $top

for b in $trees; do mkdir $top/$b; cd $top/$b; \
       git clone $MIRROR; \
       cd linux-stable; \
       git fetch --all; \
       git clean -xdf; \
       git merge --abort; \
       git am --abort; \
       git rebase --abort; \
       git reset --hard; \
       branch=${b#"queue-"}; \
       git checkout --detach origin/linux-$branch.y; \
       cp -r $top/stable-queue/$b patches; \
       done;

