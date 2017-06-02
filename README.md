# Sample App To Reproduce realm/realm-cocoa#4992

An attempt to reproduce the issue reported in
https://github.com/realm/realm-cocoa/issues/4992.

## Instructions

1. Install project dependencies: `pod install`
2. Get your local IP address: `./get_ip.sh`
3. In `GH4492/AppDelegate.swift`, replace `let ip = "000.00.00.000"` with the IP
   you got from the first step.
4. Start Realm Object Server: `./run_server.sh`
5. Open `GH4992.xcworkspace` with Xcode 8.3.2: `open GH4992.xcworkspace`
6. Build & run on a physically attached iOS device on the same local network as your Mac.

## What Happens

Rather than reproducing the issue reported in
https://github.com/realm/realm-cocoa/issues/4992, everything runs as designed,
the `asyncOpen` callback is invoked.

The following is logged on the iOS device:

```
Realm.Configuration {
  fileURL = (null);
  inMemoryIdentifier = (null);
  encryptionKey = (null);
  readOnly = 0;
  schemaVersion = 0;
  migrationBlock = (null);
  deleteRealmIfMigrationNeeded = 0;
  shouldCompactOnLaunch = (null);
  dynamic = 0;
  customSchema = (null);
}
Opening sync Realm
2017-06-02 11:56:27.675365-0700 GH4992[7103:1956912] Sync: Opening Realm file: /var/mobile/Containers/Data/Application/33049E4F-5023-450B-98BD-3422DDFDC856/Documents/realm-object-server/2a8502c30edf249e7dc5da9298660976/realm%3A%2F%2F172.20.20.181%3A9080%2F%7E%2Fdefault
2017-06-02 11:56:27.938478-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Starting session for '/var/mobile/Containers/Data/Application/33049E4F-5023-450B-98BD-3422DDFDC856/Documents/realm-object-server/2a8502c30edf249e7dc5da9298660976/realm%3A%2F%2F172.20.20.181%3A9080%2F%7E%2Fdefault'
2017-06-02 11:56:27.939093-0700 GH4992[7103:1956912] Sync: Connection[1]: Resolving '172.20.20.181:9080'
2017-06-02 11:56:27.945218-0700 GH4992[7103:1956912] Sync: Connection[1]: Connecting to endpoint '172.20.20.181:9080' (1/1)
2017-06-02 11:56:27.953393-0700 GH4992[7103:1956912] Sync: Connection[1]: Connected to endpoint '172.20.20.181:9080' (from '172.20.20.230:64546')
2017-06-02 11:56:27.967872-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Sending: BIND(server_path='/2a8502c30edf249e7dc5da9298660976/default', signed_user_token_size=649, need_file_ident_pair=1)
2017-06-02 11:56:27.992499-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Received: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5341496911090170003)
2017-06-02 11:56:28.017085-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5341496911090170003, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02 11:56:28.019762-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Sending: MARK(request_ident=1)
2017-06-02 11:56:28.032849-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Received: MARK(request_ident=1)
   ... opened.
didComplete: true
Configuration: Realm.Configuration {
  fileURL = (null);
  inMemoryIdentifier = (null);
  encryptionKey = (null);
  readOnly = 0;
  schemaVersion = 0;
  migrationBlock = (null);
  deleteRealmIfMigrationNeeded = 0;
  shouldCompactOnLaunch = (null);
  dynamic = 0;
  customSchema = (null);
}
Schema: 0
2017-06-02 11:56:28.329581-0700 GH4992[7103:1956912] Sync: Closing Realm file: /var/mobile/Containers/Data/Application/33049E4F-5023-450B-98BD-3422DDFDC856/Documents/realm-object-server/2a8502c30edf249e7dc5da9298660976/realm%3A%2F%2F172.20.20.181%3A9080%2F%7E%2Fdefault
2017-06-02 11:56:28.331819-0700 GH4992[7103:1956912] Sync: Connection[1]: Session[1]: Sending: UNBIND
```

The following is logged from the server:

