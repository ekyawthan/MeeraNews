//
//  NewsManager.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Magic

class NewsManager {
    
    class func getTopStories(completeHandler : (response : AnyObject?, error : ErrorType?) -> ()) {
        
        let ApiEndPoint = "https://hacker-news.firebaseio.com/v0/topstories.json?"
        
        Alamofire.request(.GET, ApiEndPoint)
            .responseJSON { _, _ , json in
                
                if let data = json.value {
                    var result : [Int] = []
                    let response = JSON(data)
                    
                    for item in response {
                        result.append(item.1.int!)
                    }
                    completeHandler(response: result, error: nil)
                }
                if let error = json.error {
                    completeHandler(response: nil, error: error)
                    
                }
                
        }
        
    }
    
    class func getDetailonTopStory(newsID : Int , completeHandler : (response : NewsModel?, error : ErrorType?) -> () ) {
        
        let APIENDPOINT = "https://hacker-news.firebaseio.com/v0/item/\(newsID).json?"
        Alamofire.request(.GET, APIENDPOINT)
            .responseJSON {
                _, _, json in
                if let data = json.value {
                    let dataInJSON = JSON(data)
                    magic(dataInJSON)
                    if let url = dataInJSON["url"].string {
                        magic(url)
                        ReadabilityApi.parseHtml(newsID, url: url, completionHandler: completeHandler)
                        
                        
                    }else {
                        completeHandler(response: nil, error: json.error)
                    }
                }
        }
        
    }
    
    
    
}


   