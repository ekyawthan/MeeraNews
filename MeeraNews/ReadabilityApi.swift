//
//  ReadabilityApi.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 11/19/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Magic

class ReadabilityApi {
    class func parseHtml(newsID : Int , url : String , completionHandler: (responseObject: NewsModel?, error: ErrorType?) ->() ) {
    
        let urlToParse = "https://readability.com/api/content/v1/parser?url=\(url)&token=6f794207ef47f9e3ba2dcad486c9bb8054edcd00"

        Alamofire.request(.GET, urlToParse)
            .responseJSON {
                _ , _ , data in
                if let error = data.error {
                    
                    completionHandler(responseObject: nil, error: error)
                }
                if let response = data.value {
                    magic(response)
                    let parseHtml = JSON(response)
                    RealmHandler.writeOrUpdateNews(newsID, createdAt: 23423, newsInJson: parseHtml) {
                        isWritten in
                        if isWritten {
                            let model = RealmHandler.getNewsItemWithID(newsID)
                            completionHandler(responseObject: model, error: nil)
                           
                        }
                    }
                }
        }
    }
    
}
