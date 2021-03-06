#!/bin/sh

top=`pwd`

#QUEUE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git"
#STABLE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"

cd stable-queue
git pull
trees=`ls -d queue-*`
cd $top

export PATH="/usr/lib/ccache:$PATH"

for b in $trees; do mkdir $top/$b; cd $top/$b; \
       cd linux-stable; \
       git clean -xdf 2>&1 > /dev/null; \
       git merge --abort 2>&1 > /dev/null; \
       git am --abort 2>&1 > /dev/null; \
       git rebase --abort 2>&1 > /dev/null; \
       git reset --hard 2>&1 > /dev/null; \
       branch=${b#"queue-"}; \
       git checkout origin/linux-$branch.y  -b `date -u +%Y_%b_%d_%H_%M_UTC`; \
       cp -r $top/stable-queue/$b patches; \
       nohup quilt push -a; \
       source $top/scripts/use_ccache.sh; \
       nohup make defconfig; \
       time nohup make -j 8; \
       file vmlinux; \
       done;

