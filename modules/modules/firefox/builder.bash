export PATH=$sqlite/bin:$coreutils/bin
tmp=$(mktemp -d)
db="$tmp/storage-sync-v2.sqlite"
echo $data > $tmp/data.json
# touch $db
sqlite3 $db "CREATE TABLE storage_sync_data(data TEXT NOT NULL PRIMARY KEY, ext_id TEXT, sync_change_counter INTEGER NOT NULL DEFAULT 1); INSERT INTO storage_sync_data SELECT json_extract(value, '\$.data'), json_extract(value, '\$.ext_id'), json_extract(value, '\$.sync_change_counter') FROM json_each(readfile('$tmp/data.json'));"
mkdir $out
cp $tmp/data.json $out
cp $db $out
