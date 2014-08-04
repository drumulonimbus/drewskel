#!/bin/bash
# script to deploy all the things

# where are we running this from?
SCRIPTHOME=`pwd -P`
echo "Running this script in $SCRIPTHOME."

# check if $HOME is set, bail if not:
if [ -z "$HOME" ]; then
	echo "The $HOME environment variable is not set, exiting..."
	exit 1
else
	echo "Installing stuff to $HOME, backing up older versions to <filename>.OLD"
	echo "-----"
fi

# bash profile
echo "Setting up $HOME/.bash_profile:"
if [ -e "$HOME/.bash_profile" ]; then

fi

# ssh setup

echo "Setting up ssh keys and config:"

if [ -d "$HOME/.ssh" ]; then
	echo " - $HOME/.ssh found."

	# are the perms correct?
	SSH_DIR_PERMS=$(stat -f %p $HOME/.ssh | cut -b 3-5)
	if [ "$SSH_DIR_PERMS" != "700" ]; then
		echo " - $HOME/.ssh permissions are not 700! Fix your shit! Exiting..."
		exit 1
	else
		echo " - $HOME/.ssh permissions are correct"
	fi

	# back up authorized_keys
	if [ -e "$HOME/.ssh/authorized_keys" ]; then
		echo -n " - authorized keys found, backing up to $HOME/.ssh/authorized_keys.OLD: "
		mv $HOME/.ssh/authorized_keys $HOME/.ssh/authorized_keys.OLD
		echo "Complete."
	fi

	# same for .ssh/config
	if [ -e "$HOME/.ssh/config" ]; then 
		echo -n " - ssh config found, backing up to $HOME/.ssh/config.OLD: "
		mv $HOME/.ssh/config $HOME/.ssh/config.OLD
		echo "Complete."
	fi

# if the dir doesn't exist, build it:
else
	echo -n " - $HOME/.ssh not found! Creating: "
	mkdir $HOME/.ssh
	echo "Complete.""
	echo -n " - setting permissions on $HOME/.ssh: "
	chmod 700
	echo "Complete.""
fi

# put the new files in place:
echo -n " - installing new authorized_keys file to $HOME/.ssh/authorized_keys: "
cp $SCRIPTHOME/.ssh/authorized_keys $HOME/.ssh/authorized_keys
echo "Complete."
echo -n " - setting permissions on authorize_keys file to 600: "
chmod 600 $HOME/.ssh/authorized_keys
echo "Complete."

echo -n " - installing new ssh config file to $HOME/.ssh/config: "
cp $SCRIPTHOME/.ssh/config $HOME/.ssh/config
echo "Complete."
echo " - setting permissions on config file to 600: "
chmod 600 $HOME/.ssh/config
echo "Complete."







