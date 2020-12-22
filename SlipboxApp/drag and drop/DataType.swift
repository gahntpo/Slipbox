//
//  DataType.swift
//  SlipboxApp
//
//  Created by Karin Prater on 08.12.20.
//

import Foundation

enum DataType: String, CaseIterable, Codable {
    
    case keyword = "keyword"
    case note = "note"
    case folder = "folder"
    case reference = "reference"
    
    static func type(string: String) -> DataType? {
        
        if string == keyword.rawValue {
            return DataType.keyword
        }else if string == note.rawValue {
            return DataType.note
        }else  if string == folder.rawValue {
            return DataType.folder
        }else  if string == reference.rawValue {
            return DataType.reference
        }else {
            return nil
        }
    }
}
