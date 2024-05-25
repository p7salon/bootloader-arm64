#!/bin/bash
banirq=$(cat /proc/interrupts | grep bm168x-pcie | awk -F : '{print $1}' | awk '{print $1}')

if [ "$banirq" != "" ];then
        echo "banirq is $banirq"
        banirq_array=($banirq)

        cpuid=$(cat /etc/default/irqbalance  | grep IRQBALANCE_BANNED_CPUS= | awk -F \" '{print $2}')

        echo "pcie irq is $banirq, cpuid is $cpuid"

        echo "irqbalance args: $IRQBALANCE_ARGS"

        for i in "${banirq_array[@]}"
        do 
          sudo echo $cpuid > /proc/irq/$i/smp_affinity
          /usr/sbin/irqbalance --foreground $IRQBALANCE_ARGS --banirq=$i
        done

else
        /usr/sbin/irqbalance --foreground $IRQBALANCE_ARGS

fi
#/usr/sbin/irqbalance --debug  $IRQBALANCE_ARGS --banirq=$banirq


