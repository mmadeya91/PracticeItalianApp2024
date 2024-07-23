//
//  DropViewDelegate.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/21/23.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    
     var currentItem: dialogueBox
     @Binding var items: [dialogueBox]
     @Binding var draggingItem: dialogueBox?
     //@Binding var updating: Bool

     func performDrop(info: DropInfo) -> Bool {
         draggingItem = nil
         //self.updating = false// <- HERE
         return true
     }
     
     func dropEntered(info: DropInfo) {
         //self.updating = true
         
         if let draggingItem {
             let fromIndex = items.firstIndex(of: draggingItem)
             if let fromIndex{
                 let toIndex = items.firstIndex(of: currentItem)
                 if let toIndex, fromIndex != toIndex {
                     
                     withAnimation {
                         self.items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                     }
                     
                 }
             }
             
             
             
         }
         
         
         
//         if currentItem.id != draggingItem.wrappedValue?.id {
//             let from = items.wrappedValue.firstIndex(of: draggingItem.wrappedValue!)!
//             let to = items.wrappedValue.firstIndex(of: currentItem)!
//             if items[to].id != draggingItem.wrappedValue?.id {
//                 items.wrappedValue.move(fromOffsets: IndexSet(integer: from),
//                     toOffset: to > from ? to + 1 : to)
//                 
//             }
//         }
     }
            
     func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
     }
}
