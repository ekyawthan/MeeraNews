//
//  TopStoryCell.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 10/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class TopStoryCell : UITableViewCell {
    
    @IBOutlet weak var NewsLeadingImage: UIImageView!
    @IBOutlet weak var owenerAndcreated: UILabel!
    
    @IBOutlet weak var title: UILabel!
    var url = ""
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let activity = NVActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80), type: .BallBeat, color: UIColor.redColor())
        
        activity.center = NewsLeadingImage.center
        self.contentView.addSubview(activity)
        NewsLeadingImage.alpha = 0.3
        activity.startAnimation()
    }
}
