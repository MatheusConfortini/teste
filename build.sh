#!/usr/bin/env bash

#Atalho para o LAMW
export lazbuild_lamw=/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild
source /home/pascal/LAMW/lamw4linux/etc/environment

#Variaveis
export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2
export ANDROID_HOME=/opt/ides/lamw/sdk
export DIR_LIB=$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe


# Compila LIB com LAMW
if [ -f "$DIR_LIB/ACBrLibNFeConsoleMT.lpi" ]; then
  echo -e "Compilando LIB Android...\n"
  
  ${lazbuild_lamw} --bm=android-armeabi-v7a $DIR_LIB/ACBrLibNFeConsoleMT.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-armeabi-v7a.\n"
    exit 1
  fi

  ${lazbuild_lamw} --bm=android-arm64-v8a $DIR_LIB/ACBrLibNFeConsoleMT.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-arm64-v8a.\n"
    exit 1
  fi
  
  echo -e "Compilação concluída com sucesso.\n"
else
  echo -e "ACBrLibNFeConsoleMT.lpi não encontrado, verifique os arquivos.\n"
  exit 1
fi

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
