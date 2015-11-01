//
//  JobVC.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Magic

class JobVC: UIViewController {
    
    enum JobVCCellIdentifier : String {
        case jobCell = "jobListCell"
    }
    
    var jobData = [Int]()

    @IBOutlet weak var jobTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        jobTableview.delegate = self
        jobTableview.dataSource = self
        jobTableview.rowHeight = UITableViewAutomaticDimension
        jobTableview.estimatedRowHeight = 60
        
        JobsManager.getJobLists {
            data , error in
            
            if nil != error {
                
            }
            if nil != data {
                magic(data)
                self.jobData = data as! [Int]
                self.jobTableview.reloadData()
                
                
            }
        }

    }

    

}


extension JobVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(JobVCCellIdentifier.jobCell.rawValue, forIndexPath: indexPath) as! JobTableviewCell
        JobsManager.getDetailOnAJob(jobData[indexPath.row]) {
            data, error in
            cell.jobTitle.text = data!["title"].string ?? "Title Not Found!!"
            
            
        }
    
        return cell
    }
}

class JobTableviewCell : UITableViewCell {
    
    @IBOutlet weak var uploadTime: UILabel!
    
    @IBOutlet weak var jobTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var didClickApplyJob: UIButton!
    
}













