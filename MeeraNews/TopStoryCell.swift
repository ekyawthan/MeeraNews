//
//  TopStoryCell.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 10/28/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit


class TopStoryCell : UITableViewCell {
    
    @IBOutlet weak var owenerAndcreated: UILabel!
    
    @IBOutlet weak var title: UILabel!
    var url = ""
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
