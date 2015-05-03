//
//  ResourceTableViewCell.swift
//  Transtory
//
//  Created by Eddie Chen on 5/3/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {
    
    var nameLabel:UILabel!
    var logoImageView:UIImageView!
    var descriptionLabel:UILabel!
    var callButton:UIButton!
    var emailButton:UIButton!
    var cityLabel:UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.nameLabel = UILabel(frame: CGRectZero)
        self.nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.nameLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        self.nameLabel.numberOfLines = 1
        self.nameLabel.textAlignment = NSTextAlignment.Left
        self.nameLabel.text = "resource name"
        self.contentView.addSubview(self.nameLabel)
        
        self.logoImageView = UIImageView(frame: CGRectZero)
        self.logoImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.contentView.addSubview(self.logoImageView)
        
        self.descriptionLabel = UILabel(frame: CGRectZero)
        self.descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 15
        self.descriptionLabel.text = "description text"
        self.contentView.addSubview(self.descriptionLabel)
        
        self.callButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.callButton.frame = CGRectZero
        self.callButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.callButton.setTitle("Call", forState: UIControlState.Normal)
        self.contentView.addSubview(self.callButton)
        
        self.emailButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.emailButton.frame = CGRectZero
        self.emailButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.emailButton.setTitle("Email", forState: UIControlState.Normal)
        self.contentView.addSubview(self.emailButton)
        
        self.cityLabel = UILabel(frame: CGRectZero)
        self.cityLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.cityLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        self.cityLabel.textAlignment = NSTextAlignment.Right
        self.cityLabel.numberOfLines = 1
        self.cityLabel.text = "city text"
        self.contentView.addSubview(self.cityLabel)

        var metricsDictionary = ["sideMargin":7.5, "buttonWidth":(UIScreen.mainScreen().bounds.width - 45)/2]
        var viewsDictionary = ["nameLabel":self.nameLabel, "logoImageView":self.logoImageView, "descriptionLabel":self.descriptionLabel, "callButton":self.callButton, "emailButton":self.emailButton, "cityLabel":self.cityLabel]
        
        var logoImageViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[logoImageView]|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(logoImageViewHConstraints)
        
        var titleLabelsHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[nameLabel]->=0-[cityLabel]-sideMargin-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(titleLabelsHConstraints)
        
        var buttonsHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[callButton(buttonWidth)]-30-[emailButton(buttonWidth)]-sideMargin-|", options: NSLayoutFormatOptions.AlignAllTop | NSLayoutFormatOptions.AlignAllBottom, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(buttonsHConstraints)
        
        var logoVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[logoImageView(80)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(logoVConstraints)
        
        var leftVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[logoImageView(80)]-15-[nameLabel]-sideMargin-[descriptionLabel]-15-[callButton]-30-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(leftVConstraints)
        
        var rightVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[logoImageView(80)]-15-[cityLabel]-sideMargin-[descriptionLabel]-15-[emailButton]-30-|", options: NSLayoutFormatOptions.AlignAllRight, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(rightVConstraints)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
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
