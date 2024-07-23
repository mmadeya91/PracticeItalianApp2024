//
//  EditFlashCardListManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/21/24.
//

import Foundation

import CoreData

final class EditMyFlashCardListManager: ObservableObject{
    var viewContext: NSManagedObjectContext = PersistenceController.preview.container.viewContext
    
    @Published var fetchedUserCreatedFlashCards: [UserFlashCardList] = [UserFlashCardList]()
    @Published var allAvailableFlashCards: [Word] = [Word]()
    
    init(){
        fetchedUserCreatedFlashCards = self.loadUserFlashCardList()
        allAvailableFlashCards = self.loadAllFlashCards()
        
    }
    
    func updateObservableList(){
        let fR = UserFlashCardList.fetchRequest()

        var results = [UserFlashCardList]()
        
        do {
            results = try viewContext.fetch(fR)
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
       
        fetchedUserCreatedFlashCards = results
    }
    
    func loadUserFlashCardList()->[UserFlashCardList]{
        
        let fR = UserFlashCardList.fetchRequest()

        var results = [UserFlashCardList]()
        
        do {
            results = try viewContext.fetch(fR)
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
       
        return results
        
 
    }
    
    func loadAllFlashCards()->[Word]{
        
        //First Load the flashcard that are prepopulated from the json file
        let tempArray: [flashCardObject] = flashCardObject.allFlashCardObjects
        
        var allFlashCards:[Word] = []
        
        for i in 0...tempArray.count-1 {
            for x in 0...tempArray[i].words.count-1{
                allFlashCards.append(tempArray[i].words[x])
            }
        }
        
        //now load the flash cards that the user made
        let fR = UserMadeFlashCard.fetchRequest()

        var results = [UserMadeFlashCard]()
        
        do {
            results = try viewContext.fetch(fR)
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
        //Add the user made flash cards to the list that help prepopulated json cards
        for flashCard in results{
            allFlashCards.append(Word(wordItal: flashCard.italianLine1!, gender:  flashCard.englishLine2!, wordEng: flashCard.englishLine1!))
        }
        
       
        return allFlashCards
        
 
    }
    
    func isEmptyMyListFlashCardData() -> Bool {
        
        let fR = UserFlashCardList.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }

    
    func addNewUserAddedFlashCard(engLine1: String, italLine1: String, italLine2: String, engLine2: String){
        
        
        let newUserAddedFlashCardList = UserFlashCardList(context: viewContext)
        
        newUserAddedFlashCardList.englishLine1 = engLine1
        newUserAddedFlashCardList.italianLine1 = italLine1
        if italLine2.isEmpty {
            newUserAddedFlashCardList.italianLine2 = " "
        }else{
            newUserAddedFlashCardList.italianLine2 = italLine2
        }
        
        if engLine2.isEmpty {
            newUserAddedFlashCardList.englishLine2 = " "
        }else{
            newUserAddedFlashCardList.englishLine2 = engLine2
        }
   
       
        self.saveFlashCardListData()

    }
    
    func addItem(f1: String, f2: String, b1: String, b2: String) {
       
            let newUserMadeFlashCard = UserMadeFlashCard(context: viewContext)
            newUserMadeFlashCard.italianLine1 = f1
            newUserMadeFlashCard.italianLine2 = f2
            newUserMadeFlashCard.englishLine1 = b1
            newUserMadeFlashCard.englishLine2 = b2
            
            let newUserMadeFlashCard2 = UserFlashCardList(context: viewContext)
            newUserMadeFlashCard2.italianLine1 = f1
            newUserMadeFlashCard2.italianLine2 = f2
            newUserMadeFlashCard2.englishLine1 = b1
            newUserMadeFlashCard2.englishLine2 = b2
            
        self.saveFlashCardListData()
        
    }
    
    
    func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach { i in
            viewContext.delete(fetchedUserCreatedFlashCards[i])
        }
        
        self.fetchedUserCreatedFlashCards.remove(atOffsets: offsets)
       
        self.saveFlashCardListData()
        
       // editMyFlashCardListVM.objectWillChange.send()
        //editMyFlashCardListVM.fetchedUserCreatedFlashCards.remove(atOffsets: offsets)
        //listViewOfAvailableVerbsVM.setFetchedData(arrayIn: availableVerbs)
        
    }
    
    func deleteUserList(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFlashCardList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    func saveFlashCardListData() {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    

    
}
