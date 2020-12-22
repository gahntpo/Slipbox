//
//  DropStatus.swift
//  SlipboxApp
//
//  Created by Karin Prater on 22.12.20.
//

import Foundation

enum DropStatus {
    case inActive
    case note
    case folderBefore
    case folderAfter
    case subfolder
    
    var folderRelated: Bool {
        switch self {
        case .folderAfter, .folderBefore, .subfolder:
            return true
        default:
            return false
        }
    }
    
    var dropAfter: Bool  {
        switch self {
        case .folderAfter, .subfolder:
            return true
        default:
            return false
        }
    }
    
}
