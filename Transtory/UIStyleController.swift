//
//  UIStyleController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class UIStyleController: NSObject {
    class func applyStyle(){
        var navigationBarAppearance:UINavigationBar = UINavigationBar.appearance()
        var fontAttributeDictionary = NSDictionary(object: UIFont(name: "AmericanTypewriter", size: 22)!, forKey: NSFontAttributeName)
        navigationBarAppearance.titleTextAttributes = fontAttributeDictionary as [NSObject : AnyObject]
//        navigationBarAppearance.tintColor = UIColor.whiteColor()
//        navigationBarAppearance.barTintColor = UIColor(red:0.38, green:0.81, blue:0.97, alpha:1)
//        navigationBarAppearance.titleTextAttributes = [UIColor.whiteColor():NSForegroundColorAttributeName]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -1000), forBarMetrics: UIBarMetrics.Default)
        
        var tabBarAppearance:UITabBar = UITabBar.appearance()
        tabBarAppearance.barTintColor = UIColor.blackColor()
        tabBarAppearance.tintColor = UIColor.whiteColor()
        
//        tabBarAppearance.tintColor = UIColor.whiteColor()
    }
}
