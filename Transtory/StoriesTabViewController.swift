//
//  StoriesTabViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit
import AVFoundation

class StoriesTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {

    var storiesTableViewController:UITableViewController = UITableViewController()
    var stories:[PFObject] = []
    var storiesImages:[[UIImage]] = []
    var storiesImagesLoaded:[Bool] = []
    var temporaryStoriesImages:[[UIImage]] = []
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(self.storiesTableViewController)
        self.navigationItem.title = "Transtories"
//        var profileButton = UIBarButtonItem(image: UIImage(named: "profileIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: "profileButtonTapped")
        
        var profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "profileButtonTapped")
        self.navigationItem.leftBarButtonItem = profileButton
        
        var newStoryButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStoryButtonTapped")
        self.navigationItem.rightBarButtonItem = newStoryButton
        
        self.storiesTableViewController.refreshControl = UIRefreshControl()
        self.storiesTableViewController.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        self.storiesTableViewController.tableView.delegate = self
        self.storiesTableViewController.tableView.dataSource = self
        self.storiesTableViewController.tableView.rowHeight = UITableViewAutomaticDimension
        self.storiesTableViewController.tableView.registerClass(StoryTableViewCell.self, forCellReuseIdentifier: "StoryTableViewCell")
        self.storiesTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.storiesTableViewController.refreshControl?.addTarget(self, action: "loadNewStories", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.storiesTableViewController.tableView)
        self.loadStories("")
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:StoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("StoryTableViewCell") as! StoryTableViewCell
        var story = self.stories[indexPath.row]
        cell.usernameLabel.text = (story["author"] as! PFUser).username
        cell.timeAgoLabel.text = story.createdAt?.timeAgoSinceNow().lowercaseString
        cell.storyTextLabel.text = story["storyText"] as? String
        var imagesArray = self.storiesImages[indexPath.row]
        if imagesArray.count > 0{
            cell.storyImageView.image = imagesArray[0]
        }
//        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "storyImagePanned:")
//        cell.storyImageView.addGestureRecognizer(panGestureRecognizer)

        var swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "storyImageSwipedRight:")
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        cell.storyImageView.addGestureRecognizer(swipeRightGestureRecognizer)

        var swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "storyImageSwipedLeft:")
        swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        cell.storyImageView.addGestureRecognizer(swipeLeftGestureRecognizer)
        
