//
//  NavigationStateManager.swift
//  SlipboxApp
//
//  Created by Karin Prater on 07.12.20.
//

import Foundation
import Combine

class NavigationStateManager: ObservableObject {
    
    @Published var selectedNote: Note? = nil
    @Published var selectedFolder: Folder? = nil
    
    @Published var isKey: Bool = false
    
    @Published var showKeyColumn: Bool = true
    @Published var showFolderColumn: Bool = true
    @Published var showNotesColumn: Bool = true
    
    //MARK: - advanced search
    @Published var selectedKewords: Set<Keyword> = []
    @Published var searchText: String = ""
    @Published var searchStatus: Status? = nil
    
    func predicate() -> NSPredicate? {
        
        var predicates = [NSPredicate]()
        
        if selectedKewords.count > 0 {
            let p = NSPredicate(format: "ANY %K in %@ ", NoteProperties.keywords, selectedKewords)
            predicates.append(p)
        }
        if searchText.count > 0 {
            let p1 = NSPredicate(format: "%K CONTAINS[c] %@", NoteProperties.bodyText, searchText as CVarArg)
            let p2 = NSPredicate(format: "%K CONTAINS[c] %@", NoteProperties.title, searchText as CVarArg)
            let p = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
            predicates.append(p)
        }
        if let status = searchStatus {
            let p = NSPredicate(format: "%K = %@", NoteProperties.status, status.rawValue as! CVarArg)
            predicates.append(p)
        }
        
        if predicates.count == 0 {
            return nil
        }else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    
}
