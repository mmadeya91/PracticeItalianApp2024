//
//  InfoBubbleDataManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/16/24.
//

import Foundation
import SwiftUI
import CoreData

final class InfoBubbleDataManager {
    
    var viewContext: NSManagedObjectContext = PersistenceController.preview.container.viewContext
    
    var activityName: String
    
    static let instance = InfoBubbleDataManager(activityName: "")
    
    init(activityName: String) {
        self.activityName = activityName
    }
    
    
    func getActivityFirstLaunchData() -> ActivityFirstLaunch{
        
        let fR = ActivityFirstLaunch.fetchRequest()
        fR.predicate = NSPredicate(format: "activityName == %@", self.activityName)
        
        var results = [ActivityFirstLaunch]()
        
        do {
            results = try viewContext.fetch(fR)
            return results[0]
        }catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            
        }
        
        return results[0]

    }

    
    func updateCorrectInput(activity: ActivityFirstLaunch) {
            
        activity.isFirstLaunch = false
 

        self.saveActivityFirstLaunchData()
    }

    
    func saveActivityFirstLaunchData() {
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
}
