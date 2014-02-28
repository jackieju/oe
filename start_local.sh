
#!/bin/sh
script/server &
ruby script/ferret_server --root ./ -e development start &

