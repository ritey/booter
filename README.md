# booter
Bootscript for setting up a new box

Simply run
wget -qO- https://raw.githubusercontent.com/ritey/booter/master/booter.sh | bash

Argument options include:

1. SITENAME="website"
2. DOMAIN="website"
3. PASSWORD='123456789!'

For example:

wget -qO- https://raw.githubusercontent.com/ritey/booter/master/booter.sh | SITENAME=GitHub DOMAIN=github.com PASSWORD=password123 bash