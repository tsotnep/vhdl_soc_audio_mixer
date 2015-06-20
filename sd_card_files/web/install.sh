apt-get update
apt-get install apache2
apt-get install python-scipy
apt-get install libapache2-mod-python
cp -r /mnt/web/www/ /var/
cp /mnt/web/000-default.conf /etc/apache2/sites-available/
cp /mnt/web/apache2.conf /etc/apache2/
service apache2 restart
