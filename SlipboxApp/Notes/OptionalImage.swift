//
//  OptionalImage.swift
//  SlipboxApp
//
//  Created by Karin Prater on 16.12.20.
//

import SwiftUI

struct OptionalImage: View {
    
    let data: Data?
    
    var body: some View {
        Group {
            if data != nil {
                #if os(macOS)
                
                Image(nsImage: NSImage(data:data!) ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .onDrag({
                        let provider = NSItemProvider(item: data as NSSecureCoding?, typeIdentifier: kUTTypeTIFF as String)
                        return provider
                 
                    })
                
                #else
                    Image(uiImage: UIImage(data: data!) ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .onDrag {
                            let provider = NSItemProvider(object: UIImage(data: data!) ?? UIImage())
                            provider.suggestedName = "cat"
                            return provider
                        }
                
                #endif
            }
        }
    }
}

//struct OptionalImage_Previews: PreviewProvider {
//    static var previews: some View {
//        OptionalImage()
//    }
//}
