#!/bin/sh -e

# mod is assumed to be path to module
get_dependencies() {
	local mod="$1"

	strings "$mod" | grep 'depends=' | cut -f 2 -d '=' | tr ',' ' '
}

# magically do the right stuff
load_module() {
	local mod="$1"

	if lsmod | grep "$mod" >/dev/null; then
		echo "Module $mod already loaded"
	elif modprobe "$mod" >/dev/null 2>&1; then
		echo "Module $mod loaded via modprobe"
	elif [ -f "${mod_dir}/${mod}.ko" ]; then
		for dep in $(get_dependencies "${mod_dir}/${mod}.ko"); do
			echo "Loading dependency ${dep} for ${mod}"
			load_module "${dep}"
		done
		echo "Loading module ${mod}"
		insmod "${mod_dir}/${mod}.ko" || (
			echo "Insmod $mod failed!"
			exit 1
		)
	else
		echo "Failed to find module $mod"
	fi
}

OS_VERSION=$(echo "$BALENA_HOST_OS_VERSION" | cut -d " " -f 2)
echo "OS Version is $OS_VERSION"

if [ -z "$1" ]; then
	echo "Module directory required"
	exit 1
fi

mod_list="macsec"
mod_dir="$1/${BALENA_DEVICE_TYPE}/${OS_VERSION}"

if [ -d "$mod_dir" ]; then
	# As we are using insmod and not modprobe the module list must be in the correct
	# order so dependencies are loaded first

	for mod in $mod_list; do
		load_module "${mod}"
		echo
	done
else
	echo "No kernel modules found for Device: $BALENA_DEVICE_TYPE and Version: $OS_VERSION"
fi

# Mark that we are done
touch /tmp/service_done
sleep infinity
