//
//  JobsManager.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 10/29/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Alamofire
import Magic
import SwiftyJSON

class JobsManager {
    
    
    
    class func getJobLists(completeHandler : (response : AnyObject? , error : ErrorType?) -> ()) {
        
        magic("calling job")
        let API_END = "https://hacker-news.firebaseio.com/v0/jobstories.json?"
        
        Alamofire.request(.GET, API_END)
            .responseJSON(completionHandler: {
            (_, _, data) in
                if let error = data.error {
                    magic(error)
                    completeHandler(response: nil, error: error)
                }
                
                if let json = data.value {
                    magic(json)
                    var result : [Int] = []
                    let response = JSON(json)
                    for item in response {
                        result.append(item.1.int!)
                    }
                    completeHandler(response: result, error: nil)
                }
            })
        
    }
    
    class func getDetailOnAJob(jobID : Int , completeHandler : (response : JSON?, error : ErrorType?) -> () ) {
        
        let APIENDPOINT = "https://hacker-news.firebaseio.com/v0/item/\(jobID).json?"
        Alamofire.request(.GET, APIENDPOINT)
            .responseJSON {
                _, _, json in
                if let data = json.value {
                    completeHandler(response: JSON(data), error: nil)
                }else {
                    completeHandler(response: nil, error: json.error)
                }
        }
    }
    
    
}
