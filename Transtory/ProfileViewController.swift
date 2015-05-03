//
//  ProfileViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Profile"
        
        var closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeButtonTapped")
        self.navigationItem.leftBarButtonItem = closeButton
        
        var logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButtonTapped")
        self.navigationItem.rightBarButtonItem = logoutButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeButtonTapped(){
        println("Close Button Tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logoutButtonTapped(){
        println("Logout Button Tapped")
        PFInstallation.currentInstallation().removeObjectForKey("currentUser")
        PFInstallation.currentInstallation().saveInBackgroundWithBlock(nil)
        PFUser.logOut()
        self.performSegueWithIdentifier("LoggedOut", sender: self)
    }

}
