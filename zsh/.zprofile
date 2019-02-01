if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  echo "Startx with nvidia? [Y/n]"
  read -q input

  case $input in
    [yY][eE][sS]|[yY])
	nvidia-xrun
	;;

    [nN][oO]|[nN])
        MODULES_UNLOAD=(nvidia_drm nvidia_modeset nvidia_uvm nvidia)
	BUS_ID=0000:00:01.0
        for module in "${MODULES_UNLOAD[@]}"
        do
   	echo "Unloading module ${module}"
	sudo modprobe -r ${module}
        done
        if [[ -f /sys/bus/pci/devices/${BUS_ID}/remove ]]; then
  	echo 'Removing Nvidia bus from the kernel'
 	sudo tee /sys/bus/pci/devices/${BUS_ID}/remove <<<1
        else
	echo 'Enabling powersave for the PCIe controller'
	sudo tee /sys/bus/pci/devices/${BUS_ID}/power/control <<<auto
        fi
        startx
       	;;

    *)
    echo "Invalid input..."
#    exit 1
    ;;
  esac
fi
