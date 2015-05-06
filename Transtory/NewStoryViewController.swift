//
//  NewStoryViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit
import AVFoundation

class NewStoryViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var containingScrollView:TPKeyboardAvoidingScrollView!
    
    var capturedImagesCollectionView:UICollectionView!
    var cameraPreviewView:UIView!
    var takePhotoButton:UIButton!
    var importPhotoButton:UIButton!
    var recordAudioButton:UIButton!
    var playAudioButton:UIButton!
    var storyTextView:GCPlaceholderTextView!
    
    var captureSession:AVCaptureSession?
    var stillImageOutput:AVCaptureStillImageOutput?
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    var imageArray:NSMutableArray = NSMutableArray()
    var imagePFObjectArray:NSMutableArray = NSMutableArray()
    
    var imagePicker:SHUImagePicker!
    
    var soundFileURL:NSURL!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Transtory"
        
        var dismissButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissButtonTapped")
        self.navigationItem.leftBarButtonItem = dismissButton
        
        var publishButton = UIBarButtonItem(title: "Publish", style: UIBarButtonItemStyle.Done, target: self, action: "publishButtonTapped")
        publishButton.enabled = false
        self.navigationItem.rightBarButtonItem = publishButton
        
        self.containingScrollView = TPKeyboardAvoidingScrollView(frame: self.view.frame)
        self.containingScrollView.backgroundColor = UIColor.whiteColor()
        self.containingScrollView.alwaysBounceVertical = false
        self.view = self.containingScrollView
        
        self.cameraPreviewView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
        self.cameraPreviewView.backgroundColor = UIColor(white: 0.8, alpha: 1)
        self.containingScrollView.addSubview(self.cameraPreviewView)
        
        self.takePhotoButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.takePhotoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.takePhotoButton.frame = CGRectZero
        self.takePhotoButton.setTitle("Take Photo", forState: UIControlState.Normal)
        self.takePhotoButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.takePhotoButton.addTarget(self, action: "takePhotoButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.containingScrollView.addSubview(self.takePhotoButton)
        
        self.importPhotoButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.importPhotoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.importPhotoButton.frame = CGRectZero
        self.importPhotoButton.setTitle("Import Photo", forState: UIControlState.Normal)
        self.importPhotoButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.importPhotoButton.addTarget(self, action: "importPhotoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.containingScrollView.addSubview(self.importPhotoButton)
        
        self.recordAudioButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.recordAudioButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.recordAudioButton.frame = CGRectZero
        self.recordAudioButton.setTitle("Record Audio", forState: UIControlState.Normal)
        self.recordAudioButton.addTarget(self, action: "recordAudioButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.containingScrollView.addSubview(self.recordAudioButton)
        
        self.playAudioButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.playAudioButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width - 59, 15, 44, 44)
        self.playAudioButton.backgroundColor = UIColor.blackColor()
        self.playAudioButton.setTitle("Play Audio", forState: UIControlState.Normal)
        self.playAudioButton.addTarget(self, action: "playAudioButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.playAudioButton.hidden = true
        self.playAudioButton.enabled = false
        self.containingScrollView.addSubview(self.playAudioButton)

        
        var takePhotoButtonHConstraint = NSLayoutConstraint(item: self.takePhotoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.containingScrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(takePhotoButtonHConstraint)
        
        var importPhotoButtonHConstraint = NSLayoutConstraint(item: self.importPhotoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.containingScrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 0.4, constant: 0)
        self.view.addConstraint(importPhotoButtonHConstraint)
        
        var recordAudioButtonHConstraint = NSLayoutConstraint(item: self.recordAudioButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.containingScrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.6, constant: 0)
        self.view.addConstraint(recordAudioButtonHConstraint)

        
        var viewsDictionary = ["cameraPreviewView":self.cameraPreviewView, "takePhotoButton":self.takePhotoButton, "importPhotoButton":self.importPhotoButton, "recordAudioButton":self.recordAudioButton]
        var metricsDictionary = ["sideMargin":7.5, "textViewHeight":UIScreen.mainScreen().bounds.height/8]
        
        var takePhotoButtonVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[takePhotoButton]-30-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.containingScrollView.addConstraints(takePhotoButtonVConstraints)
        
        var importPhotoButtonVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[importPhotoButton]-30-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.containingScrollView.addConstraints(importPhotoButtonVConstraints)

        var recordAudioButtonVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[recordAudioButton]-30-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.containingScrollView.addConstraints(recordAudioButtonVConstraints)
        
        self.storyTextView = GCPlaceholderTextView(frame: CGRectZero)
        self.storyTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.storyTextView.returnKeyType = UIReturnKeyType.Done
//        self.storyTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.storyTextView.font = UIFont(name: "HelveticaNeue", size: 15.0)
//        self.storyTextView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.storyTextView.placeholder = "What's your story?"
        self.storyTextView.delegate = self
        self.containingScrollView.addSubview(self.storyTextView)

        var textViewViewsDictionary = ["storyTextView":self.storyTextView, "cameraPreviewView":self.cameraPreviewView, "takePhotoButton":self.takePhotoButton]

        var storyTextViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[storyTextView]-15-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: textViewViewsDictionary)
        self.containingScrollView.addConstraints(storyTextViewHorizontalConstraints)
        
        var storyTextViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[cameraPreviewView]-20-[storyTextView(textViewHeight)]-30-[takePhotoButton]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metricsDictionary, views: textViewViewsDictionary)
        self.containingScrollView.addConstraints(storyTextViewVerticalConstraints)

        self.imagePicker = SHUImagePicker()
        
        self.capturedImagesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.capturedImagesCollectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.capturedImagesCollectionView.backgroundColor = nil
        self.capturedImagesCollectionView.dataSource = self
        self.capturedImagesCollectionView.delegate = self
        self.capturedImagesCollectionView.alwaysBounceHorizontal = true
        self.capturedImagesCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.capturedImagesCollectionView.registerClass(CapturedImageCollectionViewCell.self, forCellWithReuseIdentifier: "CapturedImageCollectionViewCell")
        var layout = self.capturedImagesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(44, 44)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.containingScrollView.addSubview(self.capturedImagesCollectionView)
        
        var collectionViewViewsDictionary = ["capturedImagesCollectionView":self.capturedImagesCollectionView]
        var collectionViewMetricsDictionary = ["sideMargin":15, "topMargin":UIScreen.mainScreen().bounds.width - 74]
        
        var collectionViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[capturedImagesCollectionView]|", options: NSLayoutFormatOptions(0), metrics: collectionViewMetricsDictionary, views: collectionViewViewsDictionary)
        var collectionViewVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-topMargin-[capturedImagesCollectionView(74)]", options: NSLayoutFormatOptions(0), metrics: collectionViewMetricsDictionary, views: collectionViewViewsDictionary)
        self.containingScrollView.addConstraints(collectionViewHConstraints)
        self.containingScrollView.addConstraints(collectionViewVConstraints)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:CapturedImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CapturedImageCollectionViewCell", forIndexPath: indexPath) as! CapturedImageCollectionViewCell
        cell.capturedImageImageView.image = self.imageArray[indexPath.row] as? UIImage
        return cell
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.captureSession = AVCaptureSession()
        self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        var cameras:[AVCaptureDevice] = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        var frontCamera:AVCaptureDevice!
        for camera:AVCaptureDevice in cameras{
            if camera.position == AVCaptureDevicePosition.Front{
            }
            frontCamera = camera
        }
        
        var error: NSError?
        var input = AVCaptureDeviceInput(device: frontCamera, error: &error)
        
        if error == nil && captureSession!.canAddInput(input){
            captureSession!.addInput(input)
            
            self.stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

            if captureSession!.canAddOutput(stillImageOutput){
                captureSession!.addOutput(stillImageOutput)
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                self.cameraPreviewView.layer.addSublayer(previewLayer)
                
                captureSession?.startRunning()
            }
        }
        

    }
    
    func setupRecorder(){
        var audioError: NSError?
        
        var format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        var currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        println(currentFileName)
        
        var dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var docsDir: AnyObject = dirPaths[0]
        var soundFilePath = docsDir.stringByAppendingPathComponent(currentFileName)
        self.soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        var recordSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        
        self.audioRecorder = AVAudioRecorder(URL: soundFileURL, settings: recordSettings as [NSObject : AnyObject], error: &audioError)
        if let e = audioError {
            println(e.localizedDescription)
        } else {
            self.audioRecorder.delegate = self
            self.audioRecorder.meteringEnabled = true
            self.audioRecorder.prepareToRecord()
        }

    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    println("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.audioRecorder.record()
                } else {
                    println("Permission to record not granted")
                }
            })
        } else {
            println("requestRecordPermission unrecognized")
        }
    }

    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayback, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.previewLayer!.frame = self.cameraPreviewView.bounds
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.storyTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissButtonTapped(){
        println("Dismiss Button Tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func publishButtonTapped(){
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
        println("Publish Button Tapped")
        
        // Create array of image pfobjects.
        for image in self.imageArray{
            var imageObject = PFObject(className: "Image")
            imageObject["author"] = PFUser.currentUser()
            imageObject["imageFile"] = PFFile(data:UIImagePNGRepresentation(image as! UIImage))
            self.imagePFObjectArray.addObject(imageObject)
        }
        self.saveImageObjectOnParse(self.imagePFObjectArray.firstObject as! PFObject)
        
        // Call save image pfobject function inside saveObjectInBackground, passing in current count and image pfobjects array. Check if saved object is last in array,
        
        // If true, save story object
        
        // draw story -> image relation
        
        // When done, dismiss view controller.
        
//        var newStory = PFObject(className: "Story")
//        newStory["author"] = PFUser.currentUser()
//        if self.storyTextView.text == nil{
//            newStory["storyText"] = ""
//        }
//        else{
//            newStory["storyText"] = self.storyTextView.text
//        }
//        newStory.saveInBackgroundWithBlock({
//            (success, error) -> Void in
//            if error == nil{
//                for image in self.imageArray{
//                    var newImage = PFObject(className: "Image")
//                    newImage["author"] = PFUser.currentUser()
//                    var imageData = UIImagePNGRepresentation(image as! UIImage)
//                    newImage["imageFile"] = PFFile(data: imageData)
//                    self.imagePFObjectArray.addObject(newImage)
//                    newImage.saveInBackgroundWithBlock({
//                        (success, error) -> Void in
//                        if error == nil{
//                            var storiesRelation:PFRelation = newImage.relationForKey("stories")
//                            storiesRelation.addObject(newStory)
//                            newImage.saveInBackgroundWithBlock({
//                                (success, error) -> Void in
//                                if error == nil{
//                                    println("story relation saved")
//                                    if image as! UIImage == self.imageArray.lastObject as! UIImage{
//                                        if self.soundFileURL != nil{
//                                            var audioFile = NSData(contentsOfURL: self.soundFileURL)
//                                            newStory["storyAudio"] = PFFile(data: audioFile!)
//                                        }
//                                        newStory.saveInBackgroundWithBlock({
//                                            (success, error) -> Void in
//                                            if error == nil{
//                                                println("saved!")
//                                                var imagesRelation:PFRelation = newStory.relationForKey("storyImages")
//                                                for imagePFObject in self.imagePFObjectArray{
//                                                    imagesRelation.addObject(imagePFObject as! PFObject)
//                                                }
//                                                newStory.saveInBackgroundWithBlock({
//                                                    (success, error) -> Void in
//                                                    if error == nil{
//                                                        println("image relation saved")
//                                                        self.dismissViewControllerAnimated(true, completion: nil)
//                                                    }
//                                                    else{
//                                                        println()
//                                                    }
//                                                })
//                                                
//                                                
//                                            }
//                                            else{
//                                                println(error)
//                                            }
//                                            
//                                        })
//                                        println(newStory)
//                                    }
//                                }
//                                else{
//                                }
//                            })
//                        }
//                        else{
//                        }
//                    })
//                    
//                }
//            }
//            else{
//            
//            }
//        })

    }
    
    func saveImageObjectOnParse(imageObject:PFObject){
        imageObject.saveInBackgroundWithBlock({
            (success, error) -> Void in
            if error == nil{
                var indexOfCurrentImageObject = self.imagePFObjectArray.indexOfObject(imageObject)
                if indexOfCurrentImageObject == self.imagePFObjectArray.count - 1{
                    self.saveStoryObjectOnParse()
                }
                else{
                    self.saveImageObjectOnParse(self.imagePFObjectArray[++indexOfCurrentImageObject] as! PFObject)
                }
            }
            else{
                println("image object save failed: \(error)")
            }
        })
    }
    
    func saveStoryObjectOnParse(){
        var storyObject = PFObject(className: "Story")
        storyObject["author"] = PFUser.currentUser()
        storyObject["storyText"] = self.storyTextView.text
        storyObject["storyAudio"] = PFFile(data: NSData(contentsOfURL: self.soundFileURL)!)
        var imagesRelation:PFRelation = storyObject.relationForKey("storyImages")
        for imageObject in self.imagePFObjectArray{
            imagesRelation.addObject(imageObject as! PFObject)
        }
        storyObject.saveInBackgroundWithBlock({
            (success, error) -> Void in
            if error == nil{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                println("story object save failed: \(error)")
            }
        })
    }
    
    func takePhotoButtonPressed(){
        println("Take Photo Button Pressed")
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    var scale = UIScreen.mainScreen().scale
                    var image = UIImage(CGImage: cgImageRef, scale: scale, orientation: UIImageOrientation.LeftMirrored)
                    println(image!.size)
                    var croppedImage = image!.crop(CGRectMake((128 / 667 * 480 * scale), 0, 480 * scale, 480 * scale))
                    var finalImage = UIImage(CGImage: croppedImage!.CGImage, scale: scale, orientation: UIImageOrientation.LeftMirrored)
                    println(scale)
                    println(finalImage!.size)
                    self.imageArray.addObject(finalImage!)
                    self.capturedImagesCollectionView.reloadSections(NSIndexSet(index: 0))
                    if self.imageArray.count > 0{
                        self.navigationItem.rightBarButtonItem?.enabled = true
                        self.navigationItem.leftBarButtonItem?.title = "Discard"
                    }
                    else{
                        self.navigationItem.rightBarButtonItem?.enabled = false
                        self.navigationItem.leftBarButtonItem?.title = "Cancel"
                    }
                }
            })
        }

    }
    
    func play() {
        println("playing")
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        if soundFileURL != nil{
            self.audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL!, error: &error)
        }
        if self.audioPlayer == nil {
            if let e = error {
                println(e.localizedDescription)
            }
        }
        else{
            self.audioPlayer.delegate = self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 1.0
            if self.audioPlayer.playing{
                self.audioPlayer.pause()
            }
            else{
                self.audioPlayer.play()
            }
        }
    }

    
    func importPhotoButtonPressed(sender:UIButton){
        println("Import Photo Button Pressed")
        self.imagePicker.showPickerInViewController(self, forSourceType: UIImagePickerControllerSourceType.PhotoLibrary, cropSize: CGSizeMake(300, 300), fromView: sender, withCallback:{(var croppedImage) in
            self.imageArray.addObject(croppedImage)
            self.capturedImagesCollectionView.reloadSections(NSIndexSet(index: 0))
            if self.imageArray.count > 0{
                self.navigationItem.rightBarButtonItem?.enabled = true
                self.navigationItem.leftBarButtonItem?.title = "Discard"
            }
            else{
                self.navigationItem.rightBarButtonItem?.enabled = false
                self.navigationItem.leftBarButtonItem?.title = "Cancel"
            }
        })
            // callback here
    }
    
    func playAudioButtonPressed(){
        println("Play Audio Button Pressed")
            self.play()
    }
    
    func recordAudioButtonPressed(){
        println("Record Audio Button Pressed")
        if self.audioPlayer != nil && self.audioPlayer.playing {
            self.audioPlayer.stop()
        }
        
        if self.audioRecorder == nil {
            println("recording. recorder nil")
            self.recordAudioButton.setTitle("Stop", forState:.Normal)
//            playButton.enabled = false
//            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if self.audioRecorder != nil && self.audioRecorder.recording {
            println("pausing")
            self.audioRecorder.stop()
            println(self.audioRecorder.description)
            self.recordAudioButton.setTitle("Record Audio", forState:.Normal)
            
        } else {
            println("recording")
            self.recordAudioButton.setTitle("Stop", forState:.Normal)
//            playButton.enabled = false
//            stopButton.enabled = true
//            recorder.record()
            recordWithPermission(false)
        }
    }

    
    func textViewDidEndEditing(textView: UITextView) {
        self.containingScrollView.setContentOffset(CGPointMake(0, -64), animated: true)
        println("text view ended")
    }
    

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        else{
            return true
        }
    }
}




// MARK: AVAudioRecorderDelegate
extension NewStoryViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
        successfully flag: Bool) {
            println("finished recording \(flag)")
//            stopButton.enabled = false
//            playButton.enabled = true
            self.recordAudioButton.setTitle("Record Audio", forState:.Normal)
            
            // iOS8 and later
            var alert = UIAlertController(title: "Audio Recorder",
                message: "Finished Recording",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
                println("keep was tapped")
                self.playAudioButton.hidden = false
                self.playAudioButton.enabled = true
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
                println("delete was tapped")
                self.audioRecorder.deleteRecording()
            }))
            self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!,
        error: NSError!) {
            println("\(error.localizedDescription)")
    }
}
