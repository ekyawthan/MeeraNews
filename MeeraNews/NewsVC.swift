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
import Parse
import NVActivityIndicatorView


class NewsVC: UIViewController {
    
    enum NewsVCTableCellType : String {
        case CellWithImage = "newsCellWithImage"
        case cellWithoutImage = "newsCellWithoutImage"
    }
    
    var localCachesTopStory : [Int : JSON] = Dictionary<Int , JSON>()
    
    @IBOutlet weak var topNewsTableView: UITableView!
    var dataTopStory : [Int] = []
    
    var loadingActivityIndicator : NVActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.topNewsTableView.dataSource = self
        self.topNewsTableView.delegate = self
        self.topNewsTableView.rowHeight = UITableViewAutomaticDimension
        self.topNewsTableView.estimatedRowHeight = 140
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0)
        topNewsTableView.dg_addPullToRefreshWithActionHandler({   () -> Void in
            self.topNewsTableView.dg_stopLoading()
            self.getTopStoryFromHackerNews()
         })
        topNewsTableView.dg_setPullToRefreshFillColor(UIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0))
        topNewsTableView.dg_setPullToRefreshBackgroundColor(topNewsTableView.backgroundColor!)
        
        loadingActivityIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100), type: .LineScale, color: UIColor.redColor())
        loadingActivityIndicator.center = self.view.center
        self.view.addSubview(loadingActivityIndicator)
        
     getTopStoryFromHackerNews()
        
        
   
        
       
    }
    
    
    private func getTopStoryFromHackerNews() {
        showLoading()
        NewsManager.getTopStories {[unowned self]
            data , erorr in
            if let _ = data {
                self.localCachesTopStory = Dictionary<Int, JSON>()
                
                
                self.dataTopStory = data as! [Int]
                self.topNewsTableView.reloadData()
                self.hideLoading()
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let name = "Pattern~ Home"
       
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]
    }
    
   
    


}


extension NewsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsVCTableCellType.cellWithoutImage.rawValue, forIndexPath: indexPath) as! TopStoryCell
        let newsID = dataTopStory[indexPath.row]
        
        if localCachesTopStory[indexPath.row] != nil {
            magic("existed at local")
            let model = localCachesTopStory[indexPath.row]
            cell.title.text = model!["title"].string ?? "Can not found Title"
            cell.numberOfComments.text = "\(model![""].int ?? 0) comments"
            cell.numberOfPoint.text = "\(model!["descendants"].int ?? 0) points"
            cell.url = model!["url"].string ?? "url not found"
        }else {
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
                    self.localCachesTopStory[indexPath.row] = json
                }
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

extension NewsVC {
    func showLoading() {
        loadingActivityIndicator.hidden = false
        self.topNewsTableView.alpha = 0.4
        loadingActivityIndicator.startAnimation()
        
    }
    func hideLoading() {
         self.topNewsTableView.alpha = 1.0
        loadingActivityIndicator.stopAnimation()
        loadingActivityIndicator.hidden = true
        
    }
}
