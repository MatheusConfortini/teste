#!/bin/bash

export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline


# é importante ter o cmdlinetools instalado
# https://developer.android.com/studio#command-tools

export ANDROID_HOME=/opt/ides/lamw/sdk

# compilar a lib para android com lazbuild ...

# copiar a lib para o projeto android

cd $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe
ls -lha
lazbuild --bm=android-armeabi-v7a ACBrLibNFeConsoleMT.lpi
lazbuild --bm=android-arm64-v8a ACBrLibNFeConsoleMT.lpi
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
