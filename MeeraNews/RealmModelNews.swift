//
//  RealmModelNews.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 11/24/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import RealmSwift

class RealmModelNews : Object {
    
    dynamic var id : Int = 0
    dynamic var title : String?  = nil
    dynamic var excerpt : String? = nil
    dynamic var author : String? = nil
    dynamic var leadImageUrl : String? = nil
    dynamic var createdAt : Double = 0
    dynamic var url : String? = nil
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
