//
//  PreviewViewController.swift
//  cannes-photo
//
//  Created by Hsin Yi Huang on 6/11/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit
import SwiftHTTP

class PreviewViewController: UIViewController, UITextViewDelegate {

    let SERVER_URL = "http://172.16.9.124:1337/cannes/photobooth"
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageContainer: UIView!
    
    @IBOutlet weak var printButton: UIButton!
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.contentMode = UIViewContentMode.ScaleAspectFill
        selectedImageView.clipsToBounds =  true
        selectedImageView.image = selectedImage
    }
    @IBAction func emailInputDidEndOnExit(sender: AnyObject) {
        self.resignFirstResponder();
    }
   
    @IBAction func touchUpInsidePrint(sender: AnyObject) {
        println("Print!")
        
        let emailRegex = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"

        if emailInput.text == "" {
            emailInput.attributedPlaceholder = NSAttributedString(string: emailInput.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(selectedImageContainer.frame.size, true, 1800 / selectedImageContainer.bounds.width)
        selectedImageContainer.drawViewHierarchyInRect(selectedImageContainer.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePathToWrite = "\(paths)/SaveFile.png"
        var imageData: NSData = UIImagePNGRepresentation(image)
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
        var getImagePath = paths.stringByAppendingPathComponent("SaveFile.png")
        
        var fileUrl = NSURL(fileURLWithPath: getImagePath)!
        
        let task = HTTPTask()
        var params = [String: AnyObject]();
            params["email"] = self.emailInput.text;
            params["photo"] = HTTPUpload(fileUrl: fileUrl);
        
        task.upload(SERVER_URL,
            method: .POST,
            parameters:  params,
            progress: { (value: Double) in
                println("progress: \(value)")
            },
            completionHandler: { (response: HTTPResponse) in
                if let err = response.error {
                    println("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                    
                }
                if let data = response.responseObject as? NSData {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("response: \(str!)") //prints the response
                }
            }
        )

        self.performSegueWithIdentifier("thankYouSegue", sender: nil)
    }
}
