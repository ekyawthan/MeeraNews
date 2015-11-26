//
//  TopStoryCell.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 10/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit


class TopStoryCell : UITableViewCell {
 
    @IBOutlet weak var newsExerptLabel: UILabel!
    @IBOutlet weak var titleRightContraint: NSLayoutConstraint!
    @IBOutlet weak var exerptRightContraint: NSLayoutConstraint!
    @IBOutlet weak var newsCreatedAt: UILabel!
    @IBOutlet weak var NewsLeadingImage: UIImageView!
    @IBOutlet weak var publishedBy: UILabel!
    
    @IBOutlet weak var title: UILabel!
    var url = ""

    @IBOutlet weak var source: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
