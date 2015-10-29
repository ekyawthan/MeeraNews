//
//  NewsManager.swift
//  TecherNews
//
//  Created by Kyaw Than Mong on 10/27/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON


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
    
    class func getDetailonTopStory(newsID : Int , completeHandler : (response : AnyObject?, error : ErrorType?) -> () ) {
        
        let APIENDPOINT = "https://hacker-news.firebaseio.com/v0/item/\(newsID).json?"
        Alamofire.request(.GET, APIENDPOINT)
            .responseJSON {
                _, _, json in
                if let data = json.value {
                    completeHandler(response: data, error: nil)
                }else {
                    completeHandler(response: nil, error: json.error)
                }
        }
    }
    
}



// MARK : serialiazer for detail for top story

class ModelTopStoryDetail : Mappable {
    
    var owner : String?
    var descendants : Int?
    var id : Int?
    var score : Int?
    var time : Double?
    var title : String?
    var url : String?
    var type : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
     func mapping(map: Map) {
        owner <- map["by"]
        descendants <- map["descendants"]
        id <- map["id"]
        score <- map["score"]
        time <- map["time"]
        title <- map["title"]
        url <- map["url"]
        type <- map["type"]
    }
}


// MARK : top story serialazer

class ModelTopStory : Mappable {
    var storyId : Int?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
    }
}