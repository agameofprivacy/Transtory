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
    var storiesImages:NSMutableArray = NSMutableArray()
    var storiesImagesLoaded:[Bool] = []
    
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(self.storiesTableViewController)
        self.navigationItem.title = "Stories"
        
        var profileButton = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "profileButtonTapped")
        self.navigationItem.leftBarButtonItem = profileButton
        
        var newStoryButton = UIBarButtonItem(title: "New Story", style: UIBarButtonItemStyle.Plain, target: self, action: "newStoryButtonTapped")
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
        if self.storiesImagesLoaded[indexPath.row]{
            var imagesArray = self.storiesImages[indexPath.row] as! [UIImage]
            if imagesArray.count > 0{
                cell.storyImageView.image = imagesArray[0]
            }
        }
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "storyImageSwiped:")
        cell.storyImageView.addGestureRecognizer(panGestureRecognizer)
        println(story["storyAudio"])
        if story["storyAudio"] != nil{
            var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "playAudioButtonPressed:")
            cell.playStoryAudioButton.addGestureRecognizer(tapGestureRecognizer)
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
        return UIScreen.mainScreen().bounds.width + 80
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (!self.storiesImagesLoaded[indexPath.row]){
            var imagesRelation:PFRelation = self.stories[indexPath.row].relationForKey("storyImages")
            var imagesQuery:PFQuery = imagesRelation.query()!
            imagesQuery.findObjectsInBackgroundWithBlock({
                (objects, error) -> Void in
                if error == nil{
                    var imageArray:[UIImage] = []
                    println(objects!.count)
                    for object in objects as! [PFObject]{
                        var imageFile:PFFile = object["imageFile"] as! PFFile
                        imageFile.getDataInBackgroundWithBlock({
                            (data, error) -> Void in
                            if error == nil{
                                var image = UIImage(data: data!)
                                var finalImage = UIImage(CGImage: image!.CGImage, scale: UIScreen.mainScreen().scale, orientation: UIImageOrientation.LeftMirrored)
                                imageArray.append(finalImage!)
                                if object == (objects as! [PFObject]).last{
                                    self.storiesImages.insertObject(imageArray, atIndex: indexPath.row)
                                    self.storiesImagesLoaded.insert(true, atIndex: indexPath.row)
                                    self.storiesTableViewController.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                                }
                            }
                            else{
                                println("failed")
                            }
                        })
                    }
                }
            })
        }
    }
    
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

        self.storiesTableViewController.refreshControl?.beginRefreshing()
        var storyQuery = PFQuery(className: "Story")
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
                var boolArray:[Bool] = Array<Bool>(count: objects!.count, repeatedValue: false)
                var imageArrayArray:[[UIImage]] = Array<[UIImage]>(count: objects!.count, repeatedValue: [])
                if context == "old"{
                    self.stories.extend(objects as! [PFObject])
                    self.storiesImagesLoaded.extend(boolArray)
                    self.storiesImages.addObjectsFromArray(imageArrayArray)
                }
                else if context == "new"{
                    println("NEW")
                    self.stories.splice(objects as! [PFObject], atIndex: 0)
                    self.storiesImagesLoaded.splice(boolArray, atIndex: 0)
                    var tempArray = self.storiesImages.subarrayWithRange(NSMakeRange(0, self.storiesImages.count))
                    println(tempArray)
                    self.storiesImages.replaceObjectsInRange(NSMakeRange(0, objects!.count), withObjectsFromArray: imageArrayArray)

//                    self.storiesImages.replaceObjectsInRange(NSMakeRange(objects!.count, tempArray.count), withObjectsFromArray: tempArray)
                    println(self.storiesImages)

                }
                else{
                    self.stories = objects as! [PFObject]
                    self.storiesImagesLoaded = boolArray
//                    self.storiesImages.addObjectsFromArray(imageArrayArray)
                }
                println(self.stories)
                self.storiesTableViewController.refreshControl?.endRefreshing()
//                self.storiesTableViewController.tableView.reloadData()
                self.storiesTableViewController.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            else{
                println("find operation failed")
            }
        })
    }
    
    func storyImageSwiped(sender:UIPanGestureRecognizer){
        println("panned!")
        var currentIndexPath = self.storiesTableViewController.tableView.indexPathForRowAtPoint(sender.locationInView(self.storiesTableViewController.tableView)) as NSIndexPath!
        var storyImageView = sender.view as! UIImageView
        let translation = sender.translationInView(self.view)
        var screenWidth = UIScreen.mainScreen().bounds.width
        var imageArray = self.storiesImages[currentIndexPath.row] as! [UIImage]
        println(imageArray)
        var gap = Int((UIScreen.mainScreen().bounds.width)) / imageArray.count
        var imageNumber = abs(Int(translation.x)) / gap
        println("gap: \(gap); imageNumber:\(imageNumber); translation:\(translation.x)")
        storyImageView.image = imageArray[imageNumber] as UIImage
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
    
    
    func loadNewStories(){
        self.loadStories("")
    }

}
