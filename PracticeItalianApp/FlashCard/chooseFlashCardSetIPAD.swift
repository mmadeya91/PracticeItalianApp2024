//
//  chooseFlashCardSetIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/10/24.
//

import SwiftUI

struct chooseFlashCardSetIPAD: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var globalModel: GlobalModel
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    @State private var attemptToBuyPopUp = false
    @State private var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    
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
            ZStack(alignment: .topLeading){
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .opacity(1.0)
                
                HStack(alignment: .top){
                    
                    NavigationLink(destination: chooseActivity(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 45))
                            .foregroundColor(.black)
                        
                    }).padding(.leading, 25)
                        .padding(.top, 20).id(UUID())

                    
                    Spacer()
                    VStack(spacing: 0){
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 50)
                            .shadow(radius: 10)
                            .padding()
                        
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 30))
                        }.padding(.trailing, 50)
                    }
                    
                }
                
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.20)
                    .offset(x: 380, y: animatingBear ? 110 : 300)
                
                
                
                VStack{
                    
                    flashCardSetsIPAD(setAccData: flashCardSetAccData, showInfoPopup: $showInfoPopUp, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).frame(width:  geo.size.width * 0.8, height: geo.size.height * 0.78)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.1)
                        .padding([.top, .bottom], geo.size.height * 0.15)
                }
                
                if showInfoPopUp{
                    
                    ZStack(alignment: .topLeading){
                        HStack{
                            Button(action: {
                                showInfoPopUp.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 35))
                                    .foregroundColor(.black)
                                
                            })
                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                        
                        VStack{
                            
                            
                            Text("Use the provided flash card sets to increase your vocabulary! Or, make your own using the 'Make Your Own' feature. \n \nEach flash card set displays your accuracy under the corresponding image to let you know which words you need to work most on during your practice.")
                                .font(.system(size:28))
                                .multilineTextAlignment(.center)
                                .padding()
                        }.padding(.top, 70)
                    }.frame(width: geo.size.width * 0.6, height: geo.size.width * 0.48)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                        .padding([.leading, .trailing], geo.size.width * 0.2)
                        .padding([.top, .bottom], geo.size.height * 0.3)
                    
                    
                }
                
                
                if attemptToBuyPopUp{
                    VStack{
                        VStack{
                            Text("Do you want to spend 25 of your coins to unlock the 'Food' flash card set?")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            if notEnoughCoins{
                                Text("Sorry! You don't have enough coins!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            HStack{
                                Button(action: {
                                    checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                }, label: {Text("Yes")})
                                Button(action: {
                                    attemptToBuyPopUp = false
                                }, label: {Text("Yes")  .font(Font.custom("Futura", size: 30))})
                                Spacer()
                                Button(action: {
                                    attemptToBuyPopUp = false
                                }, label: {Text("No")  .font(Font.custom("Futura", size: 30))})
                                Spacer()
                            }
                            
                        }
                    }.frame(width: 500, height: 385)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .transition(.slide).animation(.easeIn).zIndex(2)
                        .offset(x: geo.size.width / 5, y: geo.size.height / 3)
                    
                }
                
                
            }.onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
              
            }
        }.navigationBarBackButtonHidden(true)
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

struct flashCardSetsIPAD: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var body: some View{
        
        ZStack{
            VStack(spacing: 0){
                
                HStack{
                    Text("Flash Cards").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 50))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopup.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                    })
                    .padding(.leading, 5)
                } .frame(width: 740, height: 100)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                flashCardHStackIPAD(setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                
                
                
            }.zIndex(1)

        }
    }
}

struct flashCardHStackIPAD: View {
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let flashCardSetTitles: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases", "My List", "Make Your Own"]
        
        let flashCardIcons: [String] = ["food", "bear", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking", "flash-card", "flash-card"]
        
        ScrollView{
            HStack{
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[0], flashCardSetIcon: flashCardIcons[0], arrayIndex: 0, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[1], flashCardSetIcon: flashCardIcons[1], arrayIndex: 1, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
            }
                .padding(.bottom, 10)
    
            HStack{
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[2], flashCardSetIcon: flashCardIcons[2], arrayIndex: 2, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[3], flashCardSetIcon: flashCardIcons[3], arrayIndex: 3, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
            }
            HStack{
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[4], flashCardSetIcon: flashCardIcons[4], arrayIndex: 4, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[5], flashCardSetIcon: flashCardIcons[5], arrayIndex: 5, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
            }
            HStack{
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[6], flashCardSetIcon: flashCardIcons[6], arrayIndex: 6, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[7], flashCardSetIcon: flashCardIcons[7], arrayIndex: 7, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
            }
            HStack{
                Spacer()
                flashCardButtonIPAD(flashCardSetName: flashCardSetTitles[8], flashCardSetIcon: flashCardIcons[8], arrayIndex: 8, setAccData: setAccData, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                Spacer()
                toMyListButtonIPAD(flashCardSetName: flashCardSetTitles[9], flashCardSetIcon: flashCardIcons[9], setAccData: setAccData)
                Spacer()
            }
            HStack{
//                toMakeYourOwnButtonIPAD(flashCardSetName: flashCardSetTitles[10], flashCardSetIcon: flashCardIcons[10], setAccData: setAccData)
                Spacer()
                
            }.padding([.leading, .trailing], 125)
        }
        
    }
    
}

struct flashCardButtonIPAD: View {
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
        
        if flashCardSetName.elementsEqual("Food"){
            if !checkIfUnlocked(dataSetName: flashCardSetName){
                VStack{
                    
                    Text(flashCardSetName)
                        .font(Font.custom("Marker Felt", size: 25))
                        .frame(width: 100, height: 85)
                        .multilineTextAlignment(.center)
                        .offset(y:-20)
                    
                    Button(action: {
                        attemptToBuyPopUp.toggle()
                        attemptedBuyName = flashCardSetName
                    }, label: {
                        VStack(spacing: 0){
                            Image("coin2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 75)
                            Text("25")
                                .font(Font.custom("Arial Hebrew", size: 30))
                                .bold()
                                .foregroundColor(.black)
                        }.offset(y:5)
                    }).background(
                        ImageOnCircleFlashCardIPAD(icon: flashCardSetIcon, radius: 75).opacity(0.4)
                        
                    )
                    
                    Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[arrayIndex])) + "%").opacity(0)
                    
                }
            }else{
                VStack{
                    
                    Text(flashCardSetName)
                        .font(Font.custom("Marker Felt", size: 25))
                        .frame(width: 100, height: 85)
                        .multilineTextAlignment(.center)
                        .offset(y:15)
                    
                    
                    NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: arrayIndex), flashCardSetName: dataObj.getSetName(index: arrayIndex)), label: {
                        ImageOnCircleFlashCardIPAD(icon: flashCardSetIcon, radius: 75)
                    }).id(UUID())
                    Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[arrayIndex])) + "%")
                    
                }
            }
        }else{
            VStack{
                
                Text(flashCardSetName)
                    .font(Font.custom("Marker Felt", size: 25))
                    .frame(width: 100, height: 85)
                    .multilineTextAlignment(.center)
                    .offset(y:15)
                
                
                NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: arrayIndex), flashCardSetName: dataObj.getSetName(index: arrayIndex)), label: {
                    ImageOnCircleFlashCardIPAD(icon: flashCardSetIcon, radius: 75)
                }).id(UUID())
                Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[arrayIndex])) + "%")
                
            }
            
            
        }
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

//struct toMakeYourOwnButtonIPAD: View {
//    
//    
//    var flashCardSetName: String
//    var flashCardSetIcon: String
//    var setAccData: FetchedResults<FlashCardSetAccuracy>
//    
//    var body: some View{
//
//        let flashCardSetAccObj = FlashCardSetAccDataManager()
//        VStack{
//            
//            Text(flashCardSetName)
//                .font(Font.custom("Marker Felt", size: 25))
//                .frame(width: 100, height: 85)
//                .multilineTextAlignment(.center)
//                .offset(y:15)
//            
//            
//            NavigationLink(destination: createFlashCard(), label: {
//                ImageOnCircleFlashCardIPAD(icon: flashCardSetIcon, radius: 85)
//            }).id(UUID())
//            
//            Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[10])) + "%")
//        
//        }
//    }
//    
//}

struct toMyListButtonIPAD: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var flashCardSetName: String
    var flashCardSetIcon: String
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    var setAccData: FetchedResults<FlashCardSetAccuracy>
    
  

    var body: some View{
        
        
        VStack{
            
            Text(flashCardSetName)
                .font(Font.custom("Marker Felt", size: 25))
                .frame(width: 100, height: 85)
                .multilineTextAlignment(.center)
                .offset(y:15)
            
            
            NavigationLink(destination: myListFlashCardActivity(), label: {
                ImageOnCircleFlashCardIPAD(icon: flashCardSetIcon, radius: 85)
            }).id(UUID())
            
            Text(String(format: "%.0f", flashCardSetAccObj.calculateSetAccuracy(setAccObj: setAccData[9])) + "%")
        
        }
    }
    
    
    
}

struct ImageOnCircleFlashCardIPAD: View {
    
    let icon: String
    let radius: CGFloat
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: radius * 2, height: radius * 2)
                .overlay(Circle().stroke(.black, lineWidth: 3))
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .padding(10)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
                
        }
    }
}


struct chooseFlashCardSetIPAD_Previews: PreviewProvider {
    static var previews: some View {
        chooseFlashCardSetIPAD().environment(\.managedObjectContext,
                                          PersistenceController.preview.container.viewContext)
        .environmentObject(GlobalModel())
    }
}
