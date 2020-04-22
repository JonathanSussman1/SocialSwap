//
//  QrViewController.swift
//  SocialSwap
//
//  Created by DAYE JACK on 4/11/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import UIKit

class QrViewController: UIViewController {
    
    var instagram: Bool = false
    var facebook: Bool = false
    var snapchat: Bool = false
    var twitter: Bool = false
    var contacts: Bool = false
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let qrString:String = Code.boolToEncoding(user: nil, instagram: instagram, facebook: facebook, twitter: twitter, snapchat: snapchat, contacts: contacts);
        print(qrString);
        qrImageView.image = Code.generateQr(withString: qrString);
        // Do any additional setup after loading the view.
        //inspired my Medium article
     //   // https://medium.com/@dominicfholmes/generating-qr-codes-in-swift-4-b5dacc75727c
     //   let mystring = "hello world";
     //   let data = mystring.data(using: String.Encoding.ascii);
     //   guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
     //       return;
     //   }
     //   qrFilter.setValue(data, forKey: "inputMessage");
     //
     //   guard let qrImage = qrFilter.outputImage else {
     //       return;
     //   }
     //
     //   let transform = CGAffineTransform(scaleX: 10, y: 10);
     //   let scaledImg = qrImage.transformed(by: transform)
     //
     //   qrImageView.image = UIImage(ciImage: scaledImg);
    }


    @IBAction func exportTapped(_ sender: Any) {
        Code.shareQr(vc: self, qrImage: self.qrImageView.image!, closure: {()})
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func BackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
