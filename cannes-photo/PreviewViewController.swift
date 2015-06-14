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

    @IBOutlet weak var overlayTextInput: UITextField!
    @IBOutlet weak var overlayLabel: UILabel!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageContainer: UIView!

    @IBOutlet weak var flickrInput: UITextField!
    @IBOutlet weak var flickrHandles: UILabel!
    @IBOutlet weak var flickrButton: UIButton!
    
    @IBOutlet weak var tumblrInput: UITextField!
    @IBOutlet weak var tumblrHandles: UILabel!
    @IBOutlet weak var tumblrButton: UIButton!
    
    @IBOutlet weak var linkedinInput: UITextField!
    @IBOutlet weak var linkedinHandles: UILabel!
    @IBOutlet weak var linkedinButton: UIButton!
    
    @IBOutlet weak var facebookInput: UITextField!
    @IBOutlet weak var facebookHandles: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var twitterInput: UITextField!
    @IBOutlet weak var twitterHandles: UILabel!
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var printImage: UIImageView!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var printOnly: UISwitch!
    
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.contentMode = UIViewContentMode.ScaleAspectFill
        selectedImageView.clipsToBounds =  true
        selectedImageView.image = selectedImage
    }

    @IBAction func onClickCheckButton(sender: UIButton) {
        switch sender {
        case flickrButton:
            updateHandles(flickrInput)
        case tumblrButton:
            updateHandles(tumblrInput)
        case linkedinButton:
            updateHandles(linkedinInput)
        case facebookButton:
            updateHandles(facebookInput)
        case twitterButton:
            updateHandles(twitterInput)
        default:break;
        }
    }

    @IBAction func editOverlayText(sender: AnyObject) {
        overlayLabel.text = overlayTextInput.text
    }
 
    @IBAction func didEndOnExit(sender: UITextField) {
        sender.resignFirstResponder()
        updateHandles(sender)
    }
    
    @IBAction func touchUpInsidePrint(sender: AnyObject) {
        println("Print!")
        
        UIGraphicsBeginImageContext(selectedImageContainer.frame.size)
        selectedImageContainer.drawViewHierarchyInRect(selectedImageContainer.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.printImage.image = image;
        
        let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var filePathToWrite = "\(paths)/SaveFile.png"
        var imageData: NSData = UIImagePNGRepresentation(selectedImage)
        fileManager.createFileAtPath(filePathToWrite, contents: imageData, attributes: nil)
        var getImagePath = paths.stringByAppendingPathComponent("SaveFile.png")
        
//        if fileManager.fileExistsAtPath(getImagePath) {
//            println("FILE AVAILABLE");
//            var imageis: UIImage = UIImage(contentsOfFile: getImagePath)!
//            let data: NSData = UIImagePNGRepresentation(imageis)
//        } else {
//            println("FILE NOT AVAILABLE")
//        }
        
//        let task = HTTPTask()
//        var fileUrl = NSURL(fileURLWithPath: getImagePath)!
//        task.upload("http://192.168.1.120:1337/cannes/photobooth",
//            method: .POST,
//            parameters: ["aParam": "aValue", "file": HTTPUpload(fileUrl: fileUrl)],
//            progress: { (value: Double) in
//                println("progress: \(value)")
//            },
//            completionHandler: { (response: HTTPResponse) in
//                if let err = response.error {
//                    println("error: \(err.localizedDescription)")
//                    return //also notify app of failure as needed
//                }
//                if let data = response.responseObject as? NSData {
//                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("response: \(str!)") //prints the response
//                }
//            }
//        )
    }

    func updateHandles(textField:UITextField) {
        switch textField {
        case flickrInput:
            flickrHandles.text = flickrHandles.text?.stringByAppendingString("\(flickrInput.text),")
        case tumblrInput:
            tumblrHandles.text = tumblrHandles.text?.stringByAppendingString("\(tumblrInput.text),")
        case linkedinInput:
            linkedinHandles.text = linkedinHandles.text?.stringByAppendingString("\(linkedinInput.text),")
        case facebookInput:
            facebookHandles.text = facebookHandles.text?.stringByAppendingString("\(facebookInput.text),")
        case twitterInput:
            twitterHandles.text = twitterHandles.text?.stringByAppendingString("\(twitterInput.text),")
        default:break;
        }
        textField.text = ""
    }
}
