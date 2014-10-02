//
//  ArrayExtension.swift
//  Flocate
//
//  Created by Kevin Bluer on 10/2/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

extension NSArray {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}