//
//  PreviewViewController.swift
//  cannes-photo
//
//  Created by Hsin Yi Huang on 6/11/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    
    
    @IBOutlet weak var composeView: UIView!

    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selectedImage: UIImage!
    
    
    var profileViewOrigin: CGPoint!
    var statusViewOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.clipsToBounds = true
        statusTextView.delegate = self
        profileViewOrigin = profileView.frame.origin
        statusViewOrigin = statusView.frame.origin
        selectedImageView.image = selectedImage
        selectedImageView.contentMode = UIViewContentMode.ScaleAspectFill
        selectedImageView.clipsToBounds =  true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        moveUpField()
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        moveDownField()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
        moveDownField()
    }

    
    
    @IBAction func onEditingBegin(sender: AnyObject) {
        moveUpField()
    }
    
    

    
    @IBAction func onEditingEnd(sender: AnyObject) {
        moveDownField()
    }
    
    
    
    
    
    func moveUpField(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.composeView.frame.origin.y = -210
            
        })
    }
    
    func moveDownField(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.composeView.frame.origin.y = 0
          
        })
    }
    
    
    
    
    @IBAction func onPost(sender: AnyObject) {
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
    }
    
    
    
    
    
    
    
    
    
}
