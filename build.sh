#!/bin/bash

export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline


# é importante ter o cmdlinetools instalado
# https://developer.android.com/studio#command-tools

export ANDROID_HOME=/opt/ides/lamw/sdk

# compilar a lib para android com lazbuild ...

# copiar a lib para o projeto android

cd $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe
ls -lha
/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild --bm=android-armeabi-v7a ACBrLibNFeConsoleMT.lpi
/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild --bm=android-arm64-v8a ACBrLibNFeConsoleMT.lpi
