#!/usr/bin/env bash

source /home/pascal/LAMW/lamw4linux/etc/environment

##Envs
export lazbuild_lamw=/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild

export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2

export ANDROID_HOME=/opt/ides/lamw/sdk

# compilar a lib para android com lazbuild ...

# copiar a lib para o projeto android


#w=( 
#'/CONFIG/ProjectOptions/BuildModes/Item3/@Name
#'/CONFIG/ProjectOptions/BuildModes/Item3/CompilerOptions/SearchPaths/OtherUnitFiles/@Value' 
#'/CONFIG/ProjectOptions/BuildModes/Item4/@Name
#'/CONFIG/ProjectOptions/BuildModes/Item4/CompilerOptions/SearchPaths/OtherUnitFiles/@Value'  
#)


#xmlstartlet é instalado pelo lamw_manager_setup.sh

#for node in ${w[@]}; do
#	svn revert . -R
#	export other_units="$(xmlstarlet sel -t -v  $node  $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi)"
#	export acbr_base="\$(ACBrDir)/Fontes/ACBrDFe/ACBrNFe/Base"
#	export other_units_fixed="$other_units;$acbr_base"
#	xmlstarlet edit  --inplace  -u "$node" -v "$other_units_fixed" "$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi"
#done

cd $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe

echo -s "Compilando LIB Android..."

if [ -f "$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi" ]; then
  echo -s "Compilando LIB Android..."\n
  ${lazbuild_lamw} --bm=android-armeabi-v7a ACBrLibNFeConsoleMT.lpi
  ${lazbuild_lamw} --bm=android-arm64-v8a ACBrLibNFeConsoleMT.lpi
else
  echo "ACBrLibNFeConsoleMT.lpi não encontrado, verifique os arquivos."\n
fi
${lazbuild_lamw} --bm=android-armeabi-v7a ACBrLibNFeConsoleMT.lpi
${lazbuild_lamw} --bm=android-arm64-v8a ACBrLibNFeConsoleMT.lpi
cp  $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/bin/Android/jniLibs $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe -r


# copiar as bibliotecas do openssl para o projeto android

cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/arm-linux-androideabi/Dynamic/*  $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/aarch64-linux-android/Dynamic/*  $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a


#copiar a libxml2 para android 

cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a
#compilando ACBrLibBase
cd $ACBR_HOME/Projetos/ACBrLib/Android/Comum
./gradlew createJar

#build do aar 
cd $ACBR_HOME/Projetos/ACBrLib/Android/NFe

./gradlew clean build 