//        var longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "storyImageLongPressed:")
//        cell.storyImageView.addGestureRecognizer(longPressGestureRecognizer)
        
        if story["storyAudio"] != nil{
            var playStoryAudioTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "playAudioButtonPressed:")
            cell.playStoryAudioButton.addGestureRecognizer(playStoryAudioTapGestureRecognizer)
            cell.playStoryAudioButton.hidden = false
        }
        else{
            cell.playStoryAudioButton.hidden = true
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.width + 100
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (!self.storiesImagesLoaded[indexPath.row]){
//            var imagesRelation:PFRelation = self.stories[indexPath.row].relationForKey("storyImages")
//            var imagesQuery:PFQuery = imagesRelation.query()!
//            imagesQuery.findObjectsInBackgroundWithBlock({
//                (objects, error) -> Void in
//                if error == nil{
//                    var imageArray:[UIImage] = []
//                    println(objects!.count)
//                    for object in objects as! [PFObject]{
//                        var imageFile:PFFile = object["imageFile"] as! PFFile
//                        imageFile.getDataInBackgroundWithBlock({
//                            (data, error) -> Void in
//                            if error == nil{
//                                var image = UIImage(data: data!)
//                                var finalImage = UIImage(CGImage: image!.CGImage, scale: UIScreen.mainScreen().scale, orientation: UIImageOrientation.LeftMirrored)
//                                imageArray.append(finalImage!)
//                                if object == (objects as! [PFObject]).last{
//                                    self.storiesImages.insertObject(imageArray, atIndex: indexPath.row)
//                                    self.storiesImagesLoaded.insert(true, atIndex: indexPath.row)
//                                    self.storiesTableViewController.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//                                }
//                            }
//                            else{
//                                println("failed")
//                            }
//                        })
//                    }
//                }
//            })
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func profileButtonTapped(){
        println("Profile Button Tapped")
        self.performSegueWithIdentifier("showProfile", sender: self)
    }

    func newStoryButtonTapped(){
        println("New Story Button Tapped")
        self.performSegueWithIdentifier("showNewStory", sender: self)
    }

    func loadStories(context:String){
        println("load stories")
        self.storiesTableViewController.refreshControl?.beginRefreshing()
        var storyQuery = PFQuery(className: "Story")
        storyQuery.limit = 10
        storyQuery.orderByDescending("createdAt")
        if context == "old"{
            if !self.stories.isEmpty{
                storyQuery.whereKey("createdAt", lessThan: (self.stories.last as PFObject!).createdAt!)
            }
        }
        else if context == "new"{
            if !self.stories.isEmpty{
                storyQuery.whereKey("createdAt", greaterThan: (self.stories.first as PFObject!).createdAt!)
            }
        }
        storyQuery.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil{
                var story = (objects as! [PFObject]).first
                self.temporaryStoriesImages.removeAll(keepCapacity: false)
                self.temporaryStoriesImages = Array<[UIImage]>(count: objects!.count, repeatedValue: [])
                if context == "old"{
                    self.stories.extend(objects as! [PFObject])
                }
                else if context == "new"{
                    println("NEW")
                    self.stories.splice(objects as! [PFObject], atIndex: 0)
                }
                else{
                    self.stories = objects as! [PFObject]
                }
                self.loadStoryImages(story!, stories: objects as! [PFObject], context:context)
            }
            else{
                println("find operation failed")
            }
        })
    }
    
    func loadStoryImages(story:PFObject, stories:[PFObject], context:String){
        println("load images")
        var imagesRelation:PFRelation = story.relationForKey("storyImages")
        var imagesQuery:PFQuery = imagesRelation.query()!
        imagesQuery.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil{
                if story == stories.last{
                    
                }
                else{
                    var indexOfStoryToLoadImagesFor = find(stories, story)! + 1
                    self.loadStoryImages(stories[indexOfStoryToLoadImagesFor], stories: stories, context:context)
                }
                var object = (objects as! [PFObject]).first
                var storyIndex = find(objects as! [PFObject], object!)
                self.loadImageDataFromObject(object!, objects: objects as! [PFObject], storyIndex: storyIndex!, context:context)
            }
            else{
                
            }
        })

    }
    
    
    func loadImageDataFromObject(object:PFObject, objects:[PFObject], storyIndex:Int, context:String){
        println("load images data")
        var imageFile:PFFile = object["imageFile"] as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            (data, error) -> Void in
            if error == nil{
                var image = UIImage(data: data!)
                var finalImage = UIImage(CGImage: image!.CGImage, scale: UIScreen.mainScreen().scale, orientation: UIImageOrientation.LeftMirrored)
                self.temporaryStoriesImages[storyIndex].append(finalImage!)
//                println(self.temporaryStoriesImages[storyIndex])
                if object == objects.last{
//                    self.storiesTableViewController.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//                    println(self.temporaryStoriesImages)

                    if context == "old"{
                        self.storiesImages.extend(self.temporaryStoriesImages)
                    }
                    else if context == "new"{
                        println("NEW")
                        self.storiesImages.splice(self.temporaryStoriesImages, atIndex: 0)
                    }
                    else{
                        self.storiesImages.extend(self.temporaryStoriesImages)
                    }
                    self.storiesTableViewController.refreshControl?.endRefreshing()
                    self.storiesTableViewController.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)

                }
                else{
                    var indexOfImageToLoad = find(objects, object)! + 1
                    self.loadImageDataFromObject(objects[indexOfImageToLoad], objects: objects, storyIndex:storyIndex, context:context)
                }
            }
            else{
                println("failed")
            }
        })

    }
    
    func storyImagePanned(sender:UIPanGestureRecognizer){
        println("panned!")
        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
        var storyImageView = sender.view as! UIImageView
        let translation = sender.translationInView(self.view)
        var screenWidth = UIScreen.mainScreen().bounds.width
        var imageArray = self.storiesImages[currentIndexPath.row]
        println(imageArray)
        var gap = Int((UIScreen.mainScreen().bounds.width)) / imageArray.count
        var imageNumber = abs(Int(translation.x)) / gap
        println("gap: \(gap); imageNumber:\(imageNumber); translation:\(translation.x)")
        storyImageView.image = imageArray[imageNumber] as UIImage
    }
    
    func storyImageSwipedRight(sender:UISwipeGestureRecognizer){
        println("Story Image Swiped Right")

        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
        var storyImageView = sender.view as! UIImageView
        var imageArray = self.storiesImages[currentIndexPath.row]
        var currentImageIndex = find(imageArray, storyImageView.image!)!
        if currentImageIndex == imageArray.count - 1{
            storyImageView.image = imageArray[0]
        }
        else{
            storyImageView.image = imageArray[currentImageIndex + 1]
        }
    }

    func storyImageSwipedLeft(sender:UISwipeGestureRecognizer){
        println("Story Image Swiped Left")
        
        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
        var storyImageView = sender.view as! UIImageView
        var imageArray = self.storiesImages[currentIndexPath.row]
        var currentImageIndex = find(imageArray, storyImageView.image!)!
        if currentImageIndex == 0{
            storyImageView.image = imageArray.last
        }
        else{
            storyImageView.image = imageArray[currentImageIndex - 1]
        }
    }

    
    func playAudioButtonPressed(sender:UITapGestureRecognizer){
        println("Play Audio Button Pressed")
        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
        var parseAudio:PFFile = self.stories[currentIndexPath!.row]["storyAudio"] as! PFFile
        var audioData:NSData!
        parseAudio.getDataInBackgroundWithBlock({
            (data, error) -> Void in
            if error == nil{
                audioData = data!
                self.play(audioData)
            }
            else{
            
            }
        })

    }
    
//    func storyImageLongPressed(sender:UILongPressGestureRecognizer){
//        println("Story Image Long-Pressed")
//        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
//        var currentCell = self.storiesTableViewController.tableView.cellForRowAtIndexPath(currentIndexPath) as! StoryTableViewCell
//    }
    
    func play(audioData:NSData!) {
        println("playing")
        var error: NSError?
        // recorder might be nil
        // self.player = AVAudioPlayer(contentsOfURL: recorder.url, error: &error)
        if audioData != nil{
            self.audioPlayer = AVAudioPlayer(data: audioData, error: &error)
            println("audio player initialized")
        }
        if self.audioPlayer == nil {
            if let e = error {
                println(e.localizedDescription)
                println("audio player not initialized")
            }
        }
        else{
            println("audio player initialized and attempted to play")
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

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("end playing")
        self.audioPlayer = nil
    }
    
    func storyImageTapped(){
        println("tapped")
    }
    
    func loadNewStories(){
        self.loadStories("")
    }

}
