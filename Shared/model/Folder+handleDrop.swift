//
//  Folder+handleDrop.swift
//  SlipboxApp
//
//  Created by Karin Prater on 19.12.20.
//

import Foundation
import CoreData


extension Folder {
    
    //NEW add the right index
    func add(subfolder: Folder, at order: Int32? = nil) {
        subfolder.parent = nil
        guard let order = order else {
            let newOrder =  self.children.sorted().last?.order ?? -1
            subfolder.order = newOrder + 1
            subfolder.parent = self
            return
        }

        let over = self.children.filter { $0.order >= order }
        
        for folder in over {
            folder.order += 1
        }
        subfolder.parent = self
        subfolder.order = order
        
        for (i, f) in self.children.sorted().enumerated() {
            f.order = Int32(i)
        }
    }

    
    func handleMovedDrop(with providers: [NSItemProvider], dropStatus: DropStatus) -> Bool {
        
        guard let context = self.managedObjectContext else {
            return false
        }
        let found = providers.loadObjects(ofType: DataTypeDragItem.self) { (item) in
            switch dropStatus {
            case .note:
                if let droppedNote = Note.fetch(id: item.id, in: context) {
                self.add(note: droppedNote)
                }
           
            case .folderAfter, .folderBefore, .subfolder:
                if let droppedFolder = Folder.fetch(id: item.id, in: context),
                    !self.allParentFolders().contains(droppedFolder) {
                    //don't add parent as child -> loops
                    
                    let index: Int32 = (dropStatus == .folderBefore) ? 0 : 1
                    //folderAfter should have order + 1
                    
                    if dropStatus == .folderBefore || dropStatus == .folderAfter, let parent = self.parent {
                        //if we have a parent folder who will do the work
                        parent.add(subfolder: droppedFolder, at: self.order + index)
                        
                    }else if  dropStatus == .folderBefore || dropStatus == .folderAfter {
                        //we don't have a parent folder, so we need to sort the folders at the top level
                        droppedFolder.parent = nil
                       
                        let requeset = Folder.topFolderFetch()
                        var result = ( try? context.fetch(requeset)) ?? []
                        let index = result.firstIndex(of: droppedFolder) ?? 0
                        result.remove(at: index)
                        
                        var runningIndex = Int32(0)
                        for f in result {
                            if f == self && dropStatus == .folderAfter {
                                droppedFolder.order = runningIndex + 1
                                f.order = runningIndex
                                runningIndex += 1
                            }else if  f == self && dropStatus == .folderBefore {
                                droppedFolder.order = runningIndex
                                f.order = runningIndex + 1
                                runningIndex += 1
                            }else {
                                f.order = runningIndex
                            }
                            runningIndex += 1
                            
                        }
                        
                    }else if dropStatus == .subfolder {
                        self.add(subfolder: droppedFolder, at: 0)
                    }
                    
                }
            default:
                return
            }
        }
        return found
    }
    
    
    func allParentFolders() -> [Folder] {
        //can get all parent folders
        var parents = [Folder]()
        var refFolder = self.parent
        while refFolder != nil {
            parents.append(refFolder!)
            refFolder = refFolder?.parent
        }
        return parents.reversed()
    }
    
    func fullFolderPath() -> [Folder] {
        var parents = allParentFolders()
        parents.insert(self, at: 0)
        //order: first folder is top folder, last folder is folder itself
        //can use to show full folder paths like parents[0].name / parents[1].name / parents[2].name / self.name
        return parents.reversed()
    }
    
}
