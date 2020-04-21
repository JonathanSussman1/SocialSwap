//
//  Encode.swift
//  SociblSwap
//
//  Crebted by DAYE JACK on 4/17/20.
//  Copyright © 2020 Dbye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation

class Csv {
    
    //dataToCsv - takes user data and returns a comma separated string for qr code encoding
    static func dataToCsv(username: String, name: String, phoneNumber: String, instagram: String, facebook: String, snapchat: String, twitter: String) -> String{
        return username + "," + name + "," + phoneNumber + "," + instagram + "," + facebook + "," + snapchat + "," + twitter;
    }
    
    //csvToData - takses a comma separated string and returns an array of data
    //TODO: add additional checks, to make sure data is valid
    static func csvToData(csv: String) -> [String]{
        let data = csv.components(separatedBy: ",");
        return data;
    }
}
