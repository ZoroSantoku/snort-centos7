#!/bin/bash
echo "******************cài các packages hỗ trợ******************"
sudo yum install gcc flex bison zlib libpcap pcre libdnet tcpdump -y

sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y

sudo yum install libnghttp2 -y

sudo yum install -y zlib-devel libpcap-devel pcre-devel libdnet-devel openssl-devel libnghttp2-devel luajit-devel
echo "******************tạo thư mục******************"
mkdir ~/snort_src 

cd ~/snort_src
echo "******************dowload và cài đặt Snort DAQ (Data AcQuisition library)******************"
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz

tar -xvzf daq-2.0.6.tar.gz

cd daq-2.0.6

./configure && make && sudo make install

cd ~/snort_src
echo "******************dowload và cài snort.******************"
wget https://www.snort.org/downloads/snort/snort-2.9.13.tar.gz

tar -xvzf snort-2.9.13.tar.gz

cd snort-2.9.13

./configure --enable-sourcefire && make && sudo make install
echo "******************tạo các liên kết******************"
sudo ldconfig

sudo ln -s /usr/local/bin/snort /usr/sbin/snort
echo "******************tạo user group, thêm quyền cho thư mục******************"
sudo groupadd snort 

sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
echo "******************tạo các thư mục******************"
sudo mkdir -p /etc/snort/rules

sudo mkdir /var/log/snort

sudo mkdir /usr/local/lib/snort_dynamicrules
echo "******************phân quyền******************"
sudo chmod -R 5775 /etc/snort

sudo chmod -R 5775 /var/log/snort

sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules

sudo chown -R snort:snort /etc/snort

sudo chown -R snort:snort /var/log/snort

sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules
echo "******************tạo tập tin không có nội dung******************"
sudo touch /etc/snort/rules/white_list.rules

sudo touch /etc/snort/rules/black_list.rules

sudo touch /etc/snort/rules/local.rules
echo "******************copy các tệp cấu hình vào thư mục hệ thống******************"
sudo cp ~/snort_src/snort-2.9.13/etc/*.conf* /etc/snort

sudo cp ~/snort_src/snort-2.9.13/etc/*.map /etc/snort
echo "******************dowload rules******************"
wget https://www.snort.org/rules/community -O ~/community.tar.gz

sudo tar -xvf ~/community.tar.gz -C ~/

sudo cp ~/community-rules/* /etc/snort/rules

wget https://www.snort.org/rules/snortrules-snapshot-29120.tar.gz?oinkcode=838e000a045802f4b3444d4118ba6f26bbb50247 -O ~/registered.tar.gz

sudo tar -xvf ~/registered.tar.gz -C /etc/snort

sudo yum install vim -y
echo "******************cấu hình snort******************"
vim /etc/snort/snort.conf
