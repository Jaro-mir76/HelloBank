//
//  SecureInformation.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

class SecureEngine: ObservableObject {
    var securityIdentity: SecIdentity? = nil
    @Published var publicCertificate: SecCertificate? = nil
    @Published var privateKey: SecKey? = nil
    var apiKey: String? = nil
    @Published var clientId: String? = nil
    @Published var clientSecret: String? = nil
    @Published var walletId: String? = nil
    var walletSecret: String? = nil
    var accessToken: String? = nil
    @Published var error: CustomError? = nil
    var httpsEngine: HttpsEngine!
    
    init() {
        self.httpsEngine = HttpsEngine(secureEngine: self)
    }
    
    func requestWalletId() {
        do {
            try httpsEngine.getWallet() {w in
                DispatchQueue.main.async {
                    self.walletId = w.walletId
                    self.walletSecret = w.walletSecret
                }
            }
        }catch let error as CustomError{
            self.error = error
        }catch let error {
            self.error = .otherError(innerError: error)
        }
    }
    
    func getCertFromFile() -> SecCertificate? {
        do {
            let certRawData = try getImportantFileContent("public-key", "pem")
            guard let publicCert = SecCertificateCreateWithData(nil, certRawData as NSData) else {throw CustomError.wrongCertificateFile}
//            If there is already private key then try to create security identity
            if let privK = self.privateKey {
                try createSecIdentity(publicCert, privK)
            }
            return publicCert
        }catch let error as CustomError{
            self.error = error
        }catch {
            self.error = .otherError(innerError: error)
        }
        return nil
    }
    
    func getPrivKeyFromFile() -> SecKey? {
        do {
            let rawData = try getImportantFileContent("private-key", "key")
            guard let privKeyRawData = extractKeyFromASN1(rawData) else {throw CustomError.wrongKeyFile}
            guard let privateKey = SecKeyCreateWithData(privKeyRawData as NSData, [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPrivate
            ] as NSDictionary, nil) else {throw CustomError.wrongKeyFile}
//            If there is already certificate then try to create security identity
            if let cert = self.publicCertificate {
                try createSecIdentity(cert, privateKey)
            }
            return privateKey
        }catch let error as CustomError{
            self.error = error
        }catch {
            self.error = .otherError(innerError: error)
        }
        return nil
    }
    
    func createSecIdentity(_ cert: SecCertificate, _ privKey: SecKey)throws {
        guard checkCertKeyConsistency(cert, privKey) else {throw CustomError.certKeyInconsistent}

//          Attempt to add and check result, if error is errSecDuplicateItem it means cert/privKey is already there but we can continue, otherwise we stop immediatelly
        var exitCode: OSStatus
        exitCode = SecItemAdd([kSecValueRef: cert] as NSDictionary, nil)
        guard exitCode == errSecSuccess || exitCode == errSecDuplicateItem else {throw NSError(domain: NSOSStatusErrorDomain, code: Int(exitCode))
        }
        exitCode = SecItemAdd([kSecValueRef: privKey] as NSDictionary, nil)
        guard exitCode == errSecSuccess || exitCode == errSecDuplicateItem else {throw NSError(domain: NSOSStatusErrorDomain, code: Int(exitCode))
        }
        
//        At that stage identity should be automatically created so we search it to add to securityIdentity variable
        let searchIdentity = [
            kSecClass: kSecClassIdentity,
            kSecMatchLimit: kSecMatchLimitAll,
            kSecReturnRef: true
        ] as NSDictionary
        var searchResult: CFTypeRef? = nil
        exitCode = SecItemCopyMatching(searchIdentity, &searchResult)
        guard exitCode == errSecSuccess else {throw NSError(domain: NSOSStatusErrorDomain, code: Int(exitCode))
        }
        let identities = searchResult! as! [SecIdentity]
//        Among all found identities it search the one that corresponds to our public certificate
        let identity = identities.first(where: {i in
            var certRef: SecCertificate?
            let _ = SecIdentityCopyCertificate(i, &certRef)
            return CFEqual(certRef, cert)
        })
        if identity != nil {
            self.securityIdentity = identity
        }
    }
    
    func checkCertKeyConsistency(_ cert: SecCertificate, _ privKey: SecKey) -> Bool {
        let certPublicKey = SecCertificateCopyKey(cert)
        let privKeyPublicKey = SecKeyCopyPublicKey(privKey)
        return CFEqual(certPublicKey, privKeyPublicKey)
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
