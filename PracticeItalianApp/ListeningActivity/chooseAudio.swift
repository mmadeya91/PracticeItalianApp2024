//
//  chooseAudio.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/7/23.
//

import SwiftUI

struct chooseAudio: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
 
    
    @State var animatingBear = false
    @State var showInfoPopup = false
    @State var attemptToBuyPopUp = false
    @State var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    
    @FetchRequest(
        entity: UserCompletedActivities.entity(),
        sortDescriptors: []
    ) var completedActivities: FetchedResults<UserCompletedActivities>
    
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
                    
                    
                    
//                    Image("bearHalf")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.12, height: geo.size.width * 0.1)
//                        .padding(.top, animatingBear ? geo.size.height * 0.09 : geo.size.height * 0.145)
//                        .offset(x:geo.size.width * 0.6)
//                        //.offset(y:geo.size.width / 3)
//                        .zIndex(0)
//                    
                    
                    VStack{
                        
                        
                        shortStoryContainer2(showInfoPopUp: $showInfoPopup, attemptToBuyPupUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)  .padding([.top, .bottom], geo.size.height * 0.14)
                    }
                    
                    if showInfoPopup{
                        ZStack(alignment: .topLeading){
                            VStack{
                                HStack{
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.25)){
                                            showInfoPopup.toggle()
                                        }
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 25))
                                            .foregroundColor(.black)
                                        //.frame(width: 40, height: 40)
                                        
                                    })
                                    .zIndex(1)
                                    Spacer()
                                }.padding(.leading, 20)
                                
                                
                                
                                
                                
                                Text("Listen to the following dialogues performed by a native Italian speaker. \n \nDo your best to comprehend the audio and answer the questions to the best of your ability!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.top, 15)
                            }
                         
                        }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.7)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                            .opacity(showInfoPopup ? 1.0 : 0.0)
                            .zIndex(2)
                        
                        
                    }
                    
                    
                    if attemptToBuyPopUp{
                        VStack{
                            VStack{
                                if globalModel.userCoins < 25 {
                                    Text("Sorry! You don't have enough coins to unlock this short story")
                                        .font(Font.custom("Georgia", size: geo.size.height * 0.024))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .padding()
 
                                }
                                else{
                                    Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' short story?")
                                        .font(Font.custom("Georgia", size: geo.size.height * 0.024))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                }

                                HStack{
                                    Spacer()
                                    if globalModel.userCoins < 25 {
                                        Button(action: {
                                            attemptToBuyPopUp = false
                                        }, label: {
                                            Text("Ok")
                                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width:70, height: 35)
                                            .shadow(radius: 1)
                                    }else{
                                        Button(action: {
                                            checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                       
                                                
                                                attemptToBuyPopUp = false
                                            
                                            
                                        }, label: {Text("Yes")
                                                .font(.system(size: 20))
                                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width:70, height: 35)
                                            .shadow(radius: 1)
                                        Spacer()
                                        Button(action: {
                                            attemptToBuyPopUp = false
                                        }, label: {Text("No")
                                                .font(.system(size: 20))
                                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width:70, height: 35)
                                            .shadow(radius: 1)
                                      
                                    }
                                    Spacer()
                                }.padding(.top, 20)
                                
                                
                            }
                        }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.6)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                            .opacity(attemptToBuyPopUp ? 1.0 : 0.0)
//                            .padding([.leading, .trailing], geo.size.width * 0.1)
//                            .padding([.top, .bottom], geo.size.height * 0.3)
                        
                    }
                    
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeIn(duration: 1.5)){
                            
                            animatingBear = true
                            
                            
                        }
                    }
                }.navigationBarBackButtonHidden(true)
            }else{
                chooseAudioIPAD()
            }
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

struct shortStoryContainer2: View {
    @Binding var showInfoPopUp: Bool
    @Binding var attemptToBuyPupUp: Bool
    @Binding var attemptedBuyName: String
    
    var infoManager = InfoBubbleDataManager(activityName: "chooseAudio")
    
    let infoText:Text =  (Text("Sharpen your audio comprehension by choosing from one of the following activities performed by native Italian speakers. You will be quizzed using 3 different engaging exercises to test your comprehension of the dialogue, keywords, and Italian language topics. \n\nIf you need to reference the transcript at anytime during the exercises, look for the  ") +
                          Text(Image(systemName: "newspaper")) +
                         Text("  symbol. If you need some help to understand how to do the activities themselves, look for the  ") +
                         Text(Image(systemName: "info.circle.fill")) +
                         Text("  symbol. \n\nCompleting the entire activity will earn you coins which you can use to unlock more audios. Or visit the store on the home page to buy coins or more lesson packs."))
    
