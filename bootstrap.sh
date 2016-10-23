#! /bin/sh
host="$1"
ssh "$host" 'ASSUME_ALWAYS_YES=yes sudo pkg install -y python'
