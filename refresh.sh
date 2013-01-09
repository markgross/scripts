#!/bin/sh

top=`pwd`
ssd="/mnt/ssd"

QUEUE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git"
STABLE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
MIRROR="$ssd$top/mirror/linux-stable.git"

mkdir -p $ssd$top/mirror
cd $ssd$top/mirror
git clone --mirror $STABLE
cd linux-stable.git
git fetch --all
cd $top

git clone $QUEUE

cd stable-queue
git pull
trees=`ls -d queue-*`
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

