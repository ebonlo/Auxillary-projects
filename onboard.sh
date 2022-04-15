# This script will read a csv file that contains 20 new Linux users
# This script will create each user on he server and add to an existing group called 'Developers'
# This script will first check for the existence of the user on the system, before it will attempt to create the user
# The user that is being created must have a default home folder
# Each user should have a .ssh folder within its home folder. If it does not exist then it will be created
# For each user's SSH configuration, we will create an authorized_keys file and add the required public key.


#!/bin/bash
userfile=$(cat names.cvs)
PASSWORD=PASSWORD

if [ $(id -u) -eq 0];
then
    for user in $userfile;
    do
        echo $user
# Checking if user exist
    if id "$user" &>dev/null
    then
        echo "user Exist"
    else
# adding user to developers group if user does not exist
        useradd -m -d /home/$user -s /bin/bash -g developers $user
        echo "New User created"
        echo

# creating an ssh folder in user home directory
        su - -c "mkdir ~/.ssh" $user
        echo ".ssh directory created for new user"
        echo
# changing permission for the .ssh folder such that only user has permission
        su - -c "chmod 600 ~/.ssh" $user
# creating authorized key file for each user and changing the file's permission

        su - -c "touch ~/.ssh/authorized_keys" $user
        echo "Authorized key File Created"
        echo

        su - -c "chmod 600 ~/.ssh/authorized_keys" $user
        echo "user permission for authorized key file set"
        echo

# copying the required public key into the authorized key file

        cp -R "/root/onboard/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
        echo "copied the public key to new user account on server"
        echo
        echo

        echo "USER CREATED"
# generating password for users
sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$USER"
sudo passwd -x 5 $USER
    fi
    done
else
    echo "Onlo Admin can board new users"
fi