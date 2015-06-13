//
//  ViewController.swift
//  Cannes Lions Photo Booth
//
//  Created by Brandon Dement on 6/11/15.
//  Copyright (c) 2015 Brandon Dement. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!

    @IBOutlet weak var capturedImage1: UIImageView!
    @IBOutlet weak var capturedImage2: UIImageView!
    @IBOutlet weak var capturedImage3: UIImageView!
    @IBOutlet weak var capturedImage4: UIImageView!
    @IBOutlet weak var capturedImage5: UIImageView!
    @IBOutlet weak var imagesBackground: UIView!

    let IMAGE_BORDER_COLOR = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
    let IMAGE_BORDER_WIDTH = CGFloat(2)
    
    var stillImageOutput: AVCaptureStillImageOutput?
    var selectedDevice: AVCaptureDevice?;
    let captureSession = AVCaptureSession();
    var previewLayer: AVCaptureVideoPreviewLayer?;
    var observer:NSObjectProtocol?;
    var err:NSError?;
    var videoConnection:AVCaptureConnection?;
    var photoId = 0;
    var photos = [UIImageView]();
    var countdown = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for image in [capturedImage1,capturedImage2,capturedImage3,capturedImage4,capturedImage5] {
            image.layer.borderColor = IMAGE_BORDER_COLOR;
            image.layer.borderWidth = IMAGE_BORDER_WIDTH;
        }
        
        selectedDevice = findCameraWithPosition(.Front);
        captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = cameraView.layer.frame;
        cameraView.layer.addSublayer(previewLayer)
        captureSession.addInput(AVCaptureDeviceInput(device: selectedDevice, error: &err));
        stillImageOutput = AVCaptureStillImageOutput();
        captureSession.addOutput(stillImageOutput);
        captureSession.startRunning();
        videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo);
        
        processOrientationNotifications();
    }
    
    @IBAction func didPressTakePhoto(sender: AnyObject) {
        
        startView.hidden = true;
        
        imagesBackground.hidden = false;
        countdownLabel.hidden = false;
        countdownLabel.text = "\(countdown)";
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("countdown:"), userInfo: nil, repeats: true);
    }
    
    @objc func countdown(timer:NSTimer) {
        countdown--;
        countdownLabel.text = "\(countdown)";
        
        if(countdown == 1){
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("takeNextPhoto:"), userInfo: nil, repeats: true);
        } else if (countdown == 0) {
            timer.invalidate();
            countdownLabel.hidden = true;
        }
    }
    
    
    @objc func takeNextPhoto(timer:NSTimer)
    {
        stillImageOutput!.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
            if (sampleBuffer != nil) {
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                
                var imageOrientation:UIImageOrientation;
                
                switch UIDevice.currentDevice().orientation {
                case .LandscapeLeft:
                    imageOrientation = UIImageOrientation.Down;
                case .LandscapeRight:
                    imageOrientation = UIImageOrientation.Up;
                default:
                    imageOrientation = UIImageOrientation.Up;
                    
                }
                
                var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: imageOrientation);
                self.photos.append(UIImageView(image:image));
                
                switch(self.photos.count) {
                case 1: self.capturedImage1.image = image;
                case 2: self.capturedImage2.image = image;
                case 3: self.capturedImage3.image = image;
                case 4: self.capturedImage4.image = image;
                case 5:
                    self.capturedImage5.image = image;
                    timer.invalidate();
                    self.performSegueWithIdentifier("reviewSegue", sender: self);
                    break;
                default:break;
                }

            }
        });
    }
    
    deinit {
        // Cleanup
        if observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(observer!);
        }
        
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findCameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo);
        for device in devices as! [AVCaptureDevice] {
            if(device.position == position) {
                println(device.hasMediaType(AVMediaTypeVideo))
                return device;
            }
        }
        
        return nil;
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepare")
        var destinationViewController = segue.destinationViewController as! SelectViewController
        println("photos \(photos.count)")
        destinationViewController.imageViewArray = [UIImageView]()
        destinationViewController.imageViewArray = self.photos
        println("image array count \(destinationViewController.imageViewArray.count)")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator);
        if let layer = previewLayer {
            layer.frame = CGRectMake(0,0,size.width, size.height);
        }
    }
    
    func processOrientationNotifications() {
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications();
        observer = NSNotificationCenter.defaultCenter().addObserverForName(UIDeviceOrientationDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self](notification: NSNotification!) -> Void in
            if let layer = self.previewLayer {
                switch UIDevice.currentDevice().orientation {
                case .LandscapeLeft:
                    layer.connection.videoOrientation = .LandscapeRight;
                case .LandscapeRight:
                    layer.connection.videoOrientation = .LandscapeLeft;
                default:
                    layer.connection.videoOrientation = layer.connection.videoOrientation;
                    
                }
            }
        }
    }
    
    
    
    @IBAction func didPressTakeAnother(sender: AnyObject) {
        captureSession.startRunning()
    }
    
    
    
    
}