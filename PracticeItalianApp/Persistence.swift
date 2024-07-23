//
//  Persistence.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
       for _ in 0..<5 {
         let newItem = UserMadeFlashCard(context: viewContext)
           newItem.englishLine1 = "hello"
           newItem.englishLine2 = "test"
           newItem.italianLine1 = "ciao"
           newItem.italianLine2 = "fem"
           
           let newItem2 = UserFlashCardList(context: viewContext)
             newItem2.englishLine1 = "hello2"
             newItem2.englishLine2 = "test2"
             newItem2.italianLine1 = "ciao2"
             newItem2.italianLine2 = "fem"
           
           let newVerbItem = UserAddedVerb(context: viewContext)
           newVerbItem.verbNameEnglish = "To take"
           newVerbItem.verbNameItalian = "Prendere"
           newVerbItem.presente = ["Prendo", "Prendi", "Prende", "Prendeno", "Prendiamo", "Prendete"]
           newVerbItem.passatoProssimo = ["Ho preso", "Hai preso", "Ha preso", "Hanno preso", "Abbiamo preso", "Avete preso"]
           newVerbItem.futuro = ["Prendero", "Prenderei", "Prendere", "Prendereno", "Prenderemo", "Prenderete"]
           newVerbItem.imperativo = ["Prendi", "Prendi", "Prende", "Prendeni", "Prendi", "Prendi"]
           newVerbItem.imperfetto = ["Prendevo", "Prendevi", "Prendeve", "Prendevano", "Prendevamo", "Prendevate"]
           newVerbItem.condizionale = ["Prenderrei", "Prenderesti", "Prenderebbe", "Prenderebbero", "Prenderebiamo", "Prenderette"]
           
           let newVerbListItem = UserVerbList(context: viewContext)
           newVerbListItem.verbNameEnglish = "To take"
           newVerbListItem.verbNameItalian = "Prendere"
           newVerbListItem.passatoProssimo = ["Ho preso", "Hai preso", "Ha preso", "Hanno preso", "Abbiamo preso", "Avete preso"]
           newVerbListItem.futuro = ["Prendero", "Prenderei", "Prendere", "Prendereno", "Prenderemo", "Prenderete"]
           newVerbListItem.imperativo = ["Prendi", "Prendi", "Prende", "Prendeni", "Prendi", "Prendi"]
           newVerbListItem.imperfetto = ["Prendevo", "Prendevi", "Prendeve", "Prendevano", "Prendevamo", "Prendevate"]
           newVerbListItem.condizionale = ["Prenderrei", "Prenderesti", "Prenderebbe", "Prenderebbero", "Prenderebiamo", "Prenderette"]
           
        
           
           
        }
        

        
        let tempString: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own"]
        
        for setName in tempString {
            let newFlashCardSetAccuracyItem = FlashCardSetAccuracy(context: viewContext)
            newFlashCardSetAccuracyItem.correct = 0
            newFlashCardSetAccuracyItem.incorrect = 0
            newFlashCardSetAccuracyItem.setName = setName
        }
        
        let userCoinMockData = UserCoins(context: viewContext)
            userCoinMockData.coins = 10
            userCoinMockData.id = UUID()
        
        let userUnlockedData = UserUnlockedDataSets(context: viewContext)
        userUnlockedData.dataSetName = "Stili di Bellagio"
        userUnlockedData.isUnlocked = false
        let userUnlockedData2 = UserUnlockedDataSets(context: viewContext)
        userUnlockedData2.dataSetName = "Indicazioni per gli Uffizi"
        userUnlockedData2.isUnlocked = false
        let userUnlockedData3 = UserUnlockedDataSets(context: viewContext)
        userUnlockedData3.dataSetName = "Il Rinascimento"
        userUnlockedData3.isUnlocked = false
        let userUnlockedData4 = UserUnlockedDataSets(context: viewContext)
        userUnlockedData4.dataSetName = "Food"
        userUnlockedData4.isUnlocked = false
        
        let userCompletedDataIntroduzione = UserCompletedActivities(context: viewContext)
        userCompletedDataIntroduzione.activityName =  "La Mia Introduzione"
        userCompletedDataIntroduzione.isCompleted = false
        
        let userCompletedDataAmico = UserCompletedActivities(context: viewContext)
        userCompletedDataAmico.activityName =  "Il Mio Migliore Amico"
        userCompletedDataAmico.isCompleted = false
        
        let userCompletedDataFamiglia = UserCompletedActivities(context: viewContext)
        userCompletedDataFamiglia.activityName =  "La Mia Famiglia"
        userCompletedDataFamiglia.isCompleted = false
        
        let userStoryComplete = LastStoryCompleted(context: viewContext)
        
        userStoryComplete.storyName = "La Mia Introduzione"
        userStoryComplete.didComplete = false
        
        let userAudioComplete = LastAudioCompleted(context: viewContext)
        
        userAudioComplete.audioName = "Pasta alla Carbonara"
        userAudioComplete.didComplete = false
        
        
        ///firstLaunch items for info bubbles////
        
        let activityFirstLaunch1 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch1.activityName = "chooseStory"
        activityFirstLaunch1.isFirstLaunch = true
        activityFirstLaunch1.id = UUID()
        
        let activityFirstLaunch2 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch2.activityName = "chooseAudio"
        activityFirstLaunch2.isFirstLaunch = true
        activityFirstLaunch2.id = UUID()
        
        let activityFirstLaunch3 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch3.activityName = "chooseFlashCard"
        activityFirstLaunch3.isFirstLaunch = true
        activityFirstLaunch3.id = UUID()
        
        let activityFirstLaunch4 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch4.activityName = "chooseVerbList"
        activityFirstLaunch4.isFirstLaunch = true
        activityFirstLaunch4.id = UUID()
        
        let activityFirstLaunch5 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch5.activityName = "chooseVerbActivity"
        activityFirstLaunch5.isFirstLaunch = true
        activityFirstLaunch5.id = UUID()
        
        let activityFirstLaunch6 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch6.activityName = "shortStoryView"
        activityFirstLaunch6.isFirstLaunch = true
        activityFirstLaunch6.id = UUID()
        
        let activityFirstLaunch7 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch7.activityName = "clickDropShortStory"
        activityFirstLaunch7.isFirstLaunch = true
        activityFirstLaunch7.id = UUID()
        
        let activityFirstLaunch8 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch8.activityName = "plugInShortStory"
        activityFirstLaunch8.isFirstLaunch = true
        activityFirstLaunch8.id = UUID()
        
        let activityFirstLaunch9 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch9.activityName = "listeningActivityView"
        activityFirstLaunch9.isFirstLaunch = true
        activityFirstLaunch9.id = UUID()
        
        let activityFirstLaunch10 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch10.activityName = "dialogueQuestionView"
        activityFirstLaunch10.isFirstLaunch = true
        activityFirstLaunch10.id = UUID()
        
        let activityFirstLaunch11 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch11.activityName = "putInOrderAudio"
        activityFirstLaunch11.isFirstLaunch = true
        activityFirstLaunch11.id = UUID()
        
        let activityFirstLaunch12 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch12.activityName = "flashCardActivity"
        activityFirstLaunch12.isFirstLaunch = true
        activityFirstLaunch12.id = UUID()
        
        let activityFirstLaunch13 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch13.activityName = "multipleChoice"
        activityFirstLaunch13.isFirstLaunch = true
        activityFirstLaunch13.id = UUID()
        
        let activityFirstLaunch14 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch14.activityName = "clickDropConjTable"
        activityFirstLaunch14.isFirstLaunch = true
        activityFirstLaunch14.id = UUID()
        
        let activityFirstLaunch15 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch15.activityName = "spellItOut"
        activityFirstLaunch15.isFirstLaunch = true
        activityFirstLaunch15.id = UUID()
        
        let activityFirstLaunch16 = ActivityFirstLaunch(context: viewContext)
        activityFirstLaunch16.activityName = "chooseVCActivity"
        activityFirstLaunch16.isFirstLaunch = true
        activityFirstLaunch16.id = UUID()
        
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PracticeItalianApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