    var body: some View{
        GeometryReader{ geo in
            VStack(spacing: 0){
                ZStack{
                    HStack(spacing: 0){
                        Text("Audio Stories")
                            .font(Font.custom("Georgia", size: 28))
                            .foregroundColor(.white)
                            .padding(.leading, 35)
                        
                        
                        
                        PopOverViewTopWithImages(textIn: infoText, infoBubbleColor: Color.white, frameHeight: CGFloat(510), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                        
                    } .frame(width: geo.size.width * 0.9, height: 60)
                        .background(Color("espressoBrown"))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: geo.size.width * 0.9, height: 60)
                        .foregroundColor(Color("darkEspressoBrown"))
                        .zIndex(0)
                        .offset(y:7)
                        .shadow(radius: 2)
                        .zIndex(0)
                }.offset(y: -7)
                
                
                
                audioHStack(attemptToBuyPopUp: $attemptToBuyPupUp, attemptedBuyName: $attemptedBuyName).frame(width:  geo.size.width * 0.86, height: geo.size.height * 0.95)
                    .background(Color("WashedWhite").opacity(0.0)).cornerRadius(10)
                    .padding([.leading, .trailing], geo.size.width * 0.07)
                
            }.onDisappear{
                infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
            }
        }
            
        
    }
}

