# Installation
1. Make sure you download both defid.tar.gz.gpg **AND** defid.tar.gz.gpg.sha256
```shell
git clone https://gitlab.com/defichain-trader.com/installer.git
```

2. You can install the defid daemon and enable log rotation as follows:
```shell
cd installer
chmod +x install.sh
# Version numbers can be found here: https://github.com/DeFiCh/ain/releases
./install.sh [version number e.g. 2.10.0]
```