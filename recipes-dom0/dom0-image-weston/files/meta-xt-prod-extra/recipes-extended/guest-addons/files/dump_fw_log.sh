while true; do
      echo "----------------------"
#      cat /sys/kernel/debug/pvr/firmware_trace | grep "OSid = 1";
      cat /sys/kernel/debug/pvr/firmware_trace | grep OSid
done
