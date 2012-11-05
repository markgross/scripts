TOP=`pwd`
ssd=/mnt/ssd

# if you are using you SSD as a ccache or out target you can mount it for speed 
# and give up on fault tollerance.
# add this to your /etc/init.d/rc.local (assuming /dev/sdb is your ssd)
# echo noop > /sys/block/sdb/queue/scheduler
#
# use this for your mount options for the ssd
# /dev/sdb1 /mnt/ssd ext4 discard,noatime,nodiratime,data=writeback,barrier=0,nobh 0 2


export USE_CCACHE=1
export CCACHE_DIR=$ssd$TOP/ccache
mkdir -p $CCACHE_DIR
ccache -F 1000000
ccache -M 8G

export CC="ccache gcc"
export CXX="ccache g++"

#export OUT_DIR_COMMON_BASE=$ssd$TOP
#bname=`basename $TOP`
##mkdir -p $OUT_DIR_COMMON_BASE/$bname
#rm out
#ln -s $OUT_DIR_COMMON_BASE/$bname out

