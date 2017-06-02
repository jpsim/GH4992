#!/bin/sh

archive_name="realm-object-server-bundled_node_darwin-developer-1.7.4.tar.gz"
curl -L -O "https://static.realm.io/downloads/object-server/$archive_name"
rm -rf sync
mkdir sync
tar xf $archive_name -C sync
rm $archive_name
touch "sync/object-server/do_not_open_browser"
./sync/start-object-server.command
