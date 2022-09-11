DOWNLOAD_PAGE=https://github.com/DeFiCh/ain/releases/download
DFI_RELEASE_VERSION=$1
DFI_RELEASE_FILE=defichain-${DFI_RELEASE_VERSION}-x86_64-pc-linux-gnu.tar.gz

rm -rf defichain-${DFI_RELEASE_VERSION}
rm -rf ${DFI_RELEASE_FILE}
rm -rf ${DFI_RELEASE_FILE}.SHA256

if [[ $# -lt 1 ]];
then
  echo "Usage: $0 [release version number e.g. 2.10.0]"
  exit 2
fi

systemctl stop defid

adduser \
   --system \
   --shell /bin/false \
   --gecos 'defid daemon user' \
   --group \
   --disabled-password \
   --no-create-home \
   defi

cp defid.service /lib/systemd/system
cp defid.logrotate /etc/logrotate.d/defid

mkdir /etc/defi
cp defi.conf /etc/defi
chown -R defi:defi /etc/defi/
chmod 0710 /etc/defi/

mkdir /var/lib/defid
mkdir /var/lib/defid/wallets
chown -R defi:defi /var/lib/defid/
chmod 0710 /var/lib/defid/

mkdir /var/log/defid
chown -R defi:defi /var/log/defid/
chmod 0710 /var/log/defid/

mkdir /run/defid
chown -R defi:defi /run/defid/
chmod 0710 /run/defid/

wget -q ${DOWNLOAD_PAGE}/v${DFI_RELEASE_VERSION}/${DFI_RELEASE_FILE}
wget -q ${DOWNLOAD_PAGE}/v${DFI_RELEASE_VERSION}/${DFI_RELEASE_FILE}.SHA256

sha256sum -c ${DFI_RELEASE_FILE}.SHA256

if [ $? -ne 0 ]
then
    exit 1
fi

tar xzf ${DFI_RELEASE_FILE}
cp defichain-${DFI_RELEASE_VERSION}/bin/defid /usr/bin
cp defichain-${DFI_RELEASE_VERSION}/bin/defi-cli /usr/bin

if ! grep -q defi-cli $HOME/.bashrc; then
  echo "alias defi-cli='defi-cli -datadir=/var/lib/defid -conf=/etc/defi/defi.conf'" >> $HOME/.bashrc
  source .bashrc
fi

systemctl daemon-reload
systemctl enable defid
echo "You can now use systemctl to start your full node: systemctl start defid"
