//
//  NewsVC.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit

class NewsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.selectedIndex = 0
        NewsManager.getTopStories {
            _, _ in
            
        }

    }


}
