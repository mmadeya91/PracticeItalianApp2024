//
//  chooseAudioIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/3/24.
//

import SwiftUI

struct chooseAudioIPAD: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    @State var attemptToBuyPopUp = false
    @State var attemptedBuyName = "temp"
    @State private var notEnoughCoins = false
    
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
                            .font(.system(size: 35))
                            .foregroundColor(.black)
                        
                    }).padding(.leading, 25)
                        .padding(.top, 20)

                    
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
                                .font(Font.custom("Arial Hebrew", size: 22))
                        }.padding(.trailing, 50)
                    }
                    
                }.zIndex(2)
                
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.20)
                    .offset(x: 380, y: animatingBear ? 90 : 300)
                
                VStack{
                    
                    
                    shortStoryContainer2IPAD(showInfoPopUp: $showInfoPopup, attemptToBuyPupUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).frame(width:  geo.size.width * 0.8, height: geo.size.height * 0.78)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.1)
                        .padding([.top, .bottom], geo.size.height * 0.15)
                }
                
                if showInfoPopup{
                    
                    ZStack(alignment: .topLeading){
                        HStack{
                            Button(action: {
                                showInfoPopup.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 35))
                                    .foregroundColor(.black)
                                
                            })
                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                        
                        VStack{
                            
                            
                            Text("Listen to the following dialogues performed by a native Italian speaker. \n \nDo your best to comprehend the audio and answer the questions to the best of your ability!")
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
                            Text("Do you want to spend 25 of your coins to unlock the '" + String(attemptedBuyName) + "' Audio Activity?")
                                .multilineTextAlignment(.center)
                                .padding()
                                .font(Font.custom("Futura", size: 23))
                            
                            if notEnoughCoins{
                                Text("Sorry! You don't have enough coins!")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .font(Font.custom("Futura", size: 20))
                            }
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    checkAndUpdateUserCoins(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeIn(duration: 1.5)){
                        
                        animatingBear = true
                        
                        
                    }
                }
            }.navigationBarBackButtonHidden(true)
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

struct shortStoryContainer2IPAD: View {
    @Binding var showInfoPopUp: Bool
    @Binding var attemptToBuyPupUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        ZStack{
            VStack(spacing: 0){
                
                HStack{
                    Text("Audio Stories").zIndex(1)
                        .font(Font.custom("Marker Felt", size: 50))
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                    
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopUp.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                        
                    })
                    .padding(.leading, 5)
                }.frame(width: 740, height: 100)
                    .background(Color("DarkNavy")).opacity(0.75)
                    .border(width: 8, edges: [.bottom], color: .teal)
                
                
                audioHStackIPAD(attemptToBuyPopUp: $attemptToBuyPupUp, attemptedBuyName: $attemptedBuyName)
                
            }
            
        }
    }
}

struct audioHStackIPAD: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    var body: some View{
        
        let bookTitles: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento"]
        
        ScrollView{
            VStack{
                VStack{
                    Text("Beginner")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 225)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    HStack{
                        Spacer()
                        audioChoiceButtonIPAD(shortStoryName: bookTitles[0], audioImage: "pot", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        audioChoiceButtonIPAD(shortStoryName:bookTitles[1], audioImage: "dinner", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }
                        .padding(.bottom, 10)
                        .padding(.top, 40)
                }
                VStack{
                    Text("Intermediate")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 275)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 10)
                        .padding(.bottom, 65)
                    
                    HStack{
                        Spacer()
                        audioChoiceButtonIPAD(shortStoryName: bookTitles[2], audioImage: "directions", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                        audioChoiceButtonIPAD(shortStoryName: bookTitles[3], audioImage: "clothesStore", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                        Spacer()
                    }
                        .padding(.top, 25)
                }
                VStack{
                    Text("Hard")
                        .font(Font.custom("Marker Felt", size: 40))
                        .frame(width: 175)
                        .border(width: 3, edges: [.bottom], color: .black)
                        .padding(.top, 50)
                        .padding(.bottom, 25)
                    
                    HStack{
                        audioChoiceButtonIPAD(shortStoryName:bookTitles[4], audioImage: "renaissance", attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName)
                    }.padding([.leading, .trailing], 28)
                        .padding(.bottom, 10)
                        .padding(.top, 70)
                }
            }
        }
        
    }
    
}

struct audioChoiceButtonIPAD: View {
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
                                Image("coin2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 75, height: 75)
                                Text("25")
                                    .font(Font.custom("Arial Hebrew", size: 30))
                                    .foregroundColor(.black)
                                    .bold()
                            }.offset(y:5)
                        }).background(
                            ImageOnCircleAudioIPAD(icon: audioImage, radius: 75).opacity(0.4)
                            )
                        
                        
                        Text(shortStoryName)
                            .font(Font.custom("Futura", size: 20))
                            .frame(width: 140, height: 80)
                            .multilineTextAlignment(.center)
                            .offset(y: 25)
                           
                        
                    }
                    
                }else{
                    VStack(spacing: 0){
                        
                        NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                            ImageOnCircleAudioIPAD(icon: audioImage, radius: 75)
                        }).padding(.top, 5)
                            .simultaneousGesture(TapGesture().onEnded{
                                listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                            })
                        
                        Text(shortStoryName)
                            .font(Font.custom("Futura", size: 20))
                            .frame(width: 140, height: 80)
                            .multilineTextAlignment(.center)
                       
                         

                        
                    }
                }
            }else{
                VStack(spacing: 0){
                    NavigationLink(destination: ListeningActivityView(listeningActivityVM: listeningActivityViewModel, shortStoryName: shortStoryName, isPreview: false), label: {
                        ImageOnCircleAudioIPAD(icon: audioImage, radius: 75)
                        
                    }).simultaneousGesture(TapGesture().onEnded{
                        listeningActivityViewModel.setAudioData(chosenAudio: shortStoryName)
                    })
                    
                    
                    
                    Text(shortStoryName)
                        .font(Font.custom("Futura", size: 20))
                        .frame(width: 140, height: 80)
                        .multilineTextAlignment(.center)
                       
                       
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

}

struct ImageOnCircleAudioIPAD: View {
    
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
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}


struct chooseAudioIPAD_Previews: PreviewProvider {
    static var previews: some View {
        chooseAudioIPAD()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
    }
}

