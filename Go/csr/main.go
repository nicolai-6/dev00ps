package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"csr/components"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	// mandatory files: private key, public key and csr
	var files = make([]string, 3)
	files = []string{"files/key.pem", "files/key.pub", "files/new.csr", "files/csr.json"}

	// mandatory keys (private + pub)
	var privateKey = new(ecdsa.PrivateKey)
	var publicKey = new(ecdsa.PublicKey)

	// if private key exists use it - otherwise recreate private and public key
	if components.CheckForExistingKeys(files[0]) {
		// read existing key content and convert DER back to private and public key
		privKeyPEM := components.ReadExistingKeyFileContent(files[0])
		privateKey = components.CreatePrivKeyFromDER(privKeyPEM)
		pubKeyPEM := components.ReadExistingKeyFileContent(files[1])
		publicKey = components.CreatePubKeyFromDER(pubKeyPEM)

		// print PEM content to stdout
		fmt.Printf("existing Private Key content:\n %s\n", privKeyPEM)
		fmt.Printf("existing Public Key content:\n %s\n", pubKeyPEM)
	} else {
		// EC parameters
		keyPairCurve := elliptic.P521()

		// create private key
		privateKey = components.CreatePrivKey(keyPairCurve)
		fmt.Printf("Defined Curve: %v\n", privateKey.Params().Name+"\n")
		// create public key
		*publicKey = components.CreatePubKey(*privateKey)

		// convert keys to DER format
		privKeyDER := components.ConvertPrivKeyToDER(privateKey)
		pubKeyDER := components.ConvertPubKeyToDER(*publicKey)
		// convert keys from DER to PEM format
		privKeyPEM := components.ConvertPrivKeyDERtoPEM(privKeyDER)
		pubKeyPEM := components.ConvertPubKeyDERtoPEM(pubKeyDER)
		// write PEM content to files and print to stdout
		components.WritePEMcontentToFile(files[0], privKeyPEM)
		components.WritePEMcontentToFile(files[1], pubKeyPEM)
		fmt.Printf("new private key content: \n%s\n", privKeyPEM)
		fmt.Printf("new public key content: \n%s\n", pubKeyPEM)
	}

	// CSR values
	commonName := "dev00ps"
	otherName := "devOOps"
	// create CSR
	CSRb := components.CreateCSR(commonName, otherName, privateKey)

	// write CSR to file in PEM format and print to stdout
	CSRPEM := components.ConvertCSRDERtoPEM(CSRb)
	components.WritePEMcontentToFile(files[2], CSRPEM)
	fmt.Printf("new.csr content: \n%s\n", CSRPEM)

	csrF, err := ioutil.ReadFile(files[2])
	if err != nil {
		panic(err)
	}

	// regexp with a lot potential new line characters
	r, err := regexp.Compile(`\r\n|[\r\n\v\f\x{0085}\x{2028}\x{2029}]`)
	if err != nil {
		log.Fatal(err)
		os.Exit(1)
	}

	// replace new line characters with string "\n"
	r.ReplaceAll(csrF, []byte("\\n"))
	// remove last "\n" as we do not require it / should omit it
	t := strings.TrimSuffix(string(csrF), "\n")

	// define json file structure
	type jCSR struct {
		Csr string
	}

	// initiate json object
	newjCSR := jCSR{
		Csr: t,
	}

	// write json to file
	jsonString, _ := json.MarshalIndent(newjCSR, "", "")
	errJwrite := ioutil.WriteFile(files[3], jsonString, 0644)
	if errJwrite != nil {
		log.Fatal(errJwrite)
	}

	// finally print json
	fmt.Printf("Content of json file: \n%v\n", string(jsonString))
}
