//
//  DataCrypto.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/4/29.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import CommonCrypto

// MARK: 系统自带的AES加密方法
class DataCrypto: NSObject {
    
}

extension Data {
    // MARK: 加密
    func aes128_Encrypt(key: String) -> String {
        
        let keyData = key.data(using: String.Encoding.utf8)
        var dataOut = Data(capacity: self.count+kCCBlockSizeAES128)
        //let keyPtr = Data(capacity: kCCKeySizeAES128+1)
        
        var bytesDecrypted: size_t = 0
        
        let mutableDataOutBytes = dataOut.withUnsafeMutableBytes {  (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>  in
            return bytes
        }
        
        
        let status = CCCrypt(CCOperation(kCCEncrypt),
                             CCAlgorithm(kCCAlgorithmAES128),
                             CCOptions(kCCOptionPKCS7Padding|kCCOptionECBMode),
                             keyData!.bytes,
                             kCCBlockSizeAES128,
                             nil,
                             self.bytes,
                             self.count,
                             mutableDataOutBytes,
                             self.count+kCCBlockSizeAES128, //
                             &bytesDecrypted)
        
        if status == kCCSuccess {
            // 加密成功
            
            let outData = Data(bytes: mutableDataOutBytes, count: bytesDecrypted)
            return outData.base64EncodedString()
        }
        debugPrint("加密字符串的结果值: \(status)")
        return ""
    }
    
    // 解密
    func aes128_Decrypt(key: String) -> String {
        
        let keyData = key.data(using: String.Encoding.utf8)
        var dataOut = Data(capacity: self.count+kCCBlockSizeAES128)
        //let keyPtr = Data(capacity: kCCKeySizeAES128+1)
                
        var bytesDecrypted: size_t = 0
        
        let mutableDataOutBytes = dataOut.withUnsafeMutableBytes {  (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>  in
            return bytes
        }
        
        let status = CCCrypt(CCOperation(kCCDecrypt),
                             CCAlgorithm(kCCAlgorithmAES128),
                             CCOptions(kCCOptionPKCS7Padding|kCCOptionECBMode),
                             keyData!.bytes,
                             kCCBlockSizeAES128,
                             nil,
                             self.bytes,
                             self.count,
                             mutableDataOutBytes,
                             self.count+kCCBlockSizeAES128, //dataOut.count,
                             &bytesDecrypted)
        
        if status == kCCSuccess {
            // 加密成功
            let outData: Data = Data(bytes: mutableDataOutBytes, count: bytesDecrypted)
            debugPrint("准备解密后的字符串 \(outData)")
            //return outData.base64EncodedString()
            return String(data: outData, encoding: String.Encoding.utf8)!
        }
        debugPrint("解密字符串的结果值: \(status)")
        return ""
    }
}


