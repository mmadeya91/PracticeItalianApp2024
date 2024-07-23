//
//  HomeScreen.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/9/24.
//

import SwiftUI

extension Image {
    
    func imageIconModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(10)
            .frame(width: 115, height: 120)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 6))
    }
}


struct HomeScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showingSheet = false
    @State var selectedTab: Tab = .Home
    @State var animatingBear = false
    @State var showChatBubble = false
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel   
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    
   
    
    
    var body: some View {
        GeometryReader{ geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                  
                    
                    VStack{
                        
                        VStack(spacing: 0){
                            Image("euro-2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 55)
                            
                            
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 35))
                                //.padding(.leading, 10)
                        }.frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1).padding([.leading, .trailing], geo.size.width * 0.4)
                            .padding(.top, 70)
                        
    
                            
                        VStack{
                            VStack(spacing: 80){
                               
    
                                    nextAudio().frame(width:geo.size.width * 0.85, height: geo.size.width * 0.15).zIndex(2)
                                
                                
                                    nextStory().frame(width:geo.size.width * 0.85, height: geo.size.width * 0.15).zIndex(2)
                                
                            }.padding(.bottom, 28)
                            
                        }.frame(width:geo.size.width * 0.93, height: geo.size.width * 0.8).background(Color("ForestGreen").opacity(0.0)).cornerRadius(20).padding(.top, 50)
                        
                        
                        Rectangle()
                                .fill(Color("terracotta"))
                                .frame(width: geo.size.width * 0.9, height:6)
                                .edgesIgnoringSafeArea(.horizontal)
                                .padding(.top, 15)
                                .padding(.bottom, 40)
                        
                        Button(action: {
                            showingSheet = true
                        }, label: {
                            VStack{
                                Image("shoppingCart")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 45, height: 45)
                                    .padding(.top, 10)
                                
                                Text("Store")
                                    .font(Font.custom("Georgia", size: 16))
                                    .foregroundColor(.black)
                                    .offset(x:3)
                                
                            }
                        })
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }.sheet(isPresented: $showingSheet) {
                    SheetViewHomeScreen()
                }
                .onAppear{
                    
                
                    if inAppPurchaseModel.userPurchasedPackage1 {
                        addPurchaseCompleteData()
                    }
                }
            }else{
                chooseActivityIPAD()
            }
        }
        .navigationBarHidden(true)
        
    }
    
    func addPurchaseCompleteData(){
        let userCompletedDataAnimale = UserCompletedActivities(context: viewContext)
        userCompletedDataAnimale.activityName =  "Il Mio Animale Preferito"
        userCompletedDataAnimale.isCompleted = false
        
        let userCompletedDataSport = UserCompletedActivities(context: viewContext)
        userCompletedDataSport.activityName =  "Il Mio Sport Preferito"
        userCompletedDataSport.isCompleted = false
        
        let userCompletedDataSogno = UserCompletedActivities(context: viewContext)
        userCompletedDataSogno.activityName =  "Il Mio Sogno nel Cassetto"
        userCompletedDataSogno.isCompleted = false
        
        let userCompletedDataCompleanno = UserCompletedActivities(context: viewContext)
        userCompletedDataCompleanno.activityName =  "Il Mio Ultimo Compleanno"
        userCompletedDataCompleanno.isCompleted = false
        
        
        
        let userCompletedDataAppartamento = UserCompletedActivities(context: viewContext)
        userCompletedDataAppartamento.activityName =  "Alla Ricerca di un Appartamento"
        userCompletedDataAppartamento.isCompleted = false
        
        let userCompletedDataColloquio = UserCompletedActivities(context: viewContext)
        userCompletedDataColloquio.activityName =  "Il Colloquio di Lavoro"
        userCompletedDataColloquio.isCompleted = false
        
        let userCompletedDataSanremo = UserCompletedActivities(context: viewContext)
        userCompletedDataSanremo.activityName =  "Il Festival di Sanremo"
        userCompletedDataSanremo.isCompleted = false
        
        do {
            try viewContext.save()
        } catch {
            print("error saving")
        }
    }

}