```
Creating new public and private keypair
Generating Realm Sync Admin Credentials
2017-06-02T12:07:16-0700 [DEBUG] Enabling verbose mode.
2017-06-02T12:07:16-0700 [DEBUG] Using private key at `/Users/jp/Desktop/GH4992/sync/object-server/keys/token-signature.key'.
2017-06-02T12:07:16-0700 [DEBUG] Storing output to `/Users/jp/Desktop/GH4992/sync/admin_token.base64'.
2017-06-02T12:07:16-0700 [DEBUG] Generating token.
2017-06-02T12:07:16-0700 [DEBUG] Writing token to `/Users/jp/Desktop/GH4992/sync/admin_token.base64'.

Your admin access token is: ewoJImlkZW50aXR5IjogIl9fYXV0aCIsCgkiYWNjZXNzIjogWyJ1cGxvYWQiLCAiZG93bmxvYWQiLCAibWFuYWdlIl0KfQo=:mcvLVYiIBsQsy3M9PauaD5QZRb+ALt89uNdX2luRihLMcrMUHWII+AJAF9AOzNhvW+Omok76k8u7Q/AIYQLjyGtWrz69CdYPGS4eeZMO9J9A0uzU39Dk4fz47e12l7NFdwkv4dvyp3Dt2nsFXhRBuSNQcBrD9vDLEnepc5OxDQPeJuX6dPsM8tz95AHAqAC3J93z8Fj3sP/zPTiROVqRT/ggQLy9ENthFsJRwiPd0X2rdYsPVvnpqKKS/9LVcddiUECRH/+V6XjT5dMBjK3s3Y581CxDCnjRF/4pt6A9+NWPQBm08jS5EskoYGacsssDw//LLIyKzsuplVEB9ku52w==
Creating server root directory
Creating server temp directory
Deleting files from the previous version
~/Desktop/GH4992/sync/object-server ~/Desktop/GH4992
~/Desktop/GH4992
2017-06-02T19:07:17.703Z - info: Logging to console at level 'info'.
2017-06-02T19:07:17.726Z - info: Backup admin-Realm file written to /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/oldAuth.realm.bak (in case of unexpected failures during the upgrade).
2017-06-02T19:07:17.859Z - info: Realm Object Server sync engine listening on 127.0.0.1:27800.
2017-06-02T19:07:17.897Z - info: permission: Seed permission-Realms
2017-06-02T19:07:17.947Z - info: Realm Object Server web server listening on 127.0.0.1:27080.
2017-06-02T19:07:17.950Z - info: http proxy listening on :::9080.
2017-06-02T19:07:17.952Z - info: The Realm Object Server requires an initial admin user to start. To continue, please open your web browser to access the dashboard at: http://127.0.0.1:27080 and register your user.
2017-06-02T19:07:17.958Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/auth.realm
2017-06-02T19:07:17.958Z - info: client: Connection[1]: Session[1]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/auth.realm'
2017-06-02T19:07:17.959Z - info: client: Connection[1]: Resolving ':::9080'
2017-06-02T19:07:17.959Z - info: client: Connection[1]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:17.959Z - error: client: Connection[1]: Failed to connect to endpoint ':::9080': Connection refused
2017-06-02T19:07:17.959Z - error: client: Connection[1]: Failed to connect to ':::9080': All endpoints failed
2017-06-02T19:07:17.959Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/realm-object-server/listener/__admin.realm
2017-06-02T19:07:17.959Z - info: client: Connection[2]: Session[2]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/realm-object-server/listener/__admin.realm'
2017-06-02T19:07:17.960Z - info: client: Connection[2]: Resolving ':::9080'
2017-06-02T19:07:17.960Z - info: client: Connection[2]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:17.960Z - error: client: Connection[2]: Failed to connect to endpoint ':::9080': Connection refused
2017-06-02T19:07:17.960Z - error: client: Connection[2]: Failed to connect to ':::9080': All endpoints failed
2017-06-02T19:07:17.960Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm
2017-06-02T19:07:17.961Z - info: client: Connection[3]: Session[3]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm'
2017-06-02T19:07:17.961Z - info: client: Connection[3]: Resolving ':::9080'
2017-06-02T19:07:17.961Z - info: client: Connection[3]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:17.961Z - error: client: Connection[3]: Failed to connect to endpoint ':::9080': Connection refused
2017-06-02T19:07:17.961Z - error: client: Connection[3]: Failed to connect to ':::9080': All endpoints failed
2017-06-02T19:07:17.961Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__global.realm
2017-06-02T19:07:17.962Z - info: client: Connection[4]: Session[4]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__global.realm'
2017-06-02T19:07:17.962Z - info: client: Connection[4]: Resolving ':::9080'
2017-06-02T19:07:17.962Z - info: client: Connection[4]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:17.962Z - error: client: Connection[4]: Failed to connect to endpoint ':::9080': Connection refused
2017-06-02T19:07:17.962Z - error: client: Connection[4]: Failed to connect to ':::9080': All endpoints failed
2017-06-02T19:07:17.963Z - info: sync-server: Realm sync server started ([realm-core-2.8.1], [realm-sync-1.9.2])
2017-06-02T19:07:17.963Z - info: sync-server: Directory holding persistent state: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/0/user_data
2017-06-02T19:07:17.963Z - info: sync-server: Listening on 127.0.0.1:27800 (sync protocol version 18)
2017-06-02T19:07:18.655Z - info: client: Connection[1]: Resolving ':::9080'
2017-06-02T19:07:18.656Z - info: client: Connection[1]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.656Z - info: client: Connection[1]: Connected to endpoint ':::9080' (from '::1:61943')
2017-06-02T19:07:18.678Z - info: sync-server: HTTP Connection[1]: Connection from 127.0.0.1:61944
2017-06-02T19:07:18.679Z - info: sync-server: HTTP Connection[1]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:18.682Z - info: client: Connection[1]: Session[1]: Sending: BIND(server_path='/__admin', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:18.682Z - info: sync-server: Sync Connection[1]: Session[1]: Session initiated (session_ident=1).
2017-06-02T19:07:18.682Z - info: sync-server: Sync Connection[1]: Session[1]: Received: BIND(server_path=/__admin, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:18.702Z - info: sync-server: Sync Connection[1]: Session[1]: Sending: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5631957365538786780)
2017-06-02T19:07:18.703Z - info: client: Connection[1]: Session[1]: Received: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5631957365538786780)
2017-06-02T19:07:18.704Z - info: client: Connection[1]: Session[1]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5631957365538786780, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.704Z - info: sync-server: Sync Connection[1]: Session[1]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=5631957365538786780, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.736Z - info: client: Connection[4]: Resolving ':::9080'
2017-06-02T19:07:18.737Z - info: client: Connection[4]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.737Z - info: client: Connection[4]: Connected to endpoint ':::9080' (from '::1:61945')
2017-06-02T19:07:18.746Z - info: sync-server: HTTP Connection[2]: Connection from 127.0.0.1:61946
2017-06-02T19:07:18.746Z - info: sync-server: HTTP Connection[2]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:18.747Z - info: client: Connection[4]: Session[4]: Sending: BIND(server_path='/__permission', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:18.748Z - info: sync-server: Sync Connection[2]: Session[4]: Session initiated (session_ident=4).
2017-06-02T19:07:18.748Z - info: sync-server: Sync Connection[2]: Session[4]: Received: BIND(server_path=/__permission, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:18.771Z - info: sync-server: Sync Connection[2]: Session[4]: Sending: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7844056935836196302)
2017-06-02T19:07:18.773Z - info: client: Connection[4]: Session[4]: Received: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7844056935836196302)
2017-06-02T19:07:18.773Z - info: client: Connection[4]: Session[4]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7844056935836196302, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.775Z - info: sync-server: Sync Connection[2]: Session[4]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7844056935836196302, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.810Z - info: client: Connection[3]: Resolving ':::9080'
2017-06-02T19:07:18.811Z - info: client: Connection[3]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.811Z - info: client: Connection[3]: Connected to endpoint ':::9080' (from '::1:61947')
2017-06-02T19:07:18.818Z - info: sync-server: HTTP Connection[3]: Connection from 127.0.0.1:61948
2017-06-02T19:07:18.830Z - info: sync-server: HTTP Connection[3]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:18.843Z - info: client: Connection[3]: Session[3]: Sending: BIND(server_path='/__auth/__permission', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:18.844Z - info: sync-server: Sync Connection[3]: Session[3]: Session initiated (session_ident=3).
2017-06-02T19:07:18.844Z - info: sync-server: Sync Connection[3]: Session[3]: Received: BIND(server_path=/__auth/__permission, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:18.870Z - info: sync-server: Sync Connection[3]: Session[3]: Sending: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852)
2017-06-02T19:07:18.871Z - info: client: Connection[3]: Session[3]: Received: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852)
2017-06-02T19:07:18.872Z - info: client: Connection[3]: Session[3]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.873Z - info: client: Connection[2]: Resolving ':::9080'
2017-06-02T19:07:18.873Z - info: client: Connection[2]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.873Z - info: client: Connection[2]: Connected to endpoint ':::9080' (from '::1:61949')
2017-06-02T19:07:18.877Z - info: sync-server: Sync Connection[3]: Session[3]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.889Z - info: sync-server: HTTP Connection[4]: Connection from 127.0.0.1:61950
2017-06-02T19:07:18.890Z - info: sync-server: HTTP Connection[4]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:18.903Z - info: client: Connection[2]: Session[2]: Sending: BIND(server_path='/__admin', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:18.903Z - info: sync-server: Sync Connection[4]: Session[2]: Session initiated (session_ident=2).
2017-06-02T19:07:18.904Z - info: sync-server: Sync Connection[4]: Session[2]: Received: BIND(server_path=/__admin, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:18.906Z - info: sync-server: Sync Connection[4]: Session[2]: Sending: ALLOC(server_file_ident=1, client_file_ident=3, client_file_ident_secret=5913936914729739272)
2017-06-02T19:07:18.907Z - info: client: Connection[2]: Session[2]: Received: ALLOC(server_file_ident=1, client_file_ident=3, client_file_ident_secret=5913936914729739272)
2017-06-02T19:07:18.908Z - info: client: Connection[2]: Session[2]: Sending: IDENT(server_file_ident=1, client_file_ident=3, client_file_ident_secret=5913936914729739272, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.909Z - info: sync-server: Sync Connection[4]: Session[2]: Received: IDENT(server_file_ident=1, client_file_ident=3, client_file_ident_secret=5913936914729739272, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.939Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/realm-object-server/listener/realms/__admin.realm
2017-06-02T19:07:18.940Z - info: client: Connection[5]: Session[5]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/realm-object-server/listener/realms/__admin.realm'
2017-06-02T19:07:18.940Z - info: client: Connection[5]: Resolving ':::9080'
2017-06-02T19:07:18.941Z - info: client: Connection[5]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.941Z - info: client: Connection[5]: Connected to endpoint ':::9080' (from '::1:61951')
2017-06-02T19:07:18.944Z - info: sync-server: HTTP Connection[5]: Connection from 127.0.0.1:61952
2017-06-02T19:07:18.944Z - info: sync-server: HTTP Connection[5]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:18.945Z - info: client: Connection[5]: Session[5]: Sending: BIND(server_path='/__admin', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:18.946Z - info: sync-server: Sync Connection[5]: Session[5]: Session initiated (session_ident=5).
2017-06-02T19:07:18.946Z - info: sync-server: Sync Connection[5]: Session[5]: Received: BIND(server_path=/__admin, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:18.949Z - info: sync-server: Sync Connection[5]: Session[5]: Sending: ALLOC(server_file_ident=1, client_file_ident=4, client_file_ident_secret=3851341222285970021)
2017-06-02T19:07:18.950Z - info: client: Connection[5]: Session[5]: Received: ALLOC(server_file_ident=1, client_file_ident=4, client_file_ident_secret=3851341222285970021)
2017-06-02T19:07:18.959Z - info: client: Connection[5]: Session[5]: Sending: IDENT(server_file_ident=1, client_file_ident=4, client_file_ident_secret=3851341222285970021, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.960Z - info: sync-server: Sync Connection[5]: Session[5]: Received: IDENT(server_file_ident=1, client_file_ident=4, client_file_ident_secret=3851341222285970021, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:18.998Z - info: client: Closing Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm
2017-06-02T19:07:18.998Z - info: client: Connection[3]: Session[3]: Sending: UNBIND
2017-06-02T19:07:18.998Z - info: client: Closing Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__global.realm
2017-06-02T19:07:18.998Z - info: client: Connection[4]: Session[4]: Sending: UNBIND
2017-06-02T19:07:18.999Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm
2017-06-02T19:07:18.999Z - info: client: Connection[6]: Session[6]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm'
2017-06-02T19:07:18.999Z - info: client: Connection[6]: Resolving ':::9080'
2017-06-02T19:07:18.999Z - info: client: Connection[6]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:18.999Z - info: client: Connection[6]: Connected to endpoint ':::9080' (from '::1:61953')
2017-06-02T19:07:19.002Z - info: sync-server: Sync Connection[3]: Session[3]: Session terminated (session_ident=3).
2017-06-02T19:07:19.002Z - info: sync-server: Sync Connection[3]: Connection closed by client: End of input
2017-06-02T19:07:19.002Z - info: sync-server: Sync Connection[2]: Session[4]: Session terminated (session_ident=4).
2017-06-02T19:07:19.003Z - info: sync-server: Sync Connection[2]: Connection closed by client: End of input
2017-06-02T19:07:19.003Z - info: sync-server: HTTP Connection[6]: Connection from 127.0.0.1:61954
2017-06-02T19:07:19.004Z - info: sync-server: HTTP Connection[6]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:19.005Z - info: client: Connection[6]: Session[6]: Sending: BIND(server_path='/__auth/__permission', signed_user_token_size=469, need_file_ident_pair=0)
2017-06-02T19:07:19.006Z - info: client: Connection[6]: Session[6]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852, scan_server_version=3, scan_client_version=7, latest_server_version=3, latest_server_session_ident=714599703130390728)
2017-06-02T19:07:19.006Z - info: sync-server: Sync Connection[6]: Session[6]: Session initiated (session_ident=6).
2017-06-02T19:07:19.007Z - info: sync-server: Sync Connection[6]: Session[6]: Received: BIND(server_path=/__auth/__permission, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=0)
2017-06-02T19:07:19.008Z - info: sync-server: Sync Connection[6]: Session[6]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=7051985328851513852, scan_server_version=3, scan_client_version=7, latest_server_version=3, latest_server_session_ident=714599703130390728)
2017-06-02T19:07:19.011Z - info: client: Closing Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/__auth.realm
2017-06-02T19:07:19.011Z - info: client: Connection[6]: Session[6]: Sending: UNBIND
2017-06-02T19:07:19.012Z - info: sync-server: Sync Connection[6]: Session[6]: Session terminated (session_ident=6).
2017-06-02T19:07:19.012Z - info: sync-server: Sync Connection[6]: Connection closed by client: End of input
2017-06-02T19:07:34.028Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm
2017-06-02T19:07:34.028Z - info: client: Connection[7]: Session[7]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm'
2017-06-02T19:07:34.028Z - info: client: Connection[7]: Resolving ':::9080'
2017-06-02T19:07:34.028Z - info: client: Connection[7]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:34.028Z - info: client: Connection[7]: Connected to endpoint ':::9080' (from '::1:61960')
2017-06-02T19:07:34.042Z - info: sync-server: HTTP Connection[7]: Connection from 127.0.0.1:61961
2017-06-02T19:07:34.043Z - info: sync-server: HTTP Connection[7]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:34.045Z - info: client: Connection[7]: Session[7]: Sending: BIND(server_path='/bad6fb2fa19938f54f0fc84e9e886d6c/__permission', signed_user_token_size=469, need_file_ident_pair=1)
2017-06-02T19:07:34.046Z - info: sync-server: Sync Connection[7]: Session[7]: Session initiated (session_ident=7).
2017-06-02T19:07:34.046Z - info: sync-server: Sync Connection[7]: Session[7]: Received: BIND(server_path=/bad6fb2fa19938f54f0fc84e9e886d6c/__permission, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=1)
2017-06-02T19:07:34.068Z - info: sync-server: Sync Connection[7]: Session[7]: Sending: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317)
2017-06-02T19:07:34.069Z - info: client: Connection[7]: Session[7]: Received: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317)
2017-06-02T19:07:34.081Z - info: client: Connection[7]: Session[7]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:34.081Z - info: sync-server: Sync Connection[7]: Session[7]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:34.094Z - info: client: Closing Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm
2017-06-02T19:07:34.096Z - info: client: Connection[7]: Session[7]: Sending: UNBIND
2017-06-02T19:07:34.096Z - info: sync-server: Sync Connection[7]: Session[7]: Session terminated (session_ident=7).
2017-06-02T19:07:34.096Z - info: sync-server: Sync Connection[7]: Connection closed by client: End of input
2017-06-02T19:07:34.472Z - info: client: Opening Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm
2017-06-02T19:07:34.473Z - info: client: Connection[8]: Session[8]: Starting session for '/Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm'
2017-06-02T19:07:34.473Z - info: client: Connection[8]: Resolving ':::9080'
2017-06-02T19:07:34.473Z - info: client: Connection[8]: Connecting to endpoint ':::9080' (1/1)
2017-06-02T19:07:34.474Z - info: client: Connection[8]: Connected to endpoint ':::9080' (from '::1:61963')
2017-06-02T19:07:34.476Z - info: sync-server: HTTP Connection[8]: Connection from 127.0.0.1:61964
2017-06-02T19:07:34.476Z - info: sync-server: HTTP Connection[8]: Received: Sync HTTP request(protocol_version=18)
2017-06-02T19:07:34.480Z - info: client: Connection[8]: Session[8]: Sending: BIND(server_path='/bad6fb2fa19938f54f0fc84e9e886d6c/__permission', signed_user_token_size=469, need_file_ident_pair=0)
2017-06-02T19:07:34.481Z - info: client: Connection[8]: Session[8]: Sending: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317, scan_server_version=2, scan_client_version=3, latest_server_version=2, latest_server_session_ident=7281633837207960329)
2017-06-02T19:07:34.481Z - info: sync-server: HTTP Connection[9]: Connection from 127.0.0.1:61965
2017-06-02T19:07:34.481Z - info: sync-server: Sync Connection[8]: Session[8]: Session initiated (session_ident=8).
2017-06-02T19:07:34.481Z - info: sync-server: Sync Connection[8]: Session[8]: Received: BIND(server_path=/bad6fb2fa19938f54f0fc84e9e886d6c/__permission, signed_user_token='...W+y3OBSs73kyQuv9KkAer4jG5mhw==', need_file_ident_pair=0)
2017-06-02T19:07:34.483Z - info: sync-server: Sync Connection[8]: Session[8]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=6374416860889428317, scan_server_version=2, scan_client_version=3, latest_server_version=2, latest_server_session_ident=7281633837207960329)
2017-06-02T19:07:34.484Z - info: sync-server: HTTP Connection[9]: Received: Sync HTTP request(protocol_version=17)
2017-06-02T19:07:34.485Z - info: client: Closing Realm file: /Users/jp/Desktop/GH4992/sync/object-server/root_dir/internal_data/permission/bad6fb2fa19938f54f0fc84e9e886d6c.realm
2017-06-02T19:07:34.486Z - info: client: Connection[8]: Session[8]: Sending: UNBIND
2017-06-02T19:07:34.486Z - info: sync-server: Sync Connection[8]: Session[8]: Session terminated (session_ident=8).
2017-06-02T19:07:34.487Z - info: sync-server: Sync Connection[8]: Connection closed by client: End of input
2017-06-02T19:07:34.490Z - info: sync-server: Sync Connection[9]: Session[1]: Session initiated (session_ident=1).
2017-06-02T19:07:34.490Z - info: sync-server: Sync Connection[9]: Session[1]: Received: BIND(server_path=/bad6fb2fa19938f54f0fc84e9e886d6c/default, signed_user_token='...Hl3ZxqmSRnvLCJ6ZCFu4/GBzpJ4A==', need_file_ident_pair=1)
2017-06-02T19:07:34.513Z - info: sync-server: Sync Connection[9]: Session[1]: Sending: ALLOC(server_file_ident=1, client_file_ident=2, client_file_ident_secret=1935081678835215265)
2017-06-02T19:07:34.740Z - info: sync-server: Sync Connection[9]: Session[1]: Received: IDENT(server_file_ident=1, client_file_ident=2, client_file_ident_secret=1935081678835215265, scan_server_version=0, scan_client_version=0, latest_server_version=0, latest_server_session_ident=0)
2017-06-02T19:07:34.743Z - info: sync-server: Sync Connection[9]: Session[1]: Received: MARK(request_ident=1)
2017-06-02T19:07:34.743Z - info: sync-server: Sync Connection[9]: Session[1]: Sending: MARK(request_ident=1)
2017-06-02T19:07:34.959Z - info: sync-server: Sync Connection[9]: Session[1]: Session terminated (session_ident=1).
2017-06-02T19:07:34.959Z - info: sync-server: Sync Connection[9]: Connection closed by client: End of input
```
