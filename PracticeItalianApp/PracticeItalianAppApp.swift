//
//  PracticeItalianAppApp.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import CoreData
import RevenueCat

@main
struct PracticeItalianAppApp: App {
    
    init(){
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_ovUEAVTrEheazquVubleUREAkbH", appUserID: nil)
        
        
    }
    

    
    let persistenceController = PersistenceController.shared
    @StateObject var audioManager = AudioManager()
    @StateObject var listeningActivityManager = ListeningActivityManager()
    @StateObject var globalModel = GlobalModel()
    @StateObject var inAppPurchaseModel = InAppPurchaseModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(audioManager)
                .environmentObject(listeningActivityManager)
                .environmentObject(globalModel)
                .environmentObject(inAppPurchaseModel)
        }
    }
}
