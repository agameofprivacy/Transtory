//
//  ResourcesTabViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ResourcesTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var resourcesTableViewController:UITableViewController = UITableViewController()
    var resources:[PFObject] = []
    var currentGeoPoint:PFGeoPoint!
    var emergencyServiceProvider:PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.addChildViewController(self.resourcesTableViewController)
        self.resourcesTableViewController.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        self.resourcesTableViewController.tableView.delegate = self
        self.resourcesTableViewController.tableView.dataSource = self
        self.resourcesTableViewController.tableView.rowHeight = UITableViewAutomaticDimension
        self.resourcesTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.resourcesTableViewController.tableView.registerClass(ResourceTableViewCell.self, forCellReuseIdentifier: "ResourceTableViewCell")
        self.view.addSubview(self.resourcesTableViewController.tableView)
        
        
        self.navigationItem.title = "Resources"
        
        var locateButton = UIBarButtonItem(title: "Locate", style: UIBarButtonItemStyle.Plain, target: self, action: "locateButtonTapped")
        self.navigationItem.rightBarButtonItem = locateButton
        
        var categoriesButton = UIBarButtonItem(title: "Categories", style: UIBarButtonItemStyle.Plain, target: self, action: "categoriesButtonTapped")
        self.navigationItem.leftBarButtonItem = categoriesButton
        
        self.locateAndLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && !self.resources.isEmpty{
            var resource = self.resources[indexPath.row] as PFObject
            var cell = tableView.dequeueReusableCellWithIdentifier("ResourceTableViewCell") as! ResourceTableViewCell
            cell.nameLabel.text = resource["name"] as? String
            cell.descriptionLabel.text = resource["description"] as? String
            cell.logoImageView.image = UIImage(named: (resource["logoImage"] as? String)!)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return self.resources.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && self.emergencyServiceProvider != nil{
            var view = UIView()
            view.backgroundColor = UIColor(white: 0.95, alpha: 1)
            var nameLabel = UILabel(frame: CGRectZero)
            nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
            nameLabel.textAlignment = NSTextAlignment.Center
            nameLabel.numberOfLines = 1
            nameLabel.text = self.emergencyServiceProvider["name"] as? String
            view.addSubview(nameLabel)
            
            var descriptionLabel = UILabel(frame: CGRectZero)
            descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            descriptionLabel.textAlignment = NSTextAlignment.Left
            descriptionLabel.numberOfLines = 0
            descriptionLabel.preferredMaxLayoutWidth = (UIScreen.mainScreen().bounds.width - 30) / 2
            descriptionLabel.text = self.emergencyServiceProvider["description"] as? String
            view.addSubview(descriptionLabel)
            
            var callButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            callButton.frame = CGRectZero
            callButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            callButton.setTitle("Call Now", forState: UIControlState.Normal)
            callButton.layer.borderColor = UIColor(white: 0.85, alpha: 1).CGColor
            callButton.layer.borderWidth = 0.75
            callButton.layer.cornerRadius = 8
            view.addSubview(callButton)
            
            var metricsDictionary = ["sideMargin":15]
            var viewsDictionary = ["nameLabel":nameLabel, "descriptionLabel":descriptionLabel, "callButton":callButton]
            
            var horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[nameLabel]-sideMargin-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            view.addConstraints(horizontalConstraints)

            var verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sideMargin-[nameLabel]-7.5-[descriptionLabel(50)]-15-[callButton]", options: NSLayoutFormatOptions.AlignAllLeft | NSLayoutFormatOptions.AlignAllRight, metrics: metricsDictionary, views: viewsDictionary)
            view.addConstraints(verticalConstraints)
            return view
        }
        else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 150
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }

    func locateButtonTapped(){
        println("Locate Button Tapped")
        self.locateAndLoad()
    }
    
    func categoriesButtonTapped(){
        println("Categories Button Tapped")
        self.performSegueWithIdentifier("showCategories", sender: self)
    }

    
    func locateAndLoad(){
        println("hello")
        PFGeoPoint.geoPointForCurrentLocationInBackground({
            (geoPoint, error) -> Void in
            if error == nil {
                println("hello")
                self.currentGeoPoint = geoPoint
                println(self.currentGeoPoint)
                // do something with the new geoPoint
                var emergencyServiceProviderQuery = PFQuery(className: "Organization")
                emergencyServiceProviderQuery.whereKey("type", equalTo: "crisis-handling")
                emergencyServiceProviderQuery.limit = 1
                emergencyServiceProviderQuery.findObjectsInBackgroundWithBlock{
                    (objects, error) -> Void in
                    if error == nil{
                        if (objects as! [PFObject]).count > 0{
                            self.emergencyServiceProvider = (objects as! [PFObject])[0]
                        }
                        var query = PFQuery(className: "Organization")
                        query.whereKey("location", nearGeoPoint: geoPoint!, withinMiles: 10.0)
                        query.whereKey("type", notEqualTo: "crisis-handling")
                        query.orderByAscending("location")
                        query.findObjectsInBackgroundWithBlock{
                            (objects, error) -> Void in
                            if error == nil{
                                self.resources.removeAll(keepCapacity: false)
                                self.resources = objects as! [PFObject]
                                println(self.resources)
//                                self.resourcesTableViewController.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 2)), withRowAnimation: UITableViewRowAnimation.Automatic)
                                self.resourcesTableViewController.tableView.reloadData()
                            }
                            else{
                                println("second failure")
                            }
                        }
                        
                    }
                    else{
                        println("first failure")
                    }
                }
            }
            else{
                println("can't find location")
                println(error)
                //                self.resourcesTableViewController.refreshControl!.endRefreshing()
            }
        })
        println("done")
    }
}
