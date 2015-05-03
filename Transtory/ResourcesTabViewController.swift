//
//  ResourcesTabViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ResourcesTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var resourcesTableViewController:UITableViewController!
    var resources:[PFObject] = []
    var currentGeoPoint:PFGeoPoint!
    var emergencyServiceProvider:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resourcesTableViewController = UITableViewController()
        self.resourcesTableViewController.tableView.delegate = self
        self.resourcesTableViewController.tableView.dataSource = self
        self.resourcesTableViewController.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        self.resourcesTableViewController.tableView.registerClass(ResourceTableViewCell.self, forCellReuseIdentifier: "ResourceTableViewCell")
        self.view.addSubview(self.resourcesTableViewController.tableView)
        
        self.addChildViewController(self.resourcesTableViewController)
        
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
        if indexPath.section == 1{
        var cell:ResourceTableViewCell = tableView.dequeueReusableCellWithIdentifier("ResourceTableViewCell") as! ResourceTableViewCell
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
        if section == 0{
            var view = UIView()
            return view
        }
        else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 80
        }
        else{
            return 0
        }
    }

    func locateButtonTapped(){
        println("Locate Button Tapped")
    }
    
    func categoriesButtonTapped(){
        println("Categories Button Tapped")
        self.performSegueWithIdentifier("showCategories", sender: self)
    }

    
    func locateAndLoad(){
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint, error) -> Void in
            if error == nil {
                self.currentGeoPoint = geoPoint
                
                // do something with the new geoPoint
                var emergencyServiceProviderQuery = PFQuery(className: "Organization")
                //                emergencyServiceProviderQuery.whereKey("city", equalTo: PFUser.currentUser()["city"])
                //                emergencyServiceProviderQuery.whereKey("state", equalTo: PFUser.currentUser()["state"])
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
                                self.resourcesTableViewController.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 2)), withRowAnimation: UITableViewRowAnimation.Automatic)
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
                //                self.resourcesTableViewController.refreshControl!.endRefreshing()
            }
        }
    }
}
