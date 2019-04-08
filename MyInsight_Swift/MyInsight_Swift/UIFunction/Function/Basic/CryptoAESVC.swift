//
//  CryptoAESVC.swift
//  MyInsight_Swift
//
//  Created by SongMenglong on 2019/4/8.
//  Copyright © 2019 SongMengLong. All rights reserved.
//

import UIKit
import CryptoSwift // 加密解密

/// AES加密
class CryptoAESVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 白色
        self.view.backgroundColor = UIColor.white
        
        // AES加密
        let button = UIButton(type: UIButton.ButtonType.custom)
        self.view.addSubview(button)
        button.frame = CGRect(x: 150, y: 150, width: 200, height: 50)
        button.setTitle("加密", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(aesButtonAction(button:)), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.blue
    }
    
    // MARK: 加密button的事件
    @objc func aesButtonAction(button: UIButton) -> Void {
        debugPrint("加密Button 事件")
        
        /*
         "发送的局域网数据字符串:  {\"command\":\"query\",\"from_account\":\"15989894959\",\"from_role\":\"phone\",\"msg_type\":\"search\"}"
         "发送搜索广播的加密字符串:: oP4/FseG8xpLnOtuwmIRkqzKhU7jpP/SEVc2V8ZQvadDG9yNWugJyTQK8p7AQJa++SYw9icxP3zOt6PG3LBQCgaE3/5SZrepZGt+zlgpbQsDJsH+/ytBg91udUTAiDJ2"
         
         
         "发送的局域网数据字符串:  {\"command\":\"query\",\"msg_type\":\"search\",\"from_account\":\"15989894959\",\"from_role\":\"phone\"}"
         "发送搜索广播的加密字符串:: oP4/FseG8xpLnOtuwmIRklPea5VIh2lSAlO/jPbt1WNhgWP1u8nHnVuYrtib/GwWhzZGCp1G886hoqpK9DlARO2Jc+GRp0UunWnY7OMO8NBzBkYmi9Xp5jJ/PDCTgwu2"
         
         "发送的局域网数据字符串:  :{\"from_role\":\"phone\",\"from_account\":\"15989894959\",\"command\":\"query\",\"msg_type\":\"search\"}"
         "发送搜索广播的加密字符串::  :kUTPl91jR+FMkx+Qy49QfVnTon0cppcm17koSN8JLMtTqvEYAmSGb23vyBAwlwiRQv2SQfkrBZMDsPBczNw6IDyllJw9OYnPpn0pu41LUTcDJsH+/ytBg91udUTAiDJ2"
         
         "发送的局域网数据字符串:  :{\"msg_type\":\"search\",\"from_account\":\"15989894959\",\"from_role\":\"phone\",\"command\":\"query\"}"
         "发送搜索广播的加密字符串::  :uZAFF71OFbwIQ9HlRJQoJuIFTZzuSOMnbaWaAzEB8pFTqvEYAmSGb23vyBAwlwiRhHIUjxz8SPXisiZb5fmJlsY2suS4ug47N+kBMjWDO3zpGmKnWBamY8vT5ZKKBeuv"
         
         */
        
        do {
            
            let str = "{\"msg_type\":\"search\",\"from_account\":\"15989894959\",\"from_role\":\"phone\",\"command\":\"query\"}"
            print("原始字符串：\(str)")
            
            let key = "gvy2674201410109"
            print("key密钥：\(key)")
            
            //使用AES-128-ECB加密模式
            let aes = try AES(key: key.bytes, blockMode: ECB())
            
            //开始加密
            let encrypted = try aes.encrypt(str.bytes)
            debugPrint("加密::: \(encrypted)")
            let encryptedBase64 = encrypted.toBase64() //将加密结果转成base64形式
            print("加密结果(base64)：\(encryptedBase64!)")
            
            //开始解密1（从加密后的字符数组解密）
            let decrypted1 = try aes.decrypt(encrypted)
            print("解密结果1：\(String(data: Data(decrypted1), encoding: .utf8)!)")
            
            //开始解密2（从加密后的base64字符串解密）
            let decrypted2 = try encryptedBase64?.decryptBase64ToString(cipher: aes)
            print("解密结果2：\(decrypted2!)")
        } catch { }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
