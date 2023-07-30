package components

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

func CheckForExistingKeys(f string) bool {
	if _, err := os.Stat(f); !os.IsNotExist(err) {
		fmt.Printf("File '%v' already exists\n", f)
		return true
	} else {
		return false
	}
}

// func create private key
func CreatePrivKey(ecc elliptic.Curve) *ecdsa.PrivateKey {
	privKey := new(ecdsa.PrivateKey)
	privKey, err := ecdsa.GenerateKey(ecc, rand.Reader)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return privKey
}

// func convert private key to ASN.1 DER format
func ConvertPrivKeyToDER(pk *ecdsa.PrivateKey) []byte {
	privateKeyX509, err := x509.MarshalPKCS8PrivateKey(pk)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return privateKeyX509
}

// func create public key from private key
func CreatePubKey(pk ecdsa.PrivateKey) ecdsa.PublicKey {
	var pubKey ecdsa.PublicKey
	pubKey = pk.PublicKey
	return pubKey
}

// func convert public key to ASN.1 to DER format
func ConvertPubKeyToDER(pubKey ecdsa.PublicKey) []byte {
	publicKeyX509, err := x509.MarshalPKIXPublicKey(&pubKey)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return publicKeyX509
}

// func encode privKey ASN.1 DER to PEM format
func ConvertPrivKeyDERtoPEM(privKey []byte) []byte {
	privKeyX509encoded := pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY", Bytes: privKey})
	return privKeyX509encoded
}

// func encode pubKey ASN.1 DER to PEM format
func ConvertPubKeyDERtoPEM(pubKey []byte) []byte {
	pubKeyX509encoded := pem.EncodeToMemory(&pem.Block{Type: "PUBLIC KEY", Bytes: pubKey})
	return pubKeyX509encoded
}

// write PEM content to file
func WritePEMcontentToFile(f string, c []byte) {
	err := ioutil.WriteFile(f, c, 0644)
	if err != nil {
		log.Fatal(err)
	}
}

// read existing key file content
func ReadExistingKeyFileContent(f string) []byte {
	ekf, err := ioutil.ReadFile(f)
	if err != nil {
		panic(err)
	}
	return ekf
}

// func create private key from DER content
func CreatePrivKeyFromDER(db []byte) *ecdsa.PrivateKey {
	block, _ := pem.Decode(db)
	privKey, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		log.Fatalf("Failed to parse existing private key: %v", err)
		os.Exit(1)
	}
	var privateKey *ecdsa.PrivateKey = privKey.(*ecdsa.PrivateKey)
	return privateKey
}

// func create public key from DER content
func CreatePubKeyFromDER(db []byte) *ecdsa.PublicKey {
	block, _ := pem.Decode(db)
	pubKey, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		panic("failed to parse existing public key, DER encoded public key: " + err.Error())
	}
	var publicKey *ecdsa.PublicKey = pubKey.(*ecdsa.PublicKey)
	return publicKey
}
