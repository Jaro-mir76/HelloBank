//
//  SecureInformation.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

class SecureInformation: ObservableObject {
    var securityIdentiry: SecIdentity? = nil
    @Published var publicCertificate: SecCertificate? = nil
    @Published var privateKey: SecKey? = nil
    var apiKey: String? = nil
    @Published var clientId: String? = nil
    @Published var clientSecret: String? = nil
    var walletId: String? = nil
    var walletSecret: String? = nil
    var accessToken: String? = nil
    
    
    func getCertFromFile() throws(CustomError) -> SecCertificate? {
        do {
            let certRawData = try getImportantFileContent("public-key", "pem")
            guard let publicCert = SecCertificateCreateWithData(nil, certRawData as NSData) else {throw CustomError.wrongCertificateFile}
            if let privK = privateKey {
                guard checkCertKeyConsistency(publicCert, privK) else {throw CustomError.certKeyInconsistent}
            }
            return publicCert
        }catch {
            throw .otherError(innerError: error)
        }
    }
    
    func getPrivKeyFromFile() throws(CustomError) -> SecKey? {
        do {
            let rawData = try getImportantFileContent("private-key", "key")
            guard let privKeyRawData = extractKeyFromASN1(rawData) else {throw CustomError.wrongKeyFile}
            guard let privateKey = SecKeyCreateWithData(privKeyRawData as NSData, [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPrivate
            ] as NSDictionary, nil) else {throw CustomError.wrongKeyFile}
            if let cert = publicCertificate {
                guard checkCertKeyConsistency(cert, privateKey) else {throw CustomError.certKeyInconsistent}
            }
            return privateKey
        }catch {
            throw .otherError(innerError: error)
        }
    }
    
    func checkCertKeyConsistency(_ cert: SecCertificate, _ privKey: SecKey) -> Bool {
        let certPublicKey = SecCertificateCopyKey(cert)
        let privKeyPublicKey = SecKeyCopyPublicKey(privKey)
        
        return CFEqual(certPublicKey, privKeyPublicKey)
    }
    
    func createSecIdentity() {
        
    }
    
    func getImportantFileContent(_ fileName: String, _ fileExtension: String) throws -> Data {
        if let file = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            guard let fileContent = try? String(contentsOf: file, encoding: .utf8) else {throw CustomError.cannotReadFile}
    
//        Unifying end line character in the file because it is not unique
            let tmpfile = fileContent.replacingOccurrences(of: "\r\n", with: "\n")
            
//      Removing header and footer of the file content
            let keyFileContent = tmpfile.split(separator: "\n")
                .dropFirst()
                .dropLast()
                .joined()
            guard let decodedFileContent = Data(base64Encoded: keyFileContent) else {throw CustomError.wrongCertificateFile}
            return decodedFileContent
        }else {
            throw CustomError.cannotReadFile
        }
    }
    
    func extractKeyFromASN1(_ keyBytes: Data) -> Data? {
        guard keyBytes.count > 0 else { return nil }

        var index = 22 // ASN.1 struct must have 0x04 at byte 22
        guard keyBytes[index] == 0x04 else { return nil }
        index += 1
        
        var keyLength = Int(keyBytes[index])
        index += 1

        let isLengthCodedInMultiBytes = keyLength & 0x80 // higth length bit
        if isLengthCodedInMultiBytes == 0 {
            keyLength = keyLength & 0x7f // length is coded in 7 low bits
        } else {
            var byteCount = Int(keyLength & 0x7f) // otherwise, number of bytes is coded in 7 low bits
            guard byteCount + index <= keyBytes.count else { return nil }
            keyLength = 0
            while (byteCount > 0) {
                keyLength = (keyLength * 256) + Int(keyBytes[index])
                index += 1
                byteCount -= 1
            }
        }
        return keyBytes[index..<index+keyLength]
    }
}
