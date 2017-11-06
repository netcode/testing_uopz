phpv=$(php -v | grep -m 1 PHP | cut -s -d" " -f2 | cut -d"." -f1,2)
PHPDevPackage='php-dev'

if [ $phpv = '7.0' ] 
then
	PHPDevPackage='php7.0-dev'
fi

if [ $phpv = '7.1' ] 
then
	PHPDevPackage='php7.1-dev'
fi

sudo apt-get install -y $PHPDevPackage
sudo pecl install uopz


PHPConfDir="/etc/php/$phpv/mods-available"
PHPCliConfDir="/etc/php/$phpv/cli/conf.d"

if [ $phpv = '' ]
then
	PHPConfDir="/etc/php/mods-available"
	PHPCliConfDir="/etc/php/cli/conf.d"
fi

if [ -d $PHPConfDir ]; then
	echo "$PHPConfDir Exists"
fi

if [ -d $PHPCliConfDir ]; then
	echo "$PHPCliConfDir Exists"
fi

# add configurations

cat > $PHPConfDir/uopz.ini <<EOF
	; configuration for php uopz module
	; priority=5
	extension=uopz.so
EOF

cat > $PHPCliConfDir/uopz.ini <<EOF
	; configuration for php uopz module
	; priority=5
	extension=uopz.so
EOF

# Test if Apache or Nginx is installed
nginx -v > /dev/null 2>&1
NGINX_IS_INSTALLED=$?

apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?


PHPFPM=$(service --status-all | grep -o 'php.*')
if [[ $PHPFPM ]]; then
	echo ">>> Restaring PHP fpm "
	service $PHPFPM restart
else
	echo '>>>  PHP fpm not exists restarting the webserver instead'
	if [[ $NGINX_IS_INSTALLED ]]; then
		echo ">>> Restaring Nginx "
		service nginx restart
	fi
	if [[ $APACHE_IS_INSTALLED ]]; then
		echo ">>> Restaring Apache "
		service apache2 restart
	fi
	
fi