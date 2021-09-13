#!/bin/bash

set -uexo pipefail

FIZZBUILD_CMAKE_BUILD_TYPE="${FIZZBUILD_CMAKE_BUILD_TYPE:-Release}"

cmake_configure() {
    cmake -GNinja -DCMAKE_PREFIX_PATH=/build/prefix/ \
        -DCMAKE_INSTALL_PREFIX=/build/prefix/ \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_BUILD_TYPE="$FIZZBUILD_CMAKE_BUILD_TYPE" \
        "$@"
}

mkdir -p /build/folly
mkdir -p /build/fizz
mkdir -p /build/prefix

CCACHE_DIR="/ccache"
export CCACHE_DIR

if [ ! -f "$CCACHE_DIR/ccache.conf" ]; then
    cat > "$CCACHE_DIR/ccache.conf" << EOF
max_size = 20G
EOF
fi

cd /build/folly && cmake_configure /src/folly && ninja install
cd /build/fizz && cmake_configure /src/fizz/fizz -DBUILD_TESTS:BOOL=Off && ninja FizzTool

get_runtime_deps() {
  (
    set +ex
   for dep in $(ldd "$1" | grep '=>' | perl -pe 's/.* => (.*) \(.*/\1/g'); do
       dpkg -S "$dep" 2>/dev/null
       dpkg -S "/usr$dep" 2>/dev/null
   done | cut -d: -f1 | sort | uniq
  )
}

[ -x /build/fizz/bin/fizz ] && [ ! -f "/build/fizz/bin/fizz.deps" ] && get_runtime_deps "/build/fizz/bin/fizz" > /build/fizz/bin/fizz.deps
exit 0