struct SheetViewHomeScreen: View{
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel
    @State var attemptToBuyPopUp = false
    var body: some View {
        
        GeometryReader{ geo in
            
            ZStack(alignment: .topLeading){
                Image("Screen Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .tint(Color.black)
                    
                }).padding().zIndex(2).padding(.top, 20)
                
     
                VStack{
                 
                    
                    StorePage(selectedSubscription: .lessonPack1)

                    
                    
               
                        
//                        Button(action: {
//                            inAppPurchaseModel.makePurchase(product: inAppPurchaseModel.products[0])
//                        }, label: {
//                            
//                            VStack{
//                                
//                                Text(inAppPurchaseModel.userPurchasedPackage1 ? "Purchased" : "$5.99")
//                                    .font(Font.custom("Georgia", size: 15))
//                                    .foregroundColor(.black)
//                                
//                                    .padding(.top, 5)
//                                
//                            }
//                        }).disabled(inAppPurchaseModel.userPurchasedPackage1 ? true : false)
//                            .buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: geo.size.width * 0.35, height: geo.size.height * 0.25)
                    //                            .shadow(radius:1.5)
                    
                    
                    
                    
                    
                }
            }
            
        }
        
        
        
    }
    
    
}

struct nextAudio: View{
    
    @EnvironmentObject var globalModel: GlobalModel
    
    var audioImages: [String] = ["pot", "dinner", "directions", "clothesStore", "renaissance"]
    @StateObject var listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    
    @State var goToAudio = false
  
