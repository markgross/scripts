!#/bin/sh

top=`pwd`
ssd="/mnt/ssd"

QUEUE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git"
STABLE="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
MIRROR="$ssd$top/mirror/linux-stable.git"

cd stable-queue
git pull
trees=`ls -d queue-*`
cd $top

export PATH="/usr/lib/ccache:$PATH"

for b in $trees; do mkdir $top/$b; cd $top/$b; \
       cd linux-stable; \
       git clean -xdf; \
       git merge --abort; \
       git am --abort; \
       git rebase --abort; \
       git reset --hard; \
       branch=${b#"queue-"}; \
       git checkout origin/linux-$branch.y  -b `date -u +%Y_%b_%d_%H_%M_UTC`; \
       cp -r $top/stable-queue/$b patches; \
       quilt push -a; \
       source $top/use_ccache.sh; \
       nohup make defconfig; \
       time nohup make -j 8; \
       done;

