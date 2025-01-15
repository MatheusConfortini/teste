#!/usr/bin/env bash


#importa as variaveis de ambiente 

source /home/pascal/LAMW/lamw4linux/etc/environment


#variaveis 
export ACBR_HOME=/var/jenkins_home/workspace/Teste-Pipeline/trunk2
export ANDROID_HOME=/opt/ides/lamw/sdk

#armazenar a keystore e e senhas em algum lugar para reusa-las depois ...

KEY_PASSWORD="Iv7pj2SPSOJXcMkRtW26"
KEYSTORE_PASSWORD="$KEY_PASSWORD"
KEYSTORE_ALIAS=acbrlibandroidsign
KEYSTORE_PUBLIC_KEY="${KEYSTORE_ALIAS}-public.pem"
KEYSTORE_FILE=${KEYSTORE_ALIAS}.keystore
OUTPUT_DIR=$(mktemp -t -d ACBrLib-Android-NFe-DEMO-XXXXXXX)

INPUT_AAR="$ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe/build/outputs/aar/ACBrLibNFe-release.aar" 
SIGNED_OUTPUT_AAR="$OUTPUT_DIR/ACBrLibNFe-release.aar"
KEYSTORE_INFO="CN=Projeto ACBr Consultoria S.A Signing Key, OU=ACBrLab, O=Projeto ACBr Consultoria S.A, L=São Paulo, ST=SP, C=BR"
KEYSTORE_PATH=~/android-keystore
#tempo de expiracao do certificaod 
VALIDITY_KEY=1800


ACBRLIB_LPI_DIR="$ACBR_HOME/Projetos/ACBrLib/Fontes/NFe"
ACBRLIB_ANDROID_PROJECT_DIR="$ACBR_HOME/Projetos/ACBrLib/Android/NFe/ACBrLibNFe"
JNILIBS_OUTDIR="$ACBRLIB_ANDROID_PROJECT_DIR/src/main/jniLibs"


copiarJNiLibsDependencias(){
	# copiar as bibliotecas do openssl para o projeto android
	cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/arm-linux-androideabi/Dynamic/*  $JNILIBS_OUTDIR/armeabi-v7a
	cp $ACBR_HOME/DLLs/Android/OpenSSL/openssl-1.1.1d/aarch64-linux-android/Dynamic/*  $JNILIBS_OUTDIR/arm64-v8a


	#copiar a libxml2 para android 

	cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/arm-linux-androideabi/Dynamic/*.so $JNILIBS_OUTDIR/armeabi-v7a
	cp $ACBR_HOME/DLLs/Android/LibXML2/libxml2-2.9.10/aarch64-linux-android/Dynamic/*.so $JNILIBS_OUTDIR/arm64-v8a 
	cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/arm-linux-androideabi/Dynamic/*.so $JNILIBS_OUTDIR/armeabi-v7a 
	cp $ACBR_HOME/DLLs/Android/LibXML2/libxslt-1.1.34/aarch64-linux-android/Dynamic/*.so $JNILIBS_OUTDIR/arm64-v8a

}

copiarJNiLibsParaProjetoAndroid(){
	cp  $ACBRLIB_LPI_DIR/bin/Android/jniLibs -r $(dirname "$JNILIBS_OUTDIR")
	copiarJNiLibsDependencias

}




compilarACBrLibComumJar(){
	cd $ACBR_HOME/Projetos/ACBrLib/Android/Comum

	#compilando ACBrLibBase
	./gradlew createJar

}
compilarAAR(){
	cd $ACBR_HOME/Projetos/ACBrLib/Android/NFe
	./gradlew clean build 

}


gerarAndroidKeystore(){

	if [ ! -e "$KEYSTORE_PATH" ]; then 

		mkdir $KEYSTORE_PATH

		cd $KEYSTORE_PATH

		#gerar chave 

		keytool -genkeypair -v -keystore "$KEYSTORE_FILE" -keyalg RSA -keysize 2048 -validity "$VALIDITY_KEY" -alias "$KEYSTORE_ALIAS" -dname "$KEYSTORE_INFO" -storetype  PKCS12  -storepass "$KEY_PASSWORD" -keypass "$KEYSTORE_PASSWORD"

		#exportar certificado 

		keytool -exportcert -rfc -alias $KEYSTORE_ALIAS -file "${KEYSTORE_PUBLIC_KEY}" -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -v
	fi
}




assinarAAR(){
	cd $KEYSTORE_PATH
	jarsigner -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEY_PASSWORD -signedjar $SIGNED_OUTPUT_AAR -verbose $INPUT_AAR $KEYSTORE_ALIAS
}

compilarJNiLibs
copiarJNiLibsParaProjetoAndroid
compilarACBrLibComumJar
compilarAAR
gerarAndroidKeystore
assinarAAR
