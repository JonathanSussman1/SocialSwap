//
//  EncryptionHelper.swift
//  SocialSwap
//
//  Created by DAYE JACK on 5/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import CryptoSwift
import FirebaseFirestore

class EncryptionHelper {
    static func getTheKey(completion:@escaping (String, String) -> Void){
        let db = Firestore.firestore()
        db.collection("security").document("lock").getDocument { (lock, err) in
            if let lock = lock {
                let key = lock.data()!["key"] as! String
                let iv = lock.data()!["iv"] as! String
                completion(key, iv)
            }
            else{
                print("Error getting key")
                return
            }
        }
    }
    
    static func encryptString(strVal: String, key: [UInt8], iv: [UInt8]) -> String{
        var encrypted: [UInt8] = []
        print("Original String bytes", strVal.bytes)
        
        do{
            encrypted = try ChaCha20(key: key, iv: iv).encrypt(strVal.bytes)
            print("Encrypted bytes", encrypted)
        }
        catch {
            print("uh oh")
        }
        print("Encrypted string is", Data(encrypted).base64EncodedString())
        return Data(encrypted).base64EncodedString()
    }
    
    static func decryptString(encryptedString strVal: String, key: [UInt8], iv: [UInt8]) -> String? {
        let data = Data(base64Encoded: strVal)//strVal.bytes//Array(strVal.utf8)
        if(data == nil){
            return nil
        }
        let encrypted: [UInt8] = data!.bytes
        print("Encrypted bytes from scan", encrypted)
        var decrypted: [UInt8] = []
        do{
            decrypted = try ChaCha20(key: key, iv: iv).decrypt(encrypted)
            print("Decrypted bytes from scan", decrypted)
        }
        catch {
        }
        print("Decrypted string is", String(bytes: decrypted, encoding: .utf8)!)
        return String(bytes: decrypted, encoding: .utf8)
    }
}
