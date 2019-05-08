//
//  DataCryptoAES.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/5/7.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import CommonCrypto

enum SymmetricCryptorError: Error {
    case missingIV
    case cryptOperationFailed
    case wrongInputData
    case unknownError
}

class DataCryptoAES: NSObject {
    // properties
    // 数据加密
    func crypt(string: String, key: String) throws -> Data {
        do {
            // 字符串转data utf8
            if let data = string.data(using: String.Encoding.utf8) {
                return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
            } else { throw SymmetricCryptorError.wrongInputData }
        } catch {
            throw(error)
        }
    }
    // 数据加密
    func crypt(data: Data, key: String) throws -> Data {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
        } catch {
            throw(error)
        }
    }
    // 数据解密
    func decrypt(_ data: Data, key: String) throws -> Data  {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCDecrypt))
        } catch {
            throw(error)
        }
    }
    // MARK: - 加密解密方法
    internal func cryptoOperation(_ inputData: Data, key: String, operation: CCOperation) throws -> Data {
        // Prepare data parameters
        let keyData: Data! = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = keyData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        //let keyBytes         = keyData.bytes.bindMemory(to: Void.self, capacity: keyData.count)
        let keyLength        = size_t(kCCKeySizeAES128)
        let dataLength       = Int(inputData.count)
        let dataBytes        = inputData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        var bufferData       = Data(count: Int(dataLength) + kCCBlockSizeAES128)
        let bufferPointer    = bufferData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        let bufferLength     = size_t(bufferData.count)
        // 加密偏移量为空
        let ivBuffer: UnsafePointer<UInt8>?  = Data().withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        })
        var bytesDecrypted   = Int(0)
        // Perform operation
        let cryptStatus = CCCrypt(
            operation,                  // Operation
            CCAlgorithm(kCCAlgorithmAES),    // Algorithm
            CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding),  // Options
            keyBytes,                   // key data
            keyLength,                  // key length
            ivBuffer,                   // IV buffer
            dataBytes,                  // input data
            dataLength,                 // input length
            bufferPointer,              // output buffer
            bufferLength,               // output buffer length
            &bytesDecrypted)            // output bytes decrypted real length
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.count = bytesDecrypted // Adjust buffer size to real bytes
            return bufferData as Data
        } else {
            print("Error in crypto operation: \(cryptStatus)")
            throw(SymmetricCryptorError.cryptOperationFailed)
        }
    }
}
