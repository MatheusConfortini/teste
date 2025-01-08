#!/usr/bin/env bash

#Atalho para o LAMW
export lazbuild_lamw=/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild
source /home/pascal/LAMW/lamw4linux/etc/environment

#Variaveis
export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2
#export ANDROID_HOME=/opt/ides/lamw/sdk
export DIR_LPI=$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe

# Compila LIB com LAMW
if [ -f "$DIR_LPI/ACBrLibNFeConsoleMT.lpi" ]; then
  echo -e "Compilando LIB Android...\n"
  
  ${lazbuild_lamw} --bm=android-armeabi-v7a $DIR_LPI/ACBrLibNFeConsoleMT.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-armeabi-v7a.\n"
    exit 1
  fi

  ${lazbuild_lamw} --bm=android-arm64-v8a $DIR_LPI/ACBrLibNFeConsoleMT.lpi
  if [ $? -ne 0 ]; then
    echo -e "Erro ao compilar para android-arm64-v8a.\n"
    exit 1
  fi
  
  echo -e "Compilação concluída com sucesso.\n"
  cp  $DIR_LPI/bin/Android/jniLibs $ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe -r
else
  echo -e "ACBrLibNFeConsoleMT.lpi não encontrado, verifique os arquivos.\n"
  exit 1
fi
