#!/usr/bin/env bash

#Atalho para o LAMW
export lazbuild_lamw=/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild
source /home/pascal/LAMW/lamw4linux/etc/environment

#Variaveis
export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2
export ANDROID_HOME=/opt/ides/lamw/sdk
export DIR_LPI=$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe

#Copia as bibliotecas do openssl para o projeto android
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/arm-linux-androideabi/Dynamic/*  $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/aarch64-linux-android/Dynamic/*  $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a

#Copia a libxml2 para android 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a

#Compilando ACBrLibBase
cd $ACBR_HOME/Projetos/ACBrLib/Android/Comum
./gradlew createJar

#build do aar 
cd $ACBR_HOME/Projetos/ACBrLib/Android/NFe
./gradlew clean build 
