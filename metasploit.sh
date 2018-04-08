#!/data/data/com.termux/files/usr/bin/bash

apt install ruby
gem install lolcat
echo "##############################################" | lolcat
echo " Auto Install Metasploit " | lolcat
echo "##############################################" | lolcat

msfvar=4.16.48
msfpath='/data/data/com.termux/files/home'
if [ -d "$msfpath/metasploit-framework" ]; then
	echo "metasploit is installed" | lolcat
	exit 1
fi

echo "Installing Metasploit............" | lolcat

echo "####################################"  | lolcat
apt update | lolcat
apt install -y autoconf bison clang coreutils curl figlet findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config postgresql-contrib wget make ruby-dev libgrpc-dev termux-tools ncurses-utils ncurses unzip zip tar postgresql termux-elf-cleaner | lolcat
apt update && apt upgrade | lolcat
echo "####################################" | lolcat
echo "Downloading & Extracting....." | lolcat

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfvar.tar.gz | lolcat
tar -xf $msfpath/$msfvar.tar.gz | lolcat
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework
cd $msfpath/metasploit-framework
sed '/rbnacl/d' -i Gemfile.lock
sed '/rbnacl/d' -i metasploit-framework.gemspec

echo "Bundler is installing" | lolcat
gem install bundler | lolcat

isNokogiri=$(gem list nokogiri -i)
isGrpc=$(gem list grpc -i)
isNetInt=$(gem list network_interface -i)

sed 's|nokogiri (1.*)|nokogiri (1.8.0)|g' -i Gemfile.lock

if [ $isNokogiri == "false" ];
then
      gem install nokogiri -v '1.8.0' -- --use-system-libraries | lolcat
else
	echo "nokogiri is already installed" | lolcat
fi

#sed 's|grpc (.*|grpc (1.4.1)|g' -i $msfpath/metasploit-framework/Gemfile.lock

#if [ $isGrpc == "false" ];
#then
#      gem unpack grpc -v '1.4.1' | lolcat
#      cd grpc-1.4.1
#      curl -LO https://raw.githubusercontent.com/grpc/grpc/v1.4.1/grpc.gemspec | lolcat
#      curl -L https://raw.githubusercontent.com/Hax4us/Hax4us.github.io/master/extconf.patch | lolcat
#      patch -p1 < extconf.patch | lolcat
#      gem build grpc.gemspec | lolcat
#      gem install grpc-1.4.1.gem | lolcat
#      cd ..
#      rm -r grpc-1.4.1
#else
#	echo "gprc is already installed" | lolcat
#fi

cd $msfpath/metasploit-framework
bundle install -j5 | lolcat

echo "Gems installed" | lolcat

$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;
rm ./modules/auxiliary/gather/http_pdf_authors.rb

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi

if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi

ln -s $msfpath/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/
ln -s $msfpath/metasploit-framework/msfvenom /data/data/com.termux/files/usr/bin/
ln -s $msfpath/metasploit-framework/msfupdate /data/data/com.termux/files/usr/bin/

termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/2.4.0/gems/pg-0.20.0/lib/pg_ext.so | lolcat

echo "Creating database" | lolcat

cd $msfpath/metasploit-framework/config
#curl -LO https://Auxilus.github.io/database.yml | lolcat
#curl -LO https://raw.githubusercontent.com/Hax4us/Metasploit_termux/master/database.yml | lolcat
curl -LO https://raw.githubusercontent.com/anorebel/Metasploit_termux/matser/database.yml | lolcat

mkdir -p $PREFIX/var/lib/postgresql
initdb $PREFIX/var/lib/postgresql | lolcat

pg_ctl -D $PREFIX/var/lib/postgresql start
createuser msf
createdb msf_database

rm $msfpath/$msfvar.tar.gz

echo "####################################" | lolcat
echo "You can directly use msfvenom or msfconsole or msfupdate" | lolcat
echo "rather than ./msfvenom or ./msfconsole or ./msfupdate" | lolcat
echo "as they are symlinked to $PREFIX/bin" | lolcat
echo "####################################" | lolcat

figlet AnoRebel | lolcat

echo "###############################################" | lolcat
echo "Script made from a combination of github.com/Hax4us, github.com/iqbalfaf and wiki.termux.com/wiki/Metasploit_Framework" | lolcat
echo "For  More. Visit  Us  At  hackeac.com" | lolcat
echo "###############################" | lolcat

