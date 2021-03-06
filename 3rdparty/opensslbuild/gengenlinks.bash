#!/bin/bash
# Copyright (c) 2013 The libmumble Developers
# The use of this source code is goverened by a BSD-style
# license that can be found in the LICENSE-file.

# This script generates a script that can regenerate the
# OpenSSL source tree's include directory structure.
# This is a destructive operation on the OpenSSL source
# tree. Use with care.

trap exit SIGINT SIGTERM

cd ../openssl

git clean -dfx
git reset --hard

./Configure linux-elf
cd ../opensslbuild

echo "# This file was generated by gengenlinks.bash" > genlinks.bash
echo "" >> genlinks.bash
echo "mkdir -p ../openssl/include/openssl" >> genlinks.bash
echo "cd ../openssl/include/openssl" >> genlinks.bash

for fn in $(ls ../openssl/include/openssl); do
	dst=$(readlink ../openssl/include/openssl/${fn})
	echo "ln -s ${dst} ${fn} 2>/dev/null" >> genlinks.bash
done

echo "exit 0" >> genlinks.bash

cd ../openssl

git clean -dfx
git reset --hard
