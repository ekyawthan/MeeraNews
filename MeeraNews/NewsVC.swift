//
//  NewsVC.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Magic
import SwiftyJSON
import DGElasticPullToRefresh
import SwiftMoment
import SafariServices
import RAMAnimatedTabBarController

class NewsVC: UIViewController {
    
    
    
    enum NewsVCTableCellType : String {
        case CellWithImage = "newsCellWithImage"
        case cellWithoutImage = "newsCellWithoutImage"
    }
    
    @IBOutlet weak var topNewsTableView: UITableView!
    var dataTopStory : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as! [String : AnyObject]
        
        self.topNewsTableView.dataSource = self
        self.topNewsTableView.delegate = self
        self.topNewsTableView.rowHeight = UITableViewAutomaticDimension
        self.topNewsTableView.estimatedRowHeight = 140
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0)
        topNewsTableView.dg_addPullToRefreshWithActionHandler({   () -> Void in
            self.topNewsTableView.dg_stopLoading()
            self.topNewsTableView.reloadData()
         })
        topNewsTableView.dg_setPullToRefreshFillColor(UIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0))
        topNewsTableView.dg_setPullToRefreshBackgroundColor(topNewsTableView.backgroundColor!)
        
        
        NewsManager.getTopStories {[unowned self]
            data , erorr in
            if let _ = data {
                magic("did recieved")
                self.dataTopStory = data as! [Int]
                self.topNewsTableView.reloadData()
            
            }
            
        }

    }


}


extension NewsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsVCTableCellType.cellWithoutImage.rawValue, forIndexPath: indexPath) as! TopStoryCell
        let newsID = dataTopStory[indexPath.row]
        NewsManager.getDetailonTopStory(newsID) {
            data , error in
            if let  _ = data {
                let json = JSON(data!)
                cell.title.text = json["title"].stringValue
                cell.numberOfPoint.text = "\(json["score"].intValue) Points"
                cell.numberOfComments.text = "\(json["descendants"].intValue) comments"
                cell.url = json["url"].stringValue
                //moment().subtract(moejson["time"].doubleValue)
                magic(moment(NSDate(timeIntervalSince1970: json["time"].doubleValue)))
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataTopStory.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopStoryCell
        if cell.url != "" {
            let webVC = SFSafariViewController(URL: NSURL(string: cell.url)!)
        
            webVC.delegate = self
            self.presentViewController(webVC, animated: true, completion: nil)
        }
    
    }
    
}


extension NewsVC : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
    }
}

extension NewsVC : UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController == self {
            magic("yse")
        }
    }
    
}
