//
//  DataTypeDragItem.swift
//  SlipboxApp
//
//  Created by Karin Prater on 08.12.20.
//


import Foundation
import SwiftUI

#if os(iOS)
import MobileCoreServices
#endif

public let dragTypeID = "com.slipboxapp.datatype"

enum EncodingError: Error {
  case invalidData
}

public class DataTypeDragItem: NSObject, Codable {
    
    // MARK: - Properties
    public var id: String?
    public var type: String?
    
    // MARK: - Initialization
    public required init(
        id: String? = nil,
        type: String? = nil
    ) {
        self.id = id
        self.type = type
    }
    
    public required init(_ info: DataTypeDragItem) {
        self.id = info.id
        self.type = info.type
        super.init()
    }
}

// MARK: - NSItemProviderWriting
extension DataTypeDragItem: NSItemProviderWriting {

    public static var writableTypeIdentifiersForItemProvider: [String] {
        //Different than in tutorial
        //there is a problem for macos
        //if you are on IOS the dragTypeId is enough
        return [dragTypeID, kUTTypeData as String]
    }
    
    public func loadData(
      withTypeIdentifier typeIdentifier: String,
      forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
        do {
            let coder = JSONEncoder()
            let myJSON = try coder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(myJSON, nil)

        } catch {
            print("error \(error.localizedDescription)")
          completionHandler(nil, error)
        }

      return progress
    }
}





// MARK: - NSItemProviderReading
extension DataTypeDragItem: NSItemProviderReading {
    public static var readableTypeIdentifiersForItemProvider: [String] {
        //Different than in tutorial
        //there is a problem for macos
        //if you are on IOS the dragTypeId is enough
        return [dragTypeID, kUTTypeData as String]
    }
    
    public static func object(withItemProviderData data: Data,
                              typeIdentifier: String) throws -> Self {

        let decoder = JSONDecoder()
        
        do {
            let item = try decoder.decode(DataTypeDragItem.self, from: data)
            return self.init(item)
            
        } catch {
            throw EncodingError.invalidData
        }
    }

    
}
