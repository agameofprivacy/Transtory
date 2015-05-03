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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resourcesTableViewController = UITableViewController()
        self.resourcesTableViewController.tableView.delegate = self
        self.resourcesTableViewController.tableView.dataSource = self
        
        self.navigationItem.title = "Resources"
        
        var locateButton = UIBarButtonItem(title: "Locate", style: UIBarButtonItemStyle.Plain, target: self, action: "locateButtonTapped")
        self.navigationItem.rightBarButtonItem = locateButton
        
        var categoriesButton = UIBarButtonItem(title: "Categories", style: UIBarButtonItemStyle.Plain, target: self, action: "categoriesButtonTapped")
        self.navigationItem.leftBarButtonItem = categoriesButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableView(frame: CGRectZero)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resources.count
    }

    func locateButtonTapped(){
        println("Locate Button Tapped")
    }
    
    func categoriesButtonTapped(){
        println("Categories Button Tapped")
        self.performSegueWithIdentifier("showCategories", sender: self)
    }

}
