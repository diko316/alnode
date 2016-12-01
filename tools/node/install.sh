#cd /tmp || exit 1
#curl -o node-v${NODE_VERSION}.tar.gz -SsL https://nodejs.org/dist/latest-v5.x/node-v${NODE_VERSION}.tar.gz || exit 1
#tar -zxf node-v${NODE_VERSION}.tar.gz || exit 1
#cd node-v${NODE_VERSION} || exit 1
#export GYP_DEFINES="linux_use_gold_flags=0"
#./configure --fully-static --prefix=/usr || exit 1
#NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
#make -j${NPROC} -C out mksnapshot BUILDTYPE=Release || exit 1
#paxctl -cm out/Release/mksnapshot || exit 1
#make -j${NPROC} || exit 1
#make install || exit 1
#paxctl -cm /usr/bin/node || exit 1
#if [ -x /usr/bin/npm ]; then
#    npm install -g npm@${NPM_VERSION} || exit 1
#    find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf || exit 1
#fi
#
#exit 0

echo "Installing Node ${VERSION}"

cd /tmp || exit 1
curl -o node-v${NODE_VERSION}.tar.gz -SsL https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz || exit 1
tar -zxf node-v${NODE_VERSION}.tar.gz || exit 1
cd node-v${NODE_VERSION} || exit 1
export GYP_DEFINES="linux_use_gold_flags=0"
./configure --fully-static --prefix=/usr || exit 1
NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)
make -j${NPROC} -C out mksnapshot BUILDTYPE=Release || exit 1
paxctl -cm out/Release/mksnapshot || exit 1
make -j${NPROC} || exit 1
make install || exit 1
paxctl -cm /usr/bin/node || exit 1
if [ -x /usr/bin/npm ]; then
    npm install -g npm@${NPM_VERSION} || exit 1
    find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf || exit 1
fi

exit 0





