//
//  RealmHandler.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 11/24/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON



class RealmHandler  {
    //MARK :- realm write
    
    /**
    A class function which Take json ojbect to write on the Realm Databases
    - Parameter newsID: The news id to be written
    - Parameter createdAt : The time , news was added on hackernews
    - Parameter newsInJson : detail on newsID , return from Readiability API
    - Parameter complateHandler : Notify if writing or update database successfully
    
    
    */
    class func writeOrUpdateNews(newsID : Int ,createdAt : Double , newsInJson : JSON, complateHandler : (isWritten : Bool) -> ()) {
        let NewsToWrite = RealmModelNews()
        NewsToWrite.id = newsID
        NewsToWrite.title = newsInJson["title"].string
        NewsToWrite.excerpt = newsInJson["excerpt"].string
        NewsToWrite.author = newsInJson["author"].string
        NewsToWrite.leadImageUrl = newsInJson["lead_image_url"].string
        NewsToWrite.url = newsInJson["url"].string
        NewsToWrite.createdAt = createdAt
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(NewsToWrite, update: true)
            complateHandler(isWritten: true)
        }
        
        
    }
    /**

     A class function ,takes news id as input parameter , and return a struct of news model otherwise return nil
     -  Parameter newsID : the primary key of news , stored in database
     -  Returns NewsModel  : a struct object of NewsModel
*/
    
    class func getNewsItemWithID(newsID : Int ) -> NewsModel? {
        
        do {
            if let news = try Realm().objects(RealmModelNews).filter("id = \(newsID)").first {
                var model = NewsModel()
                model.author = news.author
                
                model.createdAt = news.createdAt
                model.excerpt = news.excerpt
                model.id = news.id
                model.leadImageUrl = news.leadImageUrl
                model.title = news.title
                model.url = news.url
                return model
            }else {
                return nil
            }
            
        }
        catch {
            return nil
            
        }
        
        
    }
}



struct NewsModel {
    var id : Int = 0
    var title : String?
    var excerpt : String?
    var author : String?
    var leadImageUrl : String?
    var url : String?
    var createdAt : Double = 0
    
}