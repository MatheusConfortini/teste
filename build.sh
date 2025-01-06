#!/usr/bin/env bash

export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline



# é importante ter o cmdlinetools instalado
# https://developer.android.com/studio#command-tools

export ANDROID_HOME=/opt/ides/lamw/sdk


w=( 
#'/CONFIG/ProjectOptions/BuildModes/Item3/@Name
'/CONFIG/ProjectOptions/BuildModes/Item3/CompilerOptions/SearchPaths/OtherUnitFiles/@Value' 
#'/CONFIG/ProjectOptions/BuildModes/Item4/@Name
'/CONFIG/ProjectOptions/BuildModes/Item4/CompilerOptions/SearchPaths/OtherUnitFiles/@Value'  
)


for node in ${w[*]}; do

	other_units="$(xmlstarlet sel -t -v  $node  $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi)"
	acbr_base="\$(ACBrDir)/Fontes/ACBrDFe/ACBrNFe/Base"
	other_units_fixed="$other_units;acbr_base"
	xmlstarlet edit  --inplace  -u "$node" -v "$expected_node_attr_value" "$xml_file_path"
done

# compilar a lib para android com lazbuild ...

# copiar a lib para o projeto android

cd $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe


w=( 
#'/CONFIG/ProjectOptions/BuildModes/Item3/@Name
'/CONFIG/ProjectOptions/BuildModes/Item3/CompilerOptions/SearchPaths/OtherUnitFiles/@Value' 
#'/CONFIG/ProjectOptions/BuildModes/Item4/@Name
'/CONFIG/ProjectOptions/BuildModes/Item4/CompilerOptions/SearchPaths/OtherUnitFiles/@Value'  
)


#xmlstartlet é instalado pelo lamw_manager_setup.sh

for node in ${w[@]}; do
	svn revert . -R
	export other_units="$(xmlstarlet sel -t -v  $node  $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi)"
	export acbr_base="\$(ACBrDir)/Fontes/ACBrDFe/ACBrNFe/Base"
	export other_units_fixed="$other_units;$acbr_base"
	xmlstarlet edit  --inplace  -u "$node" -v "$other_units_fixed" "$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/ACBrLibNFeConsoleMT.lpi"
done

/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild --bm=android-armeabi-v7a ACBrLibNFeConsoleMT.lpi
/home/pascal/LAMW/lamw4linux/usr/bin/lazbuild --bm=android-arm64-v8a ACBrLibNFeConsoleMT.lpi
cp  $ACBR_HOME/Projetos/ACBrLib/Fontes/NFe/bin/Android/jniLibs $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe -r


# copiar as bibliotecas do openssl para o projeto android

cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/arm-linux-androideabi/Dynamic/*  $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/aarch64-linux-android/Dynamic/*  $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a


#copiar a libxml2 para android 

cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a
cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/arm-linux-androideabi/Dynamic/*.so $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/armeabi-v7a 
cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/aarch64-linux-android/Dynamic/*.so $ACBR_HOME/projetos/ACBrLib/Android/NFe/ACBrLibNFe/jniLibs/arm64-v8a
#compilando ACBrLibBase
cd $ACBR_HOME/projetos/ACBrLib/Android/Comum
./gradlew createJar

#build do aar 
cd $ACBR_HOME/projetos/ACBrLib/Android/NFe

./gradlew clean build 