    var body: some View{
        GeometryReader{geo in
  
            VStack{
                HStack{
                    Text(globalModel.lastAudioCompleted.didComplete ? "Try next" : "Try again")
                        .font(Font.custom("Trebuchet", size: 18))
                        .bold()
                        .foregroundColor(.black)
                        .overlay(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 80, height: 1.5).offset(y:1.75)
                            , alignment: .bottom
                               
                        )
                        .padding(.leading, 5)
                    Spacer()
                }.padding(.bottom, 10)
                
                NavigationLink(destination: listeningActivity( listeningActivityVM: listeningActivityVM), isActive: $goToAudio, label: {
                    Button(action: {
                        goToAudio = true
                    }, label: {
                        HStack{
                            VStack(spacing: 10){
                                HStack{
                                    Text("Audio:")
                                        .font(Font.custom("Georgia", size: 15))
                                        .foregroundColor(.black)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                  
                                HStack{
                                    Text(globalModel.lastAudioCompleted.didComplete ? findNextAudioName(finishedIn: globalModel.lastAudioCompleted.storyName) : globalModel.lastAudioCompleted.storyName)
                                        .font(Font.custom("Georgia", size: 17))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image(findNextAudioImage(finishedIn: globalModel.lastAudioCompleted.storyName))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .padding()
                        }
                    }).buttonStyle(ThreeDButton(backgroundColor: "white"))
                    
                    
                    
                }).id(UUID())
                    .simultaneousGesture(TapGesture().onEnded{
                        listeningActivityVM.setAudioData(chosenAudio: globalModel.lastAudioCompleted.storyName)
                    })
            }
                    
                        
                        
        }
    }
    
    
    func findNextAudioName(finishedIn: String)->String{
        let availableAudio: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
        
        
        let nextStoryIndex: Int = availableAudio.firstIndex(of: finishedIn)! + 1
        var nextAudio = ""
        
        if isAudioUnlocked(nextAudio: availableAudio[nextStoryIndex]){
            return availableAudio[nextStoryIndex]
        }else{
            
            var counter = nextStoryIndex
            var nextAudioFound = false
            
            while nextAudioFound == false {
                counter = (counter + 1) % availableAudio.count
                
                if isAudioUnlocked(nextAudio: availableAudio[counter]){
                    nextAudioFound = true
                    return availableAudio[counter]
                }
                
            }
            
        }
        return nextAudio
    }
    
    func isAudioUnlocked(nextAudio: String)->Bool{
        var isUnlocked = false
        for i in 0...globalModel.currentUnlockableDataSets.count-1{
            if globalModel.currentUnlockableDataSets[i].setName == nextAudio{
                isUnlocked = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
        
        return isUnlocked
    }
    
    func findNextAudioImage(finishedIn: String)->String{
        let availableAudio: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
        
        let nextStoryIndex: Int = availableAudio.firstIndex(of: finishedIn)!
        
        return audioImages[nextStoryIndex]
    }
    
    func findNextStoryName(finishedIn: String)->(String){
        let availableStories: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana"]
        
        let nextStoryIndex: Int = availableStories.firstIndex(of: finishedIn)! + 1
        var nextStory = ""
        
        if isStoryUnlocked(nextStory: availableStories[nextStoryIndex]){
            return availableStories[nextStoryIndex]
        }else{
            
            var counter = nextStoryIndex
            var nextStoryFound = false
            
            while nextStoryFound == false {
                counter = (counter + 1) % availableStories.count
                
                if isStoryUnlocked(nextStory: availableStories[counter]){
                    nextStoryFound = true
                    return availableStories[counter]
                }
                
            }
            
        }
        return nextStory
    }
    
    func isStoryUnlocked(nextStory: String)->Bool{
        var isUnlocked = false
        for i in 0...globalModel.currentUnlockableDataSets.count-1{
            if globalModel.currentUnlockableDataSets[i].setName == nextStory{
                isUnlocked = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
        
        return isUnlocked
    }
}

struct nextStory: View{
    
    @EnvironmentObject var globalModel: GlobalModel
  @State var goToStory = false
    var body: some View{
        GeometryReader{geo in
   
                        
                        var storyData: shortStoryData { shortStoryData(chosenStoryName: globalModel.lastStoryCompleted.storyName)}
                        
                        
                        var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
            VStack{
                HStack{
                    
                    Text(globalModel.lastStoryCompleted.didComplete ? "Try next" : "Try again")
                        .font(Font.custom("Trebuchet", size: 18))
                        .bold()
                        .foregroundColor(.black)
                        .overlay(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 80, height: 1.5)//.offset(y:1.5)
                            , alignment: .bottom
                               
                        )
                        .padding(.leading, 5)
                    Spacer()
                }.padding(.bottom, 10)
                
                NavigationLink(destination: shortStoryView(chosenStoryNameIn: globalModel.lastStoryCompleted.storyName, shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: globalModel.lastStoryCompleted.storyName), storyData: storyData, storyObj: storyObj), isActive: $goToStory, label: {
                    
                    Button(action: {
                        goToStory = true
                    }, label: {
                        HStack{
                            VStack(spacing: 10){
                                HStack{
                                    Text("Short Story:")
                                        .font(Font.custom("Georgia", size: 15))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                HStack{
                                    Text(globalModel.lastStoryCompleted.didComplete ? findNextStoryName(finishedIn: globalModel.lastStoryCompleted.storyName) : globalModel.lastStoryCompleted.storyName)
                                        .font(Font.custom("Georgia", size: 17))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.leading, 20)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image("book3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .padding()
                        }
                    }).buttonStyle(ThreeDButton(backgroundColor: "white"))
                    
                    
                }).id(UUID())
            }
         
      
          
        }
    }
    
    func findNextStoryName(finishedIn: String)->(String){
        var availableStories: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana"]
        
        var nextStoryIndex: Int = availableStories.firstIndex(of: finishedIn)! + 1
        var nextStory = ""
        
        if isStoryUnlocked(nextStory: availableStories[nextStoryIndex]){
            return availableStories[nextStoryIndex]
        }else{
            
            var counter = nextStoryIndex
            var nextStoryFound = false
            
            while nextStoryFound == false {
                counter = (counter + 1) % availableStories.count
                
                if isStoryUnlocked(nextStory: availableStories[counter]){
                    nextStoryFound = true
                    return availableStories[counter]
                }
                
            }
            
        }
        return nextStory
    }
    

    
    
    func isStoryUnlocked(nextStory: String)->Bool{
        var isUnlocked = false
        for i in 0...globalModel.currentUnlockableDataSets.count-1{
            if globalModel.currentUnlockableDataSets[i].setName == nextStory{
                isUnlocked = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
        
        return isUnlocked
    }
}

#Preview {
    HomeScreen().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AudioManager())
        .environmentObject(GlobalModel())
        .environmentObject(InAppPurchaseModel())
    
}
