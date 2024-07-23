//
//  ContentView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import SwiftUIKit
import CoreData

public protocol FullScreenCoverProvider {
    
    var cover: AnyView { get }
}


class GlobalModel: ObservableObject {
    @Published var package1Purchased = false
    
    @Published var userCoins = 25
    
    @Published var appHasBeenOpened = false
    
    @Published var currentUnlockableDataSets:
    [
        ///////////////Audio Fles/////////////
        dataSetObject] = [dataSetObject(setName: "Pasta alla Carbonara", isUnlocked: true, isCompleted: false, isBought: true),
        
        dataSetObject(setName: "Cosa Desidera?", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Indicazioni per gli Uffizi", isUnlocked: false, isCompleted: false, isBought: true),
         dataSetObject(setName: "Stili di Bellagio", isUnlocked: false, isCompleted: false, isBought: true),
         dataSetObject(setName: "Il Rinascimento", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Colloquio di Lavoro", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Alla Ricerca di un Appartamento", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Festival di Sanremo", isUnlocked: false, isCompleted: false, isBought: true),

        /////////////FlashCardSets///////
        dataSetObject(setName: "Food", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Animals", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Clothing", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Family", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Common Nouns", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Common Adjectives", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Common Adverbs", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Common Verbs", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Common Phrases", isUnlocked: true, isCompleted: false, isBought: true),
        
        ////////////////ShortStories/////////////////
        dataSetObject(setName: "La Mia Introduzione", isUnlocked: true, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Mio Migliore Amico", isUnlocked: true, isCompleted: false, isBought: true),
         dataSetObject(setName: "La Mia Famiglia", isUnlocked: false, isCompleted: false, isBought: true),
         dataSetObject(setName: "Le Mie Vacanze in Sicilia", isUnlocked: false, isCompleted: false, isBought: true),
         dataSetObject(setName: "La Mia Routine", isUnlocked: false, isCompleted: false, isBought: true),
         dataSetObject(setName: "Ragù Di Maiale Brasato", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Mio Fine Settimana", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName:"Il Mio Animale Preferito", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Mio Sport Preferito", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Mio Sogno nel Cassetto", isUnlocked: false, isCompleted: false, isBought: true),
        dataSetObject(setName: "Il Mio Ultimo Compleanno", isUnlocked: false, isCompleted: false, isBought: true),
    ]
    
    @Published var lastStoryCompleted = storyCompleted(storyName: "La Mia Introduzione", didComplete: false)
    
    @Published var lastAudioCompleted = audioCompleted(storyName: "Pasta alla Carbonara", didComplete: false)
    
    
    struct storyCompleted: Identifiable{
        var id = UUID()
        var storyName: String
        var didComplete: Bool
    }
    
    struct audioCompleted: Identifiable{
        var id = UUID()
        var storyName: String
        var didComplete: Bool
    }
    
    struct dataSetObject: Identifiable{
        var id = UUID()
        var setName: String
        var isUnlocked: Bool
        var isCompleted: Bool
        var isBought: Bool
        
        
    }
    

    
}


struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var globalModel: GlobalModel
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel
    
    @State var selectedTab = Tab.Home
    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1
    @State var goNext: Bool = false
    @State var navButtonText = "Let's Go!"
    @State var togglePageReload = false
    @State var playingWelcomeScreen = true
    @State var packagePurchased = false
    
    var playWelcomeScreen: Bool {
        return globalModel.appHasBeenOpened
    }
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    @FetchRequest(
        entity: LastStoryCompleted.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedLastStoryCompleted: FetchedResults<LastStoryCompleted>
    
    @FetchRequest(
        entity: LastAudioCompleted.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedLastAudioCompleted: FetchedResults<LastAudioCompleted>
    
    @FetchRequest(
        entity: UserCoins.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedUserCoins: FetchedResults<UserCoins>
    
    @FetchRequest(
        entity: UserUnlockedDataSets.entity(),
        sortDescriptors: [NSSortDescriptor(key: "dataSetName", ascending: true)]
    ) var fetchedUserUnlockedData: FetchedResults<UserUnlockedDataSets>
    
    @FetchRequest(
        entity: UserCompletedActivities.entity(),
        sortDescriptors: [NSSortDescriptor(key: "activityName", ascending: true)]
    ) var fetchedCompletedActivities: FetchedResults<UserCompletedActivities>
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact{
                
                NavigationStack{
                    
                    ZStack{
                        Image("Screen Background")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Image("cypress2")
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.45)
                                    .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.1)
                                  
                            }
                        }
                        
                        VStack{
                            Spacer()
                            HStack{
                                
                                Image("cypress1")
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: geo.size.width * 0.05, height: geo.size.height * 0.5)
                                    .offset(x: -geo.size.width * 0.017, y: geo.size.height * 0.22)
                                    
                               Spacer()
                            }
                        }
                        VStack(spacing: 0){
                            if selectedTab == Tab.Home {
                                ZStack{
                                    WelcomeAnimation().opacity(globalModel.appHasBeenOpened == false ?  1.0 : 0.0)
                                    
                                    HomeScreen().opacity(playingWelcomeScreen ? 0.0 : 1.0)
                                }.zIndex(1)
                            }
                            ZStack{
                                ActivityHeader().opacity(selectedTab == Tab.Reading || selectedTab == Tab.Audio || selectedTab == Tab.Cards || selectedTab == Tab.Verbs ? 1.0 : 0.0).zIndex(0)
                                if selectedTab == Tab.Reading{
                                    availableShortStories()
                                }
                                if selectedTab == Tab.Audio{
                                    chooseAudio()
                                }
                                
                                if selectedTab == Tab.Cards {
                                    chooseFlashCardSet()
                                }
                                if selectedTab == Tab.Verbs {
                                    chooseVerbList()
                                }
                            }
                            
                            
                        }
                        
                        VStack(spacing:0){
                            Spacer()
                            CustomTabBar(selectedTab: $selectedTab).opacity(playingWelcomeScreen ? 0.0 : 1.0).padding(.bottom, 15)
                        }
                    }
                    //.animation(.easeInOut)
                    .onAppear{
                        globalModel.package1Purchased = inAppPurchaseModel.userPurchasedPackage1
                        
                        if inAppPurchaseModel.userPurchasedPackage1{
                            setGlobalUserCompletedActivityData()
                        }
                        addActivityFirstLaunchDataIfNew()
                        addUserCoinsifNew()
                        addUserUnlockedDataifNew()
                        addUserAcitivtyCompleteDataIfNew()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.8) {
                            globalModel.appHasBeenOpened = true
                        }
                        
                        if !globalModel.appHasBeenOpened{
                            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
                                withAnimation(.easeIn(duration: 1.0)) {
                                    playingWelcomeScreen = false
                                }
                            }
                            
                        }else{
                            playingWelcomeScreen = false
                        }
                        
                        
                        if launchedBefore  {
                            print("Not first launch.")
                        } else {
                            print("First launch, setting UserDefault.")
                            UserDefaults.standard.set(true, forKey: "launchedBefore")
                        }
                        
                    }
                }.navigationViewStyle(.stack)
                    .preferredColorScheme(.light)
                    .navigationBarBackButtonHidden(true)
                    .preferredColorScheme(.light)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            else{
                ContentViewIPAD()
            }
            
        }
    }
    

    
    func addUserCoinsifNew(){
        if !userCoinsExists() {
            
            let newUserCoins = UserCoins(context: viewContext)
            newUserCoins.coins = 0
            newUserCoins.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            
        }else{
            globalModel.userCoins = Int(fetchedUserCoins[0].coins)
        }
        
        
    }
    
    func addUserUnlockedDataifNew(){
        if !launchedBefore {
            //AudioFiles
            let userUnlockedData = UserUnlockedDataSets(context: viewContext)
            userUnlockedData.dataSetName = "Stili di Bellagio"
            userUnlockedData.isUnlocked = false
            let userUnlockedData2 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData2.dataSetName = "Indicazioni per gli Uffizi"
            userUnlockedData2.isUnlocked = false
            let userUnlockedData3 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData3.dataSetName = "Il Rinascimento"
            userUnlockedData3.isUnlocked = false
            //ShortStories
            let userUnlockedData5 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData5.dataSetName = "La Mia Famiglia"
            userUnlockedData5.isUnlocked = false
            let userUnlockedData6 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData6.dataSetName = "Le Mie Vacanze in Sicilia"
            userUnlockedData6.isUnlocked = false
            let userUnlockedData7 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData7.dataSetName = "La Mia Routine"
            userUnlockedData7.isUnlocked = false
            let userUnlockedData8 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData8.dataSetName = "Ragù Di Maiale Brasato"
            userUnlockedData8.isUnlocked = false
            let userUnlockedData9 = UserUnlockedDataSets(context: viewContext)
            userUnlockedData9.dataSetName = "Il Mio Fine Settimana"
            userUnlockedData9.isUnlocked = false
            
            //data for storyCompleteHomePage
            
            let userStoryComplete = LastStoryCompleted(context: viewContext)
            
            userStoryComplete.storyName = "La Mia Introduzione"
            userStoryComplete.didComplete = false
            
            let userAudioComplete = LastAudioCompleted(context: viewContext)
            
            userAudioComplete.audioName = "Pasta alla Carbonara"
            userAudioComplete.didComplete = false
            
        
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            
        }else{
            setGlobalUserUnlockedData()
            setLastStoryCompleted()
            setLastAudioCompleted()
        }
        
        
    }
    
    func addActivityFirstLaunchDataIfNew(){
        
        if !launchedBefore {
            
            let activityFirstLaunch1 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch1.activityName = "chooseStory"
            activityFirstLaunch1.isFirstLaunch = true
            
            let activityFirstLaunch2 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch2.activityName = "chooseAudio"
            activityFirstLaunch2.isFirstLaunch = true
            
            let activityFirstLaunch3 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch3.activityName = "chooseFlashCard"
            activityFirstLaunch3.isFirstLaunch = true
            
            let activityFirstLaunch4 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch4.activityName = "chooseVerbList"
            activityFirstLaunch4.isFirstLaunch = true
            
            let activityFirstLaunch5 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch5.activityName = "chooseVerbActivity"
            activityFirstLaunch5.isFirstLaunch = true
            
            let activityFirstLaunch6 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch6.activityName = "shortStoryView"
            activityFirstLaunch6.isFirstLaunch = true
            
            let activityFirstLaunch7 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch7.activityName = "clickDropShortStory"
            activityFirstLaunch7.isFirstLaunch = true
            
            let activityFirstLaunch8 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch8.activityName = "plugInShortStory"
            activityFirstLaunch8.isFirstLaunch = true
            
            let activityFirstLaunch9 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch9.activityName = "listeningActivityView"
            activityFirstLaunch9.isFirstLaunch = true
            
            let activityFirstLaunch10 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch10.activityName = "dialogueQuestionView"
            activityFirstLaunch10.isFirstLaunch = true
            
            let activityFirstLaunch11 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch11.activityName = "putInOrderAudio"
            activityFirstLaunch11.isFirstLaunch = true
            
            let activityFirstLaunch12 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch12.activityName = "flashCardActivity"
            activityFirstLaunch12.isFirstLaunch = true
            
            let activityFirstLaunch13 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch13.activityName = "multipleChoice"
            activityFirstLaunch13.isFirstLaunch = true
            
            let activityFirstLaunch14 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch14.activityName = "clickDropConjTable"
            activityFirstLaunch14.isFirstLaunch = true
            
            let activityFirstLaunch15 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch15.activityName = "spellItOut"
            activityFirstLaunch15.isFirstLaunch = true
            
            let activityFirstLaunch16 = ActivityFirstLaunch(context: viewContext)
            activityFirstLaunch16.activityName = "chooseVCActivity"
            activityFirstLaunch16.isFirstLaunch = true
            activityFirstLaunch16.id = UUID()
            
            
       
        }
    }
    
    func addUserAcitivtyCompleteDataIfNew(){
 
        if !launchedBefore {
            
            let userCompletedDataIntroduzione = UserCompletedActivities(context: viewContext)
            userCompletedDataIntroduzione.activityName =  "La Mia Introduzione"
            userCompletedDataIntroduzione.isCompleted = false
            
            let userCompletedDataAmico = UserCompletedActivities(context: viewContext)
            userCompletedDataAmico.activityName =  "Il Mio Migliore Amico"
            userCompletedDataAmico.isCompleted = false
            
            let userCompletedDataFamiglia = UserCompletedActivities(context: viewContext)
            userCompletedDataFamiglia.activityName =  "La Mia Famiglia"
            userCompletedDataFamiglia.isCompleted = false
            
            let userCompletedDataSicilia = UserCompletedActivities(context: viewContext)
            userCompletedDataSicilia.activityName =  "Le Mie Vacanze in Sicilia"
            userCompletedDataSicilia.isCompleted = false
            
            let userCompletedDataRoutine = UserCompletedActivities(context: viewContext)
            userCompletedDataRoutine.activityName =  "La Mia Routine"
            userCompletedDataRoutine.isCompleted = false
            
            let userCompletedDataRagu = UserCompletedActivities(context: viewContext)
            userCompletedDataRagu.activityName =  "Ragù Di Maiale Brasato"
            userCompletedDataRagu.isCompleted = false
            
            let userCompletedDataSettimana = UserCompletedActivities(context: viewContext)
            userCompletedDataSettimana.activityName =  "Il Mio Fine Settimana"
            userCompletedDataSettimana.isCompleted = false
            
            
            let userCompletedDataCarbonara = UserCompletedActivities(context: viewContext)
            userCompletedDataCarbonara.activityName = "Pasta alla Carbonara"
            userCompletedDataCarbonara.isCompleted = false
            
            
            let userCompletedDataDesidera = UserCompletedActivities(context: viewContext)
            userCompletedDataDesidera.activityName = "Cosa Desidera?"
            userCompletedDataDesidera.isCompleted = false
            
            
            let userCompletedDataUffizi = UserCompletedActivities(context: viewContext)
            userCompletedDataUffizi.activityName =  "Indicazioni per gli Uffizi"
            userCompletedDataUffizi.isCompleted = false
            
            
            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
            userCompletedDataBellagio.activityName = "Stili di Bellagio"
            userCompletedDataBellagio.isCompleted = false
            
            
            let userCompletedDataRinascimento = UserCompletedActivities(context: viewContext)
            userCompletedDataRinascimento.activityName =  "Il Rinascimento"
            userCompletedDataRinascimento.isCompleted = false
            
            //////FLASHCARDS////
//            let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own", "Edit My List"]
//            let userCompletedDataFood = UserCompletedActivities(context: viewContext)
//            userCompletedDataFood.activityName = "Food"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Animals"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Clothing"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Family"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Common Nouns"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Common Adjectives"
//            userCompletedDataBellagio.isCompleted = false
//            
//            let userCompletedDataBellagio = UserCompletedActivities(context: viewContext)
//            userCompletedDataBellagio.activityName = "Common Adverbs"
//            userCompletedDataBellagio.isCompleted = false
            
            ////////////////////
   
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }

        }else{
            setGlobalUserCompletedActivityData()
        }
        
    }
    
 

    
    
    func userCoinsExists() -> Bool {
        
        let fR =  UserCoins.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return false
            }else {
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func userUnlockedDataExists() -> Bool {
        
        let fR =  UserUnlockedDataSets.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return false
            }else {
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func userCompletedActivityExists() -> Bool {
        
        let fR =  UserCompletedActivities.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return false
            }else {
                return true
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
    func setLastStoryCompleted(){
        for entity in fetchedLastAudioCompleted{
            globalModel.lastAudioCompleted.storyName = entity.audioName!
            globalModel.lastAudioCompleted.didComplete = entity.didComplete
                
        }
    }
    
    func setLastAudioCompleted(){
        for entity in fetchedLastStoryCompleted{
            globalModel.lastStoryCompleted.storyName = entity.storyName!
            globalModel.lastStoryCompleted.didComplete = entity.didComplete
                
        }
    }
    
    func setGlobalUserUnlockedData(){
        for dataSet in fetchedUserUnlockedData {
            for i in 0...globalModel.currentUnlockableDataSets.count-1{
                if globalModel.currentUnlockableDataSets[i].setName == dataSet.dataSetName {
                    globalModel.currentUnlockableDataSets[i].isUnlocked = dataSet.isUnlocked
                }
            }
        }
    }
    
    func setGlobalUserCompletedActivityData(){
        for dataSet in fetchedCompletedActivities {
            for i in 0...globalModel.currentUnlockableDataSets.count-1{
                if globalModel.currentUnlockableDataSets[i].setName == dataSet.activityName {
                    globalModel.currentUnlockableDataSets[i].isCompleted = dataSet.isCompleted
                }
            }
        }
    }
    

    
    
    struct homePageText: View {
        var body: some View {
            
            ZStack{
                VStack{
                    Text("Title")
                        .bold()
                        .font(Font.custom("Marker Felt", size: 50))
                        .foregroundColor(Color.green)
                        .zIndex(1)
                    
                }.frame(width: 350, height: 300)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                
            }
        }
    }
    
    
}

struct WelcomeAnimation2: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass



    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1


    var body: some View {
                        GeometryReader{ geo in
                            ZStack(alignment: .topLeading){
                                Image("Screen Background")
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Image("Right Tree")
                                            .resizable()
                                            .scaledToFill()
                                            .edgesIgnoringSafeArea(.all)
                                            .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.08, alignment: .center)
                                            .offset(x:5)
                                    }
                                }
        
                                VStack{
                                    Spacer()
                                    HStack{
        
                                        Image("Left Tree")
                                            .resizable()
                                            .scaledToFill()
                                            .edgesIgnoringSafeArea(.all)
                                            .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.08, alignment: .center)
                                            .offset(x:-5)
                                        Spacer()
                                    }
                                }
                                VStack{
                                    Text("Title")
                                        .bold()
                                        .font(Font.custom("Marker Felt", size: 50))
                                        .foregroundColor(Color.green)
                                        .zIndex(1)
                    
                                }.frame(width: 350, height: 300)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(10)
        
        
        
                                if showBearAni {
                                    GifImage("italAppGif")
                                        .offset(x: CGFloat(-var_x*700+240), y: 400)
                                        .animation(.linear(duration: 11 ))
                                        .onAppear { self.var_x *= -1}
        
                                }
        
        
                            }.onAppear{
                                //showBearAni = true
                                //SoundManager.instance.playSound(sound: .introMusic)
                            }
                        }
    
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
            .environmentObject(GlobalModel())
            .environmentObject(InAppPurchaseModel())
    }
}


