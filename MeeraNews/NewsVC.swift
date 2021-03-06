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
import Async
import ImageLoader


class NewsVC: UIViewController {
    
    enum NewsVCTableCellType : String {
        case CellWithImage = "newsCellWithImage"
        case cellWithoutImage = "newsCellWithoutImage"
    }
    
    var localCachesTopStory : [Int : JSON] = Dictionary<Int , JSON>()
    
    @IBOutlet weak var topNewsTableView: UITableView!
    //var dataTopStory : [Int] = []
    
    var topStories : [NewsModel] = []
    var topStoryIDS : [Int] = []
    
    var loadingActivityIndicator : NVActivityIndicatorView!
    var currentOffSet = 0 {
        didSet {
            initializeData(currentOffSet, newsArray: self.topStoryIDS)
            
            
        }
    }
    
    
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
        
        loadingActivityIndicator = NVActivityIndicatorView(
            frame: CGRectMake(0, 0, 120, 120),
            type: .BallClipRotate,
            color: UIColor.redColor())
        loadingActivityIndicator.center = self.view.center
        self.view.addSubview(loadingActivityIndicator)
        
        getTopStoryFromHackerNews()
    }
    
    
    private func getTopStoryFromHackerNews() {
        showLoading()
        NewsManager.getTopStories {[unowned self]
            data , erorr in
            if let _ = data {
                self.topStoryIDS = data as! [Int]
                self.topStories = []
                self.currentOffSet = 10
            }
            
        }
        
    }
    
    
    private func initializeData(currentOffSet : Int, newsArray : [Int] ) {
        // every 5 offset , check if data exist in database otherwise get it from server
        
        for i in currentOffSet - 10..<currentOffSet {
            let currentItemId = newsArray[i]
            if let model = RealmHandler.getNewsItemWithID(currentItemId) {
                self.topStories.append(model)
                self.topNewsTableView.reloadData()
                self.hideLoading()
                
            }else {
                // get it form server
                NewsManager.getDetailonTopStory(currentItemId) {
                    data , error in
                    if error == nil {
                        self.topStories.append(data!)
                        self.topNewsTableView.reloadData()
                        self.hideLoading()
                        
                    }
                }
            }
        }
        let qos = QOS_CLASS_USER_INITIATED
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            var tmpNewsList : [NewsModel] = []
            for i in 10..<self.topStoryIDS.count {
                let nextId = self.topStoryIDS[i]
                if let model = RealmHandler.getNewsItemWithID(nextId) {
                    tmpNewsList.append(model)
                }else {
                    NewsManager.getDetailonTopStory(nextId) {
                        data, error in
                        if let _ = data {
                            tmpNewsList.append(data!)
                        }
                        
                    }
                    
                }
                
            }
            if tmpNewsList.count > 0 {
                dispatch_async(dispatch_get_main_queue()) {
                    self.topStories += tmpNewsList
                    self.topNewsTableView.reloadData()
                    
                }
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
        let newsID = topStories[indexPath.row]
        cell.title.text = newsID.title
        cell.source.text = newsID.author ?? ""
        cell.url = newsID.url ?? ""
        
        cell.newsExerptLabel.text = newsID.excerpt?.truncate(50, trailing: ".....")
        if let imageUrl = newsID.leadImageUrl {
            cell.NewsLeadingImage.hidden = false
            cell.exerptRightContraint.constant = 88
            cell.titleRightContraint.constant = 88
            cell.NewsLeadingImage.load(imageUrl, placeholder: nil, completionHandler: nil)
            
        }else {
            cell.NewsLeadingImage.hidden = true
            cell.exerptRightContraint.constant = 8
            cell.titleRightContraint.constant = 8
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topStories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TopStoryCell
        if cell.url != "" {
            let webVC = SFSafariViewController(URL: NSURL(string: cell.url)!, entersReaderIfAvailable: true)
            webVC.navigationController?.navigationBar.tintColor = UIColor.orangeColor()
            webVC.navigationItem.rightBarButtonItem?.tintColor = UIColor.orangeColor()
            
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
        self.topNewsTableView.alpha = 0.01
        loadingActivityIndicator.startAnimation()
        
    }
    func hideLoading() {
        self.topNewsTableView.alpha = 1.0
        loadingActivityIndicator.stopAnimation()
        loadingActivityIndicator.hidden = true
        
    }
}
