//
//  NSData+text.swift
//  SlipboxApp
//
//  Created by Karin Prater on 05.12.20.
//

import Foundation

extension Data {
    
    func toAttributedString() -> NSAttributedString {
      
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [.documentType: NSAttributedString.DocumentType.rtfd, .characterEncoding: String.Encoding.utf8]
        
        let result = try? NSAttributedString(data: self, options: options, documentAttributes: nil)
        
        return result ?? NSAttributedString(string: "")
    }
    
}

extension NSAttributedString {
    
    func toData() -> Data? {
        
        let options: [NSAttributedString.DocumentAttributeKey : Any] = [.documentType: NSAttributedString.DocumentType.rtfd, .characterEncoding: String.Encoding.utf8]
        
        let range = NSRange(location: 0, length: length)
        let result = try? data(from: range, documentAttributes: options)

        return result
    }
    
}
