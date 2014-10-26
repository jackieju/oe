
#!/bin/sh
script/server -p 4000 &
ruby script/ferret_server --root ./ -e development start &

