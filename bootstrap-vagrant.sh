#! /bin/sh
echo "--- Creating user $REMOTE_USER"
pw user add "$REMOTE_USER" -m

echo "--- Adding user $REMOTE_USER to sudoers"
echo -e "\n$REMOTE_USER ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

echo "--- Copying public key $(echo "$PUBLIC_KEY" | awk '{ print $3 }') for $REMOTE_USER"
mkdir -p "/home/$REMOTE_USER/.ssh"
echo "$PUBLIC_KEY" > "/home/$REMOTE_USER/.ssh/authorized_keys"
chown -R "$REMOTE_USER:$REMOTE_USER" "/home/$REMOTE_USER/.ssh"
chmod 0600 "/home/$REMOTE_USER/.ssh/authorized_keys"
chmod 0700 "/home/$REMOTE_USER/.ssh"

echo "--- Installing Python"
ASSUME_ALWAYS_YES=yes pkg install -y python
