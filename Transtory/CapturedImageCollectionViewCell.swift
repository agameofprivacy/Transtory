//
//  CapturedImageCollectionViewCell.swift
//  Transtory
//
//  Created by Eddie Chen on 5/2/15.
//  Copyright (c) 2015 Out App. All rights reserved.
//

import UIKit

class CapturedImageCollectionViewCell: UICollectionViewCell {
    
    var capturedImageImageView:UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.capturedImageImageView = UIImageView(frame: CGRectMake(0, 0, 44, 44))
        self.capturedImageImageView.backgroundColor = UIColor.blackColor()
        self.contentView.addSubview(self.capturedImageImageView)
    }
}
