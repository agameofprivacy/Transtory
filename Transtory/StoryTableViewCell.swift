//
//  StoryTableViewCell.swift
//  Transtory
//
//  Created by Eddie Chen on 5/2/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    var profileImageView:UIImageView!
    var usernameLabel:UILabel!
    var timeAgoLabel:UILabel!
    
    var storyImageView:UIImageView!
    var playStoryAudioButton:UIButton!
    var likeButton:UIButton!
    var commentButton:UIButton!
    
    var storyTextLabel:UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.profileImageView = UIImageView(frame: CGRectZero)
        self.profileImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.profileImageView.layer.cornerRadius = 25
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 0.5
        self.profileImageView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        self.profileImageView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.profileImageView.image = UIImage(named: "profileTemp")
        self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.contentView.addSubview(self.profileImageView)
        
        self.usernameLabel = UILabel(frame: CGRectZero)
        self.usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.usernameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.usernameLabel.textAlignment = NSTextAlignment.Left
        self.usernameLabel.text = "username"
        self.contentView.addSubview(self.usernameLabel)
        
        self.timeAgoLabel = UILabel(frame: CGRectZero)
        self.timeAgoLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.timeAgoLabel.text = "time ago"
        self.timeAgoLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
        self.timeAgoLabel.textAlignment = NSTextAlignment.Right
        self.contentView.addSubview(self.timeAgoLabel)
        
        self.storyImageView = UIImageView(frame: CGRectZero)
        self.storyImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.storyImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.storyImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.storyImageView.userInteractionEnabled = true
        self.contentView.addSubview(self.storyImageView)
        
        self.storyTextLabel = UILabel(frame: CGRectZero)
        self.storyTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.storyTextLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.storyTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 15
        self.storyTextLabel.numberOfLines = 0
        self.contentView.addSubview(self.storyTextLabel)

        self.playStoryAudioButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.playStoryAudioButton.frame = CGRectZero
        self.playStoryAudioButton.setBackgroundImage(UIImage(named:"playIcon"), forState: UIControlState.Normal)
        self.playStoryAudioButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.playStoryAudioButton.backgroundColor = UIColor.blackColor()
        self.playStoryAudioButton.layer.cornerRadius = 25
        self.storyImageView.addSubview(self.playStoryAudioButton)
        
        self.likeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.likeButton.setBackgroundImage(UIImage(named:"likeIcon"), forState: UIControlState.Normal)
        self.likeButton.frame = CGRectZero
        self.likeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.likeButton.backgroundColor = UIColor(red:0.95, green:0.67, blue:0.72, alpha:1)
        self.likeButton.layer.cornerRadius = 25
        self.storyImageView.addSubview(self.likeButton)

        self.commentButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.commentButton.frame = CGRectZero
        self.commentButton.setBackgroundImage(UIImage(named:"commentIcon"), forState: UIControlState.Normal)
        self.commentButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.commentButton.backgroundColor = UIColor(red:0.38, green:0.81, blue:0.97, alpha:1)
        self.commentButton.layer.cornerRadius = 25
        self.storyImageView.addSubview(self.commentButton)

        
        var viewsDictionary = ["profileImageView":self.profileImageView, "usernameLabel":self.usernameLabel, "timeAgoLabel":self.timeAgoLabel, "storyImageView":self.storyImageView, "storyTextLabel":self.storyTextLabel]
        var metricsDictionary = ["sideMargin":15, "screenWidth":UIScreen.mainScreen().bounds.width]
        
        var profileHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-7.5-[profileImageView(50)]-10-[usernameLabel]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(profileHorizontalConstraints)
        
        var storyImageViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[storyImageView]|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(storyImageViewHorizontalConstraints)
        
        var topVerticalConstraintsLeft = NSLayoutConstraint.constraintsWithVisualFormat("V:|-25.5-[usernameLabel][timeAgoLabel]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(topVerticalConstraintsLeft)
        
        var bottomVerticalConstraintsLeft = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[profileImageView(50)]-10-[storyImageView(screenWidth)]-12-[storyTextLabel]-7.5-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(bottomVerticalConstraintsLeft)
        
        var storyTextHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[storyTextLabel]-12.5-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(storyTextHConstraints)
        
        var topViewsDictionary = ["playStoryAudioButton":self.playStoryAudioButton, "likeButton":self.likeButton, "commentButton":self.commentButton]
        var topMetricsDictionary = ["sideMargin":15]
        
        var bottomBottomHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-7.5-[playStoryAudioButton(50)]-sideMargin-[likeButton(50)]-sideMargin-[commentButton(50)]", options: NSLayoutFormatOptions.AlignAllTop | NSLayoutFormatOptions.AlignAllBottom, metrics: topMetricsDictionary, views: topViewsDictionary)
        self.storyImageView.addConstraints(bottomBottomHorizontalConstraints)

        var bottomBottomVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[playStoryAudioButton(50)]-sideMargin-|", options: NSLayoutFormatOptions(0), metrics: topMetricsDictionary, views: topViewsDictionary)
        self.storyImageView.addConstraints(bottomBottomVerticalConstraints)
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
