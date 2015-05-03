//
//  CategoriesViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Categories"

        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelButtonTapped")
        self.navigationItem.leftBarButtonItem = cancelButton
        
        var confirmButton = UIBarButtonItem(title: "Confirm", style: UIBarButtonItemStyle.Done, target: self, action: "confirmButtonTapped")
        self.navigationItem.rightBarButtonItem = confirmButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func cancelButtonTapped(){
        println("Cancel Button Tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmButtonTapped(){
        println("Confirm Button Tapped")
    }

}
