//
//  ChatTabViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ChatTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Chat"
        
        var newChatButton = UIBarButtonItem(title: "New Chat", style: UIBarButtonItemStyle.Plain, target: self, action: "newChatButtonTapped")
        self.navigationItem.rightBarButtonItem = newChatButton
        
        var topicsSurveyButton = UIBarButtonItem(title: "Topic Survey", style: UIBarButtonItemStyle.Plain, target: self, action: "topicSurveyButtonTapped")
        self.navigationItem.leftBarButtonItem = topicsSurveyButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func topicSurveyButtonTapped(){
        println("Topic Survey Button Tapped")
        self.performSegueWithIdentifier("showTopicsSurvey", sender: self)
    }
    
    func newChatButtonTapped(){
        println("New Chat Button Tapped")
        self.performSegueWithIdentifier("showNewChat", sender: self)
    }
    
    

}
