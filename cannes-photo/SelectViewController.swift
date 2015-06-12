//
//  SelectViewController.swift
//  cannes-photo
//
//  Created by Hsin Yi Huang on 6/11/15.
//  Copyright (c) 2015 Hsin Yi Huang. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController, UIScrollViewDelegate {
    
    //var imageCount: Int!
    var imageViewArray: [UIImageView]!
    var deviceSize: CGSize!
    var currentImageIndex: Int!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewArray = []
        deviceSize = self.view.frame.size
        leftButton.enabled = false
        currentImageIndex = 0
        
        
        for var i = 0; i < 5; i++ {
            var photoView = UIImageView()
            photoView.image = UIImage(named: "image\(i+1)")
            imageViewArray.append(photoView)
            
        }
        
      
        
        for var i = 0; i < imageViewArray.count; i++ {
            
            imageViewArray[i].frame.size = CGSize(width:820, height:580)
            imageViewArray[i].center = CGPoint(x: (deviceSize.width / CGFloat(2.0)) + (deviceSize.width * CGFloat(i)), y: scrollView.center.y)
            imageViewArray[i].contentMode = UIViewContentMode.ScaleAspectFill
            imageViewArray[i].clipsToBounds =  true
            println("image\(i+1)")
            
            scrollView.addSubview(imageViewArray[i])
            
        }
        
        //scrollView.delegate = self
        scrollView.contentSize.width = deviceSize.width * CGFloat(imageViewArray.count)
        scrollView.delegate = self
        
        
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scroll")
        checkArrow()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("end")
        currentImageIndex = Int(scrollView.contentOffset.x / deviceSize.width)
        checkArrow()
    }
    
    func checkArrow(){
        if scrollView.contentOffset.x < deviceSize.width {
            leftButton.enabled = false
        }
        else if scrollView.contentOffset.x > deviceSize.width * CGFloat(imageViewArray.count - 2){
            rightButton.enabled = false
        }
        else{
            leftButton.enabled = true
            rightButton.enabled = true
        }
        
    }
    
    
    
    
    
    @IBAction func onSelect(sender: AnyObject) {
        performSegueWithIdentifier("previewSegue", sender: nil)
    }
    
    
    
    
    @IBAction func onRetake(sender: AnyObject) {
        //go back to camera screen
    }
    
    
    
    @IBAction func onRightArrow(sender: AnyObject) {
        currentImageIndex = currentImageIndex + 1
        animateScrollView()
        
    }
    
    
    @IBAction func onLeftArrow(sender: AnyObject) {
        currentImageIndex = currentImageIndex - 1
        animateScrollView()
    }
    
    func animateScrollView(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollView.contentOffset.x  = CGFloat(self.currentImageIndex) * self.deviceSize.width
        })
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! PreviewViewController
        destinationViewController.selectedImage = imageViewArray[currentImageIndex].image
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
