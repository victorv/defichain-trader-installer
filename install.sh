
SNAPSHOT_BASE_EU=https://defi-snapshots-europe.s3.eu-central-1.amazonaws.com
SNAPSHOT_NAME_EU="$(curl -s $SNAPSHOT_BASE_EU/index.txt | tail -1)"
SNAPSHOT_URL_EU="$SNAPSHOT_BASE_EU/$SNAPSHOT_NAME_EU"
DFI_RELEASE_BASE=https://github.com/DeFiCh/ain/releases/download
DFI_RELEASE_VERSION=$1
DFI_RELEASE_FILE=defichain-${DFI_RELEASE_VERSION}-x86_64-pc-linux-gnu.tar.gz

rm -rf data_directory
rm -rf /var/lib/defid
rm -rf "defichain-${DFI_RELEASE_VERSION}"
rm -rf "$DFI_RELEASE_FILE"
rm -rf "${DFI_RELEASE_FILE}.SHA256"

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

mkdir data_directory
mkdir /var/lib/defid

wget "$SNAPSHOT_URL_EU"
unzip -q "$SNAPSHOT_NAME_EU" -d data_directory
mv data_directory/anchors /var/lib/defid
mv data_directory/blocks /var/lib/defid
mv data_directory/chainstate /var/lib/defid
mv data_directory/history /var/lib/defid
mv data_directory/enhancedcs /var/lib/defid
mv data_directory/indexes /var/lib/defid
rm -rf "$SNAPSHOT_NAME_EU"
rm -rf data_directory

mkdir /var/lib/defid/wallets
chown -R defi:defi /var/lib/defid/
chmod 0710 /var/lib/defid/

mkdir /var/log/defid
chown -R defi:defi /var/log/defid/
chmod 0710 /var/log/defid/

mkdir /run/defid
chown -R defi:defi /run/defid/
chmod 0710 /run/defid/

wget -q "${DFI_RELEASE_BASE}/v${DFI_RELEASE_VERSION}/${DFI_RELEASE_FILE}"
wget -q "${DFI_RELEASE_BASE}/v${DFI_RELEASE_VERSION}/${DFI_RELEASE_FILE}.SHA256"

sha256sum -c "${DFI_RELEASE_FILE}.SHA256"

if [ $? -ne 0 ]
then
    exit 1
fi

tar xzf "${DFI_RELEASE_FILE}"
cp "defichain-${DFI_RELEASE_VERSION}/bin/defid" /usr/bin
cp "defichain-${DFI_RELEASE_VERSION}/bin/defi-cli" /usr/bin

rm -rf "defichain-${DFI_RELEASE_VERSION}"
rm -rf "$DFI_RELEASE_FILE"
rm -rf "${DFI_RELEASE_FILE}.SHA256"

if ! grep -q defi-cli "$HOME/.bashrc"; then
  echo "alias defi-cli='defi-cli -datadir=/var/lib/defid -conf=/etc/defi/defi.conf'" >> "$HOME/.bashrc"
  source .bashrc
fi

systemctl daemon-reload
systemctl enable defid
systemctl start defid