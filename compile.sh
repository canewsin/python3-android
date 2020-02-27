#!/bin/bash

prepare_arch(){
arch=$1
file="pybuild/env.py"
if [ -f "$file" ]
then
	echo "$file found."
	txt="target_arch = '$arch'"
	sed -i "1s/.*/$txt/" $file
	cat $file
else
	echo "$file not found. Repo Corrupted..."
	exit
fi

}


compile_bin(){
arch=$1
if [ -e "temp/sysroot-$arch" ]
then
echo "Compiled Binaries Available."
#make clean
echo "Cleaning Existing Binaries on Build Folder."
cp -r "temp/sysroot-$arch" "build/sysroot"
echo "Copying Binaries to Sysroot."
echo "Executing Make"
#make
#else
#make clean
#make
fi

if [ -e "temp/sysroot-$arch" ]
then
rm -r "temp/sysroot-$arch"
mkdir "temp/sysroot-$arch"
cp -r "build/sysroot" "temp/sysroot-$arch"
else
mkdir "temp/sysroot-$arch"
cp -r "build/sysroot" "temp/sysroot-$arch"
fi
}


compress_arch(){
arch=$1
file="sysrooot-$arch.zip"
if [ -e "$file" ]
then
	rm -r "$file"
fi
pushd 'build/sysroot/usr'

cp -r "../../../cleardir.py" "cleardir.py"
python3 "cleardir.py"

archvar=""

case "$arch" in
arm64)
	archvar="arm64-v8a"
	;;
arm)
	archvar="armeabi-v7a"
	;;
x86)
        archvar="x86"
        ;;
x86_64)
        archvar="x86_64"
        ;;
esac
echo ""
echo ""
echo "$archvar"
echo ""
echo ""

pushd "bin/"

for item in "python3.8" "openssl"
do
archdir="../../../../bin/$archvar"
if [ ! -e "$archdir" ]
then
mkdir "$archdir"
fi

binitem="$archdir/lib$item.so"

if [ -e "$binitem" ]
then
echo "Removing Old Binaries of lib$item.so for $arch"
rm -r "$binitem"
fi

cp -r "$item" "$binitem"
done
popd



pushd "lib/"

file="../../../../bin/python3.8-$arch.zip"

if [ -e "$file" ]
then
	echo "Removing Old Binary Zip Files of $file for $arch"
	rm -r "$file"
fi

for item in "python3.8/" "libpython3.8.so"
do
zip -r "$file" "$item"
done

popd

popd

}

start(){
#line=$(read -r FIRSTLINE < "pybuild/env.py")
#if [ "target_arch = '$1'" -eq line ]
#then
if [ ! -e "temp/" ]
then
mkdir 'temp'
fi
#else
	prepare_arch $1
	compile_bin $1
	compress_arch $1
#fi
}


if [ $1 ]
then
	start $1
else
	for arch in 'arm' 'arm64' 'x86' 'x86_64'
	do
	start $arch
	done
fi
