//
//  ProfileVC.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var loginnedMainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let facebookLogin = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 45))
        facebookLogin.backgroundColor = UIColor(red: 58/255, green: 87/255, blue: 149/255, alpha: 1.0)
        facebookLogin.center = CGPointMake(self.view.center.x, self.view.center.y)
        
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let attributes = [
            NSForegroundColorAttributeName : textColor,
            NSFontAttributeName : font,
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle
        ]
        
        facebookLogin.setAttributedTitle(NSAttributedString(string: "Login With Facebook", attributes: attributes), forState: .Normal)
        
        facebookLogin.layer.cornerRadius = 10
        self.loginnedMainView.alpha = 0.1
        self.view.addSubview(facebookLogin)
        
        
    }


}

extension ProfileVC {
    
    @IBAction func didClickOnSIgnUpFacebook(sender: AnyObject) {
        
        print("did click on sign with facebook")
    }
}
