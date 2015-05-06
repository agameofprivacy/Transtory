//
//  QuestionnaireTableViewCell.swift
//  Transtory
//
//  Created by Eddie Chen on 5/3/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class QuestionnaireTableViewCell: UITableViewCell {

    var titleLabel:UILabel!
    var detailLabel:UILabel!
    var expertOptionButton:UIButton!
    var interestedOptionButton:UIButton!
    var notInterestedOptionButton:UIButton!
    
    var separator:UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.titleLabel = UILabel(frame: CGRectZero)
        self.titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.titleLabel.numberOfLines = 1
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(self.titleLabel)
        
        self.detailLabel = UILabel(frame: CGRectZero)
        self.detailLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.detailLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.detailLabel.numberOfLines = 0
        self.detailLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 15
        self.detailLabel.textAlignment = NSTextAlignment.Left
        self.contentView.addSubview(self.detailLabel)
        
        self.expertOptionButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.expertOptionButton.frame = CGRectZero
        self.expertOptionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.expertOptionButton.setTitle("Expert Option", forState: UIControlState.Normal)
        self.expertOptionButton.layer.borderWidth = 0.75
        self.expertOptionButton.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.expertOptionButton.layer.cornerRadius = 8
        self.contentView.addSubview(self.expertOptionButton)
        
        self.interestedOptionButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.interestedOptionButton.frame = CGRectZero
        self.interestedOptionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.interestedOptionButton.setTitle("Interested Option", forState: UIControlState.Normal)
        self.interestedOptionButton.layer.borderWidth = 0.75
        self.interestedOptionButton.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.interestedOptionButton.layer.cornerRadius = 8
        self.contentView.addSubview(self.interestedOptionButton)
        
        self.notInterestedOptionButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        self.notInterestedOptionButton.frame = CGRectZero
        self.notInterestedOptionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.notInterestedOptionButton.setTitle("Not Interested Option", forState: UIControlState.Normal)
        self.notInterestedOptionButton.layer.borderWidth = 0.75
        self.notInterestedOptionButton.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        self.notInterestedOptionButton.layer.cornerRadius = 8
        self.contentView.addSubview(self.notInterestedOptionButton)
        
        self.separator = UIView(frame: CGRectZero)
        self.separator.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.separator.backgroundColor = UIColor(white: 0.85, alpha: 1)
        self.contentView.addSubview(self.separator)
        
        var metricsDictionary = ["sideMargin":7.5]
        var viewsDictionary = ["titleLabel":self.titleLabel, "detailLabel":self.detailLabel, "expertOptionButton":self.expertOptionButton, "interestedOptionButton":self.interestedOptionButton, "notInterestedOptionButton":self.notInterestedOptionButton, "separator":self.separator]
        
        var topHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sideMargin-[titleLabel]-sideMargin-|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(topHConstraints)

        var bottomHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separator]|", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(bottomHConstraints)
        
        var leftVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[titleLabel]-15-[detailLabel]-25-[expertOptionButton(40)]-15-[interestedOptionButton(40)]-15-[notInterestedOptionButton(40)]-40-[separator(1)]|", options: NSLayoutFormatOptions.AlignAllLeft | NSLayoutFormatOptions.AlignAllRight, metrics: metricsDictionary, views: viewsDictionary)
        self.contentView.addConstraints(leftVConstraints)

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
