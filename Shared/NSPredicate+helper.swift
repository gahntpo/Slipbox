//
//  NSPredicate+helper.swift
//  SlipboxApp
//
//  Created by Karin Prater on 02.12.20.
//

import Foundation
import CoreData

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
