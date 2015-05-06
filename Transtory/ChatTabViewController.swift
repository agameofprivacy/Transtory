//
//  ChatTabViewController.swift
//  Transtory
//
//  Created by Eddie Chen on 5/1/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ChatTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var questionnaires:[PFObject] = []
    var questionnaireTableViewController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Chat"
        
        var newChatButton = UIBarButtonItem(title: "New Chat", style: UIBarButtonItemStyle.Plain, target: self, action: "newChatButtonTapped")
        self.navigationItem.rightBarButtonItem = newChatButton
        
        var topicsSurveyButton = UIBarButtonItem(title: "My Topics", style: UIBarButtonItemStyle.Plain, target: self, action: "topicSurveyButtonTapped")
        self.navigationItem.leftBarButtonItem = topicsSurveyButton
        
        self.addChildViewController(self.questionnaireTableViewController)
        
        self.questionnaireTableViewController.tableView = TPKeyboardAvoidingTableView(frame: self.view.frame)
        self.questionnaireTableViewController.refreshControl = UIRefreshControl()
        self.questionnaireTableViewController.refreshControl?.addTarget(self, action: "loadQuestionnaires", forControlEvents: UIControlEvents.ValueChanged)
        self.questionnaireTableViewController.tableView.delegate = self
        self.questionnaireTableViewController.tableView.dataSource = self
        self.questionnaireTableViewController.tableView.rowHeight = UITableViewAutomaticDimension
        self.questionnaireTableViewController.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.questionnaireTableViewController.tableView.registerClass(QuestionnaireTableViewCell.self, forCellReuseIdentifier: "QuestionnaireTableViewCell")
        self.view.addSubview(self.questionnaireTableViewController.tableView)
        
        self.loadQuestionnaires()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("QuestionnaireTableViewCell") as! QuestionnaireTableViewCell
        var questionnaire = self.questionnaires[indexPath.row]
        cell.titleLabel.text = questionnaire["question"] as? String
        cell.detailLabel.text = questionnaire["detail"] as? String
        cell.expertOptionButton.setTitle(questionnaire["expertOption"] as? String, forState: UIControlState.Normal)
        cell.interestedOptionButton.setTitle(questionnaire["interestedOption"] as? String, forState: UIControlState.Normal)
        cell.notInterestedOptionButton.setTitle(questionnaire["notInterestedOption"] as? String, forState: UIControlState.Normal)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionnaires.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func topicSurveyButtonTapped(){
        println("Topic Survey Button Tapped")
        self.performSegueWithIdentifier("showTopicsSurvey", sender: self)
    }
    
    func newChatButtonTapped(){
        println("New Chat Button Tapped")
        self.performSegueWithIdentifier("showNewChat", sender: self)
    }
    
    func loadQuestionnaires(){
        var query:PFQuery = PFQuery(className: "Questionnaire")
        query.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil{
                self.questionnaires = objects as! [PFObject]
                self.questionnaireTableViewController.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                self.questionnaireTableViewController.refreshControl?.endRefreshing()
            }
            else{
                println("find operation failed: \(error)")
            }
        })
    }

}
