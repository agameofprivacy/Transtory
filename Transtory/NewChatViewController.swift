//
//  NewChatViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "New Chat"
        
        var requestButton = UIBarButtonItem(title: "Request", style: UIBarButtonItemStyle.Done, target: self, action: "requestButtonTapped")
        self.navigationItem.rightBarButtonItem = requestButton
        
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonTapped")
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestButtonTapped(){
        println("Request Button Tapped")
    }
    
    func cancelButtonTapped(){
        println("Cancel Button Tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
