//
//  StringExtension.swift
//  MeeraNews
//
//  Created by Kyaw Than Mong on 11/26/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit


extension String {
    func truncate(length : Int, trailing : String? = nil ) -> String {
        if self.characters.count > length {
            let start = self.startIndex.advancedBy(0)
            let end = self.startIndex.advancedBy(length)
            return self[Range(start: start, end: end)] + (trailing ?? "")
           
        }else {
            return self
        }
    }
}
