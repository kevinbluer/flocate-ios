//
//  StringExtensions.swift
//  Flocate
//
//  Created by Kevin Bluer on 8/25/14.
//  Copyright (c) 2014 Bluer Inc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}