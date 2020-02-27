compile_bin(){
arch=$1
if [ -e "temp/sysroot-$arch" ]
then
rm -r "temp/sysroot-$arch"
cp -r "build/sysroot-$arch" "temp/sysroot-$arch"
else
if [ ! -e "temp" ]
then
mkdir "temp/"
fi
cp -r "build/sysroot" "temp/sysroot-$arch"
fi
}

compile_bin $1
