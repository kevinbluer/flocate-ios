//
//  NSDate.swift
//  Flocate
//
//  Created by Kevin Bluer on 10/4/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import Foundation

extension NSDate
    {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}