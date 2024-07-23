//
//  chooseFlashCardSet.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI

struct chooseFlashCardSet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var globalModel: GlobalModel
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    @State private var attemptToBuyPopUp = false
    @State private var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    @State var showListEmptyPopUp = false
    
    @State var listIsEmpty = false
    
    let flashCardSetAccManager = FlashCardSetAccDataManager()
    
    
    @FetchRequest var flashCardSetAccData: FetchedResults<FlashCardSetAccuracy>

    init() {
        self._flashCardSetAccData = FetchRequest(entity: FlashCardSetAccuracy.entity(), sortDescriptors: [])
    }
    
    @FetchRequest(
        entity: UserUnlockedDataSets.entity(),
        sortDescriptors: []
    ) var fetchedUserUnlockedData: FetchedResults<UserUnlockedDataSets>
    
    @FetchRequest(
        entity: UserCoins.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedUserCoins: FetchedResults<UserCoins>
    

    
    
    var body: some View {
        GeometryReader{ geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                   
                    
//                    HStack(alignment: .top){
//
//                        HStack{
//                            Image("euro-2")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 38, height: 38)
//                            Text(String(globalModel.userCoins))
//                                .font(Font.custom("Arial Hebrew", size: 25))
//                        }.padding(.leading, 45)
//                            .padding(.top, 20)
//                        Spacer()
//                        
//                    }
//                    
//                    
//                    
//                    Image("bearHalf")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.12, height: geo.size.width * 0.1)
//                        .padding(.top, animatingBear ? geo.size.height * 0.09 : geo.size.height * 0.145)
//                        .offset(x:geo.size.width * 0.6)
//                        //.offset(y:geo.size.width / 3)
//                        .zIndex(0)
                    
                    VStack{
                        
                        flashCardSets(setAccData: flashCardSetAccData, showInfoPopup: $showInfoPopUp, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName, showListEmptyPopUp: $showListEmptyPopUp)  .padding([.top, .bottom], geo.size.height * 0.14)
                    }
                    
                    if showInfoPopUp{
                        ZStack(alignment: .topLeading){
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)){
                                    showInfoPopUp.toggle()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 15)
                                .padding(.bottom, 10)
                                .zIndex(1)
                             
                           
                         
             
                                
                                Text("Use the provided flash card sets to increase your vocabulary! Or, make your own using the 'Make Your Own' feature. \n \nEach flash card set displays your accuracy under the corresponding image to let you know which words you need to work most on during your practice.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.top, 15)
                         
                        }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.82)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                            .opacity(showInfoPopUp ? 1.0 : 0.0)
                            .zIndex(2)
                        
                        
                    }
                    
                    if showListEmptyPopUp{
                        ZStack(alignment: .topLeading){
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)){
                                    showListEmptyPopUp.toggle()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 15)
                                .zIndex(1)
                                .offset(y: -15)
                           
                         
             
                                
                                Text("Your 'MyList' is empty. \nPlease go to the 'EditMyList' page and add some flashcards to enable this activity.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.top, 15)
                         
                        }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.55)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                            .opacity(showListEmptyPopUp ? 1.0 : 0.0)
                            .zIndex(2)
                        
                        
                    }
                    
                    if attemptToBuyPopUp{
                        VStack{
                            VStack{
                                Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' flash card set?")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                if notEnoughCoins{
                                    Text("Sorry! You don't have enough coins!")
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }
                                
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                          
                                            attemptToBuyPopUp = false
                                            }
                                        
                                    }, label: {Text("Yes")
                                            .font(.system(size: 20))
                                    }).opacity(notEnoughCoins ? 0.0 : 1.0)
                                    Spacer()
                                    Button(action: {
                                        attemptToBuyPopUp = false
                                    }, label: {Text("No")
                                            .font(.system(size: 20))
                                    }).opacity(notEnoughCoins ? 0.0 : 1.0)
                                    Spacer()
                                }.padding(.top, 20)
                                
                            }
                        }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.6)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                            .opacity(attemptToBuyPopUp ? 1.0 : 0.0)
                        
                    }
                    
                    
                }.onAppear{
                    listIsEmpty = isEmptyMyListFlashCardData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeIn(duration: 0.75)){
                            
                            animatingBear = true
                            
                            
                        }
                    }
                    
                }
            }else{
                chooseFlashCardSetIPAD()
            }
            }.navigationBarBackButtonHidden(true)
     
    }
    
    func isEmptyMyListFlashCardData() -> Bool {
        
        let fR =  UserMadeFlashCard.fetchRequest()
        
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
    
    func unlockData(chosenDataSet: String){
        for dataSet in fetchedUserUnlockedData {
            if dataSet.dataSetName == chosenDataSet {
                dataSet.isUnlocked = true
                updateGlobalModel(chosenDataSet: chosenDataSet)
                do {
                    try viewContext.save()
                } catch {

                    let nsError = error as NSError
                }
            }
        }
    }
    
    func updateGlobalModel(chosenDataSet: String){
        for i in 0...globalModel.currentUnlockableDataSets.count-1 {
            if globalModel.currentUnlockableDataSets[i].setName == chosenDataSet {
                globalModel.currentUnlockableDataSets[i].isUnlocked = true
            }
        }
    }
    
    func checkAndUpdateUserCoins(userCoins: Int, chosenDataSet: String)->Bool{
        if globalModel.userCoins >= 25 {
            fetchedUserCoins[0].coins = Int32(globalModel.userCoins - 25)
            globalModel.userCoins = globalModel.userCoins - 25
            unlockData(chosenDataSet: chosenDataSet)
            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
            }
            return true
        }else{
            notEnoughCoins = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                attemptToBuyPopUp = false
                 notEnoughCoins = false
            }
            return false
        }
    }
}

struct flashCardSets: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @Binding var showListEmptyPopUp: Bool
    
    var infoManager = InfoBubbleDataManager(activityName: "chooseFlashCard")
    
    let infoText:Text =  (Text("Expand your vocab by using the tried and true flash card system. Choose from one of the precreated lists on popular topics or create your own personal practice list by clicking on the Edit My List button. We don't have the word your looking for? No Problem! Create your own flash card inside the Edit My List view.") +
                         Text(" \n\nIf you need some help to understand how to do the Flash Card activity look for the  ") +
                         Text(Image(systemName: "info.circle.fill")) +
                         Text("  symbol."))
    
    var body: some View{
        GeometryReader{ geo in
            VStack(spacing: 0){
                ZStack{
                    HStack{
                        Text("Flash Cards")
                            .font(Font.custom("Georgia", size: 28))
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                        
                        
                        PopOverViewTopWithImages(textIn: infoText, infoBubbleColor: Color.white, frameHeight: CGFloat(360), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                    } .frame(width: geo.size.width * 0.9, height: 60)
                        .background(Color("espressoBrown"))
                        .cornerRadius(15)
                        .shadow(radius: 2)
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: geo.size.width * 0.9, height: 60)
                        .foregroundColor(Color("darkEspressoBrown"))
                        .zIndex(0)
                        .offset(y:7)
                        .shadow(radius: 2)
                        .zIndex(0)
                }.offset(y: -7)
                
                
                flashCardHStack(setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName, showListEmptyPopUp: $showListEmptyPopUp).frame(width:  geo.size.width * 0.86, height: geo.size.height * 0.95)
                        .background(Color("WashedWhite").opacity(0.0)).cornerRadius(10)
                        .padding([.leading, .trailing], geo.size.width * 0.07)
                    
                    
                    
                }.onDisappear{
                    infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                }
            }

        
    }
}

struct flashCardHStack: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @Binding var showListEmptyPopUp: Bool
    var body: some View{
        
        let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own", "Edit My List"]
        
        let flashCardIcons: [String] = ["food", "animal", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking", "flash-card", "flash-card"]
        GeometryReader{geo in
            ScrollView{
                VStack{
                  
                    HStack(spacing: 0){
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[0], flashCardSetIcon: flashCardIcons[0], arrayIndex: 0, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[1], flashCardSetIcon: flashCardIcons[1], arrayIndex: 1, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.frame(width: geo.size.width * 0.9).padding(.top, 15)
                    
                    HStack(spacing: 0){
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[2], flashCardSetIcon: flashCardIcons[2], arrayIndex: 2, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[3], flashCardSetIcon: flashCardIcons[3], arrayIndex: 3, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.frame(width: geo.size.width * 0.9)
                    HStack(spacing: 0){
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[4], flashCardSetIcon: flashCardIcons[4], arrayIndex: 4, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[5], flashCardSetIcon: flashCardIcons[5], arrayIndex: 5, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.frame(width: geo.size.width * 0.9)
                    HStack(spacing: 0){
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[6], flashCardSetIcon: flashCardIcons[6], arrayIndex: 6, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[7], flashCardSetIcon: flashCardIcons[7], arrayIndex: 7, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.frame(width: geo.size.width * 0.9)
                    HStack(spacing: 0){
                        Spacer()
                        flashCardButton(flashCardSetName: flashCardSetTitles[8], flashCardSetIcon: flashCardIcons[8], arrayIndex: 8, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.frame(width: geo.size.width * 0.9)
                    HStack(spacing: 0){
                        Spacer()
                        toMyListButton(flashCardSetName: flashCardSetTitles[9], flashCardSetIcon: flashCardIcons[9], setAccData: setAccData, showListEmptyPopUp: $showListEmptyPopUp)
                        Spacer()
                        toEditMyListButton(flashCardSetName: flashCardSetTitles[11], flashCardSetIcon: flashCardIcons[10], setAccData: setAccData)
                        Spacer()
                        
                    }
                }
            }
              
        }
        
    }
    
}

struct flashCardButton: View {
    @EnvironmentObject var globalModel: GlobalModel
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    var arrayIndex: Int
    
    @State var pressed = false
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var body: some View{
        
        let dataObj = flashCardData(chosenFlashSetIndex: arrayIndex)
        let flashCardSetAccObj = FlashCardSetAccDataManager()

        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Georgia", size: 15))
                .frame(width: 130, height: 80)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: arrayIndex), flashCardSetName: dataObj.getSetName(index: arrayIndex)), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding()
                //.background(.white)
                    .cornerRadius(60)
                //                            .overlay( RoundedRectangle(cornerRadius: 60)
                //                                .stroke(.black, lineWidth: 2))
                    .shadow(radius: 2)
            }).id(UUID())
        }
//                    Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[arrayIndex])) + "%")
//                    

}
    
    func checkIfUnlocked(dataSetName: String)->Bool{
        var tempBool = false
        for i in 0...globalModel.currentUnlockableDataSets.count - 1 {
            if globalModel.currentUnlockableDataSets[i].setName == dataSetName {
                tempBool = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
       return tempBool
    }
    
}



struct toMyListButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
    
    @State var isListEmpty = true

    @Binding var showListEmptyPopUp: Bool
  

    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Georgia", size: 15))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            if isListEmpty {
                VStack{
                    Button(action: {showListEmptyPopUp = true}, label: {
                        Text("!")
                            .font(Font.custom("Georgia", size: 45))
                            .bold()
                            .foregroundColor(.red)
                            .background{
                                ZStack{
                                    Image(flashCardSetIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                        .padding()
                                        //.background(.white)
                                        .cornerRadius(60)
                                        //.shadow(radius: 5)
                                        .opacity(0.15)
                                    
                                    //                                Text("!")
                                    //                                    .font(Font.custom("Futura", size: 55))
                                    //                                    .foregroundColor(.red)
                                    //                                    //.bold()
                                    //                                    .zIndex(1)
                                }
                            }
                            //.padding()
                        
                    })
                    
                    //Text("%").opacity(0.0)
                }.padding()
            }else{
                NavigationLink(destination: myListFlashCardActivity(), label: {
                    Image(flashCardSetIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .padding()
                        //.background(.white)
                        .cornerRadius(60)
    //                    .overlay( RoundedRectangle(cornerRadius: 60)
    //                        .stroke(.black, lineWidth: 2))
                        .shadow(radius: 2)
             
       
                }).id(UUID())
                
                //Text("%").opacity(0.0)
            }

        
        }.onAppear{
            isListEmpty = isEmptyMyListFlashCardData()
        }
    }
    
    func isEmptyMyListFlashCardData() -> Bool {
        
        let fR =  UserFlashCardList.fetchRequest()
        
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
    
    
    
}

struct toEditMyListButton: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
  
    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Georgia", size: 15))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: EditMyFlashCardList(search: "Search"), label: {
                Image(flashCardSetIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding()
                    //.background(.white)
                    .cornerRadius(60)
//                    .overlay( RoundedRectangle(cornerRadius: 60)
//                        .stroke(.black, lineWidth: 2))
                    .shadow(radius: 2)
            }).id(UUID())
            
        
        }
    }
    

    
    
}


struct chooseFlashCardSet_Previews: PreviewProvider {
    static var previews: some View {
        chooseFlashCardSet().environment(\.managedObjectContext,
                                          PersistenceController.preview.container.viewContext)
        .environmentObject(GlobalModel())
    }
}
