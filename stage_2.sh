#!/usr/bin/env bash

#Atalho para o LAMW
export lazbuild_lamw=/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild
source /home/pascal/LAMW/lamw4linux/etc/environment

#Variaveis
export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2
export ANDROID_HOME=/home/pascal/LAMW/sdk


ACBRLIB_LPI_DIR="$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe"
ACBRLIB_ANDROID_PROJECT_DIR="$ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe"
JNILIBS_OUTDIR="$ACBRLIB_ANDROID_PROJECT_DIR/src/main/jniLibs"


# Compila LIB com LAMW
if [ -f "$ACBRLIB_LPI_DIR/ACBrLibNFeConsoleMTDemo.lpi" ]; then
  echo -e "Compilando LIB Android...\n"

  ${lazbuild_lamw} --bm=android-armeabi-v7a $ACBRLIB_LPI_DIR/ACBrLibNFeConsoleMTDemo.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-armeabi-v7a.\n"
    exit 1
  fi

  ${lazbuild_lamw} --bm=android-arm64-v8a $ACBRLIB_LPI_DIR/ACBrLibNFeConsoleMTDemo.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-arm64-v8a.\n"
    exit 1
  fi
  
  echo -e "Compilação concluída com sucesso.\n"
  
  echo -e "Copiando Libs para projeto Android. \n"
  cp  $ACBRLIB_LPI_DIR/bin/Android/jniLibs -r $(dirname "$JNILIBS_OUTDIR")

else
  echo -e "ACBrLibNFeConsoleMTDemo.lpi não encontrado, verifique os arquivos.\n"
  exit 1
fi


# copiar as bibliotecas do openssl para o projeto android
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/arm-linux-androideabi/Dynamic/*  $JNILIBS_OUTDIR/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/aarch64-linux-android/Dynamic/*  $JNILIBS_OUTDIR/arm64-v8a

#copiar a libxml2 para android 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/arm-linux-androideabi/Dynamic/*.so $JNILIBS_OUTDIR/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/aarch64-linux-android/Dynamic/*.so $JNILIBS_OUTDIR/arm64-v8a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/arm-linux-androideabi/Dynamic/*.so $JNILIBS_OUTDIR/armeabi-v7a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/aarch64-linux-android/Dynamic/*.so $JNILIBS_OUTDIR/arm64-v8a


cd $ACBR_HOME/Projetos/ACBrLib/Android/Comum
#compilando ACBrLibBase
./gradlew createJar
ls -lha


cd $ACBR_HOME/Projetos/ACBrLib/Android/NFe
./gradlew clean build 
ls -lha


KEY_PASSWORD="Iv7pj2SPSOJXcMkRtW26"
KEYSTORE_PASSWORD="$KEY_PASSWORD"
KEYSTORE_ALIAS=acbrlibandroidsign
KEYSTORE_PUBLIC_KEY="${KEYSTORE_ALIAS}-public.pem"
KEYSTORE_FILE=${KEYSTORE_ALIAS}.keystore
OUTPUT_DIR="$ACBR_HOME/Assinados/Demo"

INPUT_AAR="$ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/build/outputs/aar/ACBrLibNFe-release.aar" 
SIGNED_OUTPUT_AAR="$OUTPUT_DIR/ACBrLibNFe-release.aar"
KEYSTORE_INFO="CN=Projeto ACBr Consultoria S.A Signing Key, OU=ACBrLab, O=Projeto ACBr Consultoria S.A, L=São Paulo, ST=SP, C=BR"
KEYSTORE_PATH="$ACBR_HOME/android-keystore"
#tempo de expiracao do certificaod 
VALIDITY_KEY=1800



assinarAAR(){
	cd $KEYSTORE_PATH
  mkdir -p "$OUTPUT_DIR"
	jarsigner -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEY_PASSWORD -signedjar $SIGNED_OUTPUT_AAR -verbose $INPUT_AAR $KEYSTORE_ALIAS
}


assinarAAR


