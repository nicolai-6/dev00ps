package components

import (
	"crypto/ecdsa"
	"crypto/rand"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"fmt"
	"os"
)

// func create certificaterequest template
func CreateCSR(cn string, on string, privKey *ecdsa.PrivateKey) []byte {
	// CSR subject content
	CSRsubj := pkix.Name{
		CommonName: cn,
	}

	// create CSR template
	template := x509.CertificateRequest{
		Subject:            CSRsubj,
		SignatureAlgorithm: x509.ECDSAWithSHA512,
		ExtraExtensions: []pkix.Extension{
			{
				Id:    []int{2, 5, 29, 17},
				Value: []byte("otherName:" + on),
			},
		},
	}

	// create CSR from template
	CSRb, err := x509.CreateCertificateRequest(rand.Reader, &template, privKey)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	return CSRb
}

// func encode CSR DER to PEM format
func ConvertCSRDERtoPEM(csr []byte) []byte {
	csrBytes := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE REQUEST", Bytes: csr})
	return csrBytes
}
