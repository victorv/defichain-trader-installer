# Installation
1. Make sure you download both defid.tar.gz.gpg **AND** defid.tar.gz.gpg.sha256

2. Verify that the downloaded checksum matches the sha256 hash of defid.tar.gz.gpg with:
```shell
sha256sum -c defid.tar.gz.gpg.sha256
defid.tar.gz.gpg: OK
```

3. To verify the signature you can import my public key as follows:
```shell
gpg --auto-key-locate hkps://keys.openpgp.org --locate-keys defichain-trader@tutanota.com
```
Use the following every week or so before attempting verification of the signature to stay up to date
```shell
gpg --refresh-keys
```

4. Decrypt the signed defid.tar.gz.gpg as follows:
```shell
gpg --decrypt defid.tar.gz.gpg > defid.tar.gz
```
Pay special attention to the output and make sure it contains "Good signature from Ruben Baas <defichain-trader@tutanota.com>":
```shell
gpg: Signature made Sun 11 Sep 2022 11:14:23 AM UTC
gpg:                using RSA key C40C321133EF83476DB9CFA7C0C1D2D28E5C572E
gpg: Good signature from "Ruben Baas <defichain-trader@tutanota.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: C40C 3211 33EF 8347 6DB9  CFA7 C0C1 D2D2 8E5C 572E
```

There will be a WARNING if you have not trusted the key:
```shell
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
```

It is up to you to decide if you want to trust the key or read the WARNING every time.
Either way you should be able to decrypt defid.tar.gz.gpg file.

5. Now you can extract the compressed installer files with:
```shell
tar -xvf defid.tar.gz
```
This will create a directory called defid.

6. You can install the defid daemon and enable log rotation as follows:
```shell
cd defid
chmod +x install.sh
# Version numbers can be found here: https://github.com/DeFiCh/ain/releases
./install.sh [version number e.g. 2.10.0]
```