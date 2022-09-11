rm -rf defid defid.tar.gz defid.tar.gz.gpg defid.tar.gz.gpg.sha256

mkdir defid
cp defi.conf defid.logrotate defid.service install.sh defid/

tar -czvf defid.tar.gz defid/
gpg --sign defid.tar.gz

rm -rf defid
rm -rf defid.tar.gz

sha256sum defid.tar.gz.gpg > defid.tar.gz.gpg.sha256
gpg --export defichain-trader@tutanota.com | curl -T - https://keys.openpgp.org