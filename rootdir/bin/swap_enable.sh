#!/vendor/bin/sh
#
#ifdef OPLUS_FEATURE_ZRAM_OPT
#huacai.zhou@PSW.BSP.kernel.drv, 2018/03/09, adjust zram size according to total ram size
    MemTotalStr=`cat /proc/meminfo | grep MemTotal`
    MemTotal=${MemTotalStr:16:8}
    kswapd_num=`getprop ro.multi_kswapd.number`

    echo lz4 > /sys/block/zram0/comp_algorithm
    echo 160 > /proc/sys/vm/swappiness
    echo 60 > /proc/sys/vm/direct_swappiness
    echo 0 > /proc/sys/vm/page-cluster
    if [ -f /sys/block/zram0/disksize ]; then
        if [ -f /sys/block/zram0/use_dedup ]; then
            echo 1 > /sys/block/zram0/use_dedup
        fi

        if [ $MemTotal -le 524288 ]; then
            #config 384MB zramsize with ramsize 512MB
            echo 402653184 > /sys/block/zram0/disksize
        elif [ $MemTotal -le 1048576 ]; then
            #config 768MB zramsize with ramsize 1GB
            echo 805306368 > /sys/block/zram0/disksize
        elif [ $MemTotal -le 2097152 ]; then
            #config 1GB+256MB zramsize with ramsize 2GB
            echo lz4 > /sys/block/zram0/comp_algorithm
            echo 1342177280 > /sys/block/zram0/disksize
        elif [ $MemTotal -le 3145728 ]; then
            #config 1GB+512MB zramsize with ramsize 3GB
            echo lz4 > /sys/block/zram0/comp_algorithm
            echo 1610612736 > /sys/block/zram0/disksize
        elif [ $MemTotal -le 4194304 ]; then
            #config 2GB+512MB zramsize with ramsize 4GB
            echo 2684354560 > /sys/block/zram0/disksize
            #enable 2 thread kswapd with ramsize 4GB
            if [ $kswapd_num != 1 ];then
                echo 2 > /proc/sys/vm/kswapd_threads
            fi
        elif [ $MemTotal -le 6291456 ]; then
            #config 3GB zramsize with ramsize 6GB
            echo 3221225472 > /sys/block/zram0/disksize
        else
            #config 4GB zramsize with ramsize >=8GB
            echo 4294967296 > /sys/block/zram0/disksize
        fi
        /vendor/bin/mkswap /dev/block/zram0
        /vendor/bin/swapon /dev/block/zram0
    fi

    if [ $MemTotal -le 6291456 ]; then
        echo 0 > /proc/sys/vm/vm_swappiness_threshold1
        echo 0 > /proc/sys/vm/swappiness_threshold1_size
        echo 0 > /proc/sys/vm/vm_swappiness_threshold2
        echo 0 > /proc/sys/vm/swappiness_threshold2_size
        echo 45 > /proc/sys/vm/watermark_scale_factor
    elif [ $MemTotal -le 8388608 ]; then
        echo 100 > /proc/sys/vm/vm_swappiness_threshold1
        echo 2000 > /proc/sys/vm/swappiness_threshold1_size
        echo 120 > /proc/sys/vm/vm_swappiness_threshold2
        echo 1500 > /proc/sys/vm/swappiness_threshold2_size
        echo 30 > /proc/sys/vm/watermark_scale_factor
    elif [ $MemTotal -le 12582912 ]; then
        echo 120 > /proc/sys/vm/vm_swappiness_threshold1
        echo 3600 > /proc/sys/vm/swappiness_threshold1_size
        echo 140 > /proc/sys/vm/vm_swappiness_threshold2
        echo 1500 > /proc/sys/vm/swappiness_threshold2_size
    fi

#endif /* OPLUS_FEATURE_ZRAM_OPT */