struct audioHStack: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel
    @State var packagePurchased = true
    var body: some View{
        
        let bookTitles: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Alla Ricerca di un Appartamento", "Il Festival di Sanremo", "Il Rinascimento", "Il Colloquio di Lavoro"]
        
        ScrollView(showsIndicators: false){
            VStack(spacing: 0){
                Text("Beginner")
                    .font(Font.custom("Georgia", size: 25))
                    .frame(width: 120, height: 30)
                    .border(width: 2.25, edges: [.bottom], color: Color("espressoBrown"))
                    .padding(.top, 30)
                    .padding(.bottom, 35)
                HStack{
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[0], audioImage: "pot", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName:bookTitles[1], audioImage: "dinner", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Text("Intermediate")
                    .font(Font.custom("Georgia", size: 25))
                    .frame(width: 160, height: 30)
                    .border(width: 2.25, edges: [.bottom], color: Color("espressoBrown"))
                    .padding(.bottom, 45)
                    .padding(.top, 40)
                
                HStack{
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[2], audioImage: "directions", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    audioChoiceButton(shortStoryName: bookTitles[3], audioImage: "clothesStore", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                }
                
                if inAppPurchaseModel.userPurchasedPackage1 {
                    HStack{
                        Spacer()
                        audioChoiceButton(shortStoryName: bookTitles[4], audioImage: "rent", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        audioChoiceButton(shortStoryName: bookTitles[5], audioImage: "festival", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }.padding(.top, 15)
                }
                    
                
                Text("Hard")
                    .font(Font.custom("Georgia", size: 25))
                    .frame(width: 70, height: 30)
                    .border(width: 2.25, edges: [.bottom], color: Color("espressoBrown"))
                    .padding(.bottom, 25)
                    .padding(.top, 40)
                
                HStack{
                    Spacer()
                    audioChoiceButton(shortStoryName:bookTitles[6], audioImage: "renaissance", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    Spacer()
                    if inAppPurchaseModel.userPurchasedPackage1 {
                        audioChoiceButton(shortStoryName:bookTitles[7], audioImage: "interview", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }
                }//.padding([.leading, .trailing], 28)
                  //  .padding(.bottom, 10)
                   // .padding(.top, 30)
            }
        }
        
    }
    
}

struct audioChoiceButton: View {
    @EnvironmentObject var globalModel: GlobalModel
    
    @StateObject var listeningActivityViewModel = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    
    var shortStoryName: String
    var audioImage: String
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    let lockedStories: [String] = ["Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
    
    var body: some View{
        ZStack {
            if lockedStories.contains(shortStoryName){
                if !checkIfUnlockedAudio(dataSetName: shortStoryName){
                    VStack(spacing: 0){
                        
                        
                        Button(action: {
                            attemptToBuyPopUp.toggle()
                            attemptedBuyName = shortStoryName
                        }, label: {
                            VStack(spacing: 0){
                                Image("euro-2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                Text("25")
                                    .font(Font.custom("Arial Hebrew", size: 30))
                                    .foregroundColor(.black)
                                    //.bold()
                            }.offset(y:5)
                        }).background(
                            Image(audioImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .padding()
                                //.background(.white)
                                .cornerRadius(60)
//                                .overlay( RoundedRectangle(cornerRadius: 60)
//                                    .stroke(.black, lineWidth: 2))
                                .shadow(radius: 2)
                                .opacity(0.15)
                        )
                        
                        Text(shortStoryName)
                            .font(Font.custom("Georgia", size: 16))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                           
                        
                    }
                    
                }else{
                    if !checkIfCompleted(dataSetName: shortStoryName){
                        VStack(spacing: 0){
                            
                            NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                                Image(audioImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .padding()
                                    //.background(.white)
                                    .cornerRadius(60)
//                                    .overlay( RoundedRectangle(cornerRadius: 60)
//                                        .stroke(.black, lineWidth: 2))
                                    .shadow(radius: 2)
                            }).id(UUID())//.padding(.top, 5)
                            .simultaneousGesture(TapGesture().onEnded{
                                listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                            })
                            
                            Text(shortStoryName)
                                .font(Font.custom("Georgia", size: 16))
                                .frame(width: 130, height: 80)
                                .multilineTextAlignment(.center)
                            
                            
                        }
                    }else{
                        VStack(spacing: 0){
                            
                            NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                                VStack(spacing: 0){
                                    Image("check")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 90)
                                }.offset(y:5)
                            }).id(UUID()).background(
                                Image(audioImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .padding()
                                    //.background(.white)
                                    .cornerRadius(60)
//                                    .overlay( RoundedRectangle(cornerRadius: 60)
//                                        .stroke(.black, lineWidth: 2))
                                    .shadow(radius: 2)
                                 
                            )
                            .simultaneousGesture(TapGesture().onEnded{
                                listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                            })
                            
                            Text(shortStoryName)
                                .font(Font.custom("Georgia", size: 15))
                                .frame(width: 130, height: 80)
                                .multilineTextAlignment(.center)
                            
                            
                        }
                    }
                }
            }else{
                if !checkIfCompleted(dataSetName: shortStoryName){
                    VStack(spacing: 0){
                        NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                            Image(audioImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                            
                                .padding()
                                //.background(.white)
                                .cornerRadius(60)
//                                .overlay( RoundedRectangle(cornerRadius: 60)
//                                    .stroke(.black, lineWidth: 2))
                                .shadow(radius: 2)
                            
                            
                        }).id(UUID()).simultaneousGesture(TapGesture().onEnded{
                            listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                        })
                        
                        
                        
                        Text(shortStoryName)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                    }
                }else{
                    VStack(spacing: 0){
                        
                        NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                            VStack(spacing: 0){
                                Image("check")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                            }.offset(y:5)
                        }).id(UUID()).background(
                            Image(audioImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .padding()
                               // .background(.white)
                                .cornerRadius(60)
//                                .overlay( RoundedRectangle(cornerRadius: 60)
//                                    .stroke(.black, lineWidth: 2))
                                .shadow(radius: 2)
                             
                        )
                        .simultaneousGesture(TapGesture().onEnded{
                            listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                        })
                        
                        Text(shortStoryName)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                        
                        
                    }
                }
                
            }
        }
    }
    
    
    func checkIfUnlockedAudio(dataSetName: String)->Bool{
        var tempBool = false
        for i in 0...globalModel.currentUnlockableDataSets.count - 1 {
            if globalModel.currentUnlockableDataSets[i].setName == dataSetName {
                tempBool = globalModel.currentUnlockableDataSets[i].isUnlocked
            }
        }
       return tempBool
    }
    
    func checkIfCompleted(dataSetName: String)->Bool{
        var tempBool = false
        for i in 0...globalModel.currentUnlockableDataSets.count - 1 {
            if globalModel.currentUnlockableDataSets[i].setName == dataSetName {
                tempBool = globalModel.currentUnlockableDataSets[i].isCompleted
            }
        }
       return tempBool
    }

}


struct chooseAudio_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudio()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
            .environmentObject(InAppPurchaseModel())
           
    }
}
