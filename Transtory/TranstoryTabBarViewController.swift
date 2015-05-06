//
//  TranstoryTabBarViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class TranstoryTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for var index = 0; index <  self.tabBar.items?.count; ++index{
            
            // Instantiate UITabBarItem
            var tabItem : UITabBarItem = self.tabBar.items![index] as! UITabBarItem
            
//             Switch assets for UITabBarItem in order
            switch index{
                
                // Stories
            case 0:
                tabItem.selectedImage = UIImage(named: "storiesSelected")
                tabItem.image = UIImage(named: "storiesUnselected")
                
                // Chat
            case 1:
                tabItem.selectedImage = UIImage(named: "chatSelected")
                tabItem.image = UIImage(named: "chatUnselected")
                
                // Resources
            case 2:
                tabItem.selectedImage = UIImage(named: "resourcesSelected")
                tabItem.image = UIImage(named: "resourcesUnselected")
                
            default:
                println("no image resourced")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
