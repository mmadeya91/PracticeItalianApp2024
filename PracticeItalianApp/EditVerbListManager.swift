//
//  EditVerbListManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/22/24.
//

import Foundation

import CoreData

final class EditVerbListManager: ObservableObject{
    var viewContext: NSManagedObjectContext = PersistenceController.preview.container.viewContext
    
    @Published var fetchedUserVerbList: [UserVerbList] = [UserVerbList]()
    @Published var allAvailableVerbs: [verbObject] = [verbObject]()
    
    init(){
        fetchedUserVerbList = self.loadUserFlashCardList()
        allAvailableVerbs = self.loadAllFlashCards()
        
    }
    
    func updateObservableList(){
        let fR = UserVerbList.fetchRequest()

        var results = [UserVerbList]()
        
        do {
            results = try viewContext.fetch(fR)
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
       
        fetchedUserVerbList = results
    }
    
    func loadUserFlashCardList()->[UserVerbList]{
        
        let fR = UserVerbList.fetchRequest()

        var results = [UserVerbList]()
        
        do {
            results = try viewContext.fetch(fR)
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
       
        return results
        
 
    }
    
    func loadAllFlashCards()->[verbObject]{
        
        //First Load the flashcard that are prepopulated from the json file
        var allVerbs:[verbObject] = verbObject.allVerbObject
        return allVerbs
        
 
    }
    
    func isEmptyMyListVerbData() -> Bool {
        
        let fR = UserVerbList.fetchRequest()
        
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

    
    func addNewUserAddedVerb(verbNameItal: String, verbNameEngl: String, presente: [String], passatoProssimo: [String], futuro: [String], imperfetto: [String], condizionale: [String], imperativo: [String]){
        
        
        let newUserAddedVerb = UserVerbList(context: viewContext)
        
        newUserAddedVerb.verbNameItalian = verbNameItal
        newUserAddedVerb.verbNameEnglish = verbNameEngl
        newUserAddedVerb.presente = presente
        newUserAddedVerb.passatoProssimo = passatoProssimo
        newUserAddedVerb.futuro = futuro
        newUserAddedVerb.imperfetto = imperfetto
        newUserAddedVerb.condizionale = condizionale
        newUserAddedVerb.imperativo = imperativo
   
       
        self.saveVerbListData()

    }
    
    
    func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach { i in
            viewContext.delete(fetchedUserVerbList[i])
        }
        
        self.fetchedUserVerbList.remove(atOffsets: offsets)
       
        self.saveVerbListData()
        
       // editMyFlashCardListVM.objectWillChange.send()
        //editMyFlashCardListVM.fetchedUserCreatedFlashCards.remove(atOffsets: offsets)
        //listViewOfAvailableVerbsVM.setFetchedData(arrayIn: availableVerbs)
        
    }
    
    func deleteUserList(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserVerbList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    func saveVerbListData() {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    

    
}
