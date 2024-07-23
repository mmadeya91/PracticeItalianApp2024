//
//  availableShortStories.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/9/23.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct availableShortStories: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    @State var attemptToBuyPopUp = false
    @State var attemptedBuyName = "temp"
    @State var notEnoughCoins = false
    
    @FetchRequest(
        entity: UserUnlockedDataSets.entity(),
        sortDescriptors: []
    ) var fetchedUserUnlockedData: FetchedResults<UserUnlockedDataSets>
    
    @FetchRequest(
        entity: UserCoins.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedUserCoins: FetchedResults<UserCoins>
    
    @FetchRequest(
        entity: UserCompletedActivities.entity(),
        sortDescriptors: []
    ) var completedActivities: FetchedResults<UserCompletedActivities>
    
 
    
    
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
//                    Image("bearHalf")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.12, height: geo.size.width * 0.1)
//                        .padding(.top, animatingBear ? geo.size.height * 0.09 : geo.size.height * 0.145)
//                        .offset(x:geo.size.width * 0.6)
//                        //.offset(y:geo.size.width / 3)
//                        .zIndex(0)
                    
                    VStack{
                        
                        
                        shortStoryContainer(showInfoPopup: $showInfoPopup, attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName: $attemptedBuyName).padding([.top, .bottom], geo.size.height * 0.14)
                         
                    }
                    
//                    ZStack(alignment: .topLeading){
//                        HStack{
//                            Button(action: {
//                                withAnimation(.easeIn(duration: 0.25)){
//                                    showInfoPopup.toggle()
//                                }
//                            }, label: {
//                                Image(systemName: "xmark")
//                                    .font(.system(size: 25))
//                                    .foregroundColor(.black)
//                                
//                            })
//                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
//                        
//                        VStack{
//                            
//                            
//                            Text("Do your best to read and understand the following short stories on various topics. \n \nWhile you read, pay attention to key vocabulary words as you will be quizzed after on your comprehension!")
//                                .font(Font.custom("Georgia", size: geo.size.height * 0.024))
//                                .multilineTextAlignment(.center)
//                                .padding()
//                        }.padding(.top, 50)
//                    }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.7)
//                        .background(.white)
//                        .cornerRadius(20)
//                        .shadow(radius: 20)
//                        .overlay( /// apply a rounded border
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(.black, lineWidth: 3)
//                        )
//                        .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
//                        .opacity(launchedBefore != true || showInfoPopup ? 1.0 : 0.0)
//                        .zIndex(2)
                    
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
                                            checkAndUpdateUserCoinsSS(userCoins: globalModel.userCoins, chosenDataSet: attemptedBuyName)
                                       
                                                
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
                }
            }else{
                availableShortStoriesIPAD()
            }
        }.navigationBarBackButtonHidden(true)
        
    }
    
    func unlockDataSS(chosenDataSet: String){
        for dataSet in fetchedUserUnlockedData {
            if dataSet.dataSetName == chosenDataSet {
                dataSet.isUnlocked = true
                updateGlobalModelSS(chosenDataSet: chosenDataSet)
                do {
                    try viewContext.save()
                } catch {

                    let nsError = error as NSError
                }
            }
        }
    }
    
    func updateGlobalModelSS(chosenDataSet: String){
        for i in 0...globalModel.currentUnlockableDataSets.count-1 {
            if globalModel.currentUnlockableDataSets[i].setName == chosenDataSet {
                globalModel.currentUnlockableDataSets[i].isUnlocked = true
            }
        }
    }
    
    func checkAndUpdateUserCoinsSS(userCoins: Int, chosenDataSet: String)->Bool{
        if globalModel.userCoins >= 25 {
            fetchedUserCoins[0].coins = Int32(globalModel.userCoins - 25)
            globalModel.userCoins = globalModel.userCoins - 25
            unlockDataSS(chosenDataSet: chosenDataSet)
            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
            }
            return true
        }else{
//            notEnoughCoins = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                attemptToBuyPopUp = false
//                 notEnoughCoins = false
//            }
            return false
        }
    }
}

struct shortStoryContainer: View {
    @Binding var showInfoPopup: Bool
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var infoManager = InfoBubbleDataManager(activityName: "chooseStory")
    
    let infoText:Text =  (Text("Choose from one of the following Short Story activities. You will be quizzed using 3 different engaging exercises to test your comprehension of the story, keywords, and Italian language topics. \n\nIf you need to reference the story at anytime during the exercises, look for the  ") +
                          Text(Image(systemName: "book.closed.fill")) +
                         Text("  symbol. If you need some help to understand how to do the activities themselves, look for the  ") +
                         Text(Image(systemName: "info.circle.fill")) +
                         Text("  symbol. \n\nCompleting the entire activity will earn you coins which you can use to unlock more stories. Or visit the store on the home page to buy coins or more lesson packs."))
    
    var body: some View{
        GeometryReader { geo in
            //ZStack{
            
        VStack(spacing: 0){
            ZStack{
                HStack(spacing: 0){
                    Text("Short Stories")
                        .font(Font.custom("Georgia", size: 28))
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                    
                    
                   
                    PopOverViewTopWithImages(textIn: infoText, infoBubbleColor: Color.white, frameHeight: CGFloat(470), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                    
                    
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
                    .shadow(radius: 3)
                    .zIndex(0)
            }.offset(y: -7)
                    
      
            bookHStack(attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:$attemptedBuyName).frame(width:  geo.size.width * 0.86, height: geo.size.height * 0.95)
                .background(Color("WashedWhite").opacity(0.0)).cornerRadius(10)
                .padding([.leading, .trailing], geo.size.width * 0.07)
               //.padding([.top, .bottom], geo.size.height * 0.14)
                    
                //}.zIndex(1)
           }.onDisappear{
               infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
           }
            
        }
    }
}


struct bookHStack: View {
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel
    @State var packagePurchased = true
    var body: some View{
        
        let bookTitles: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Il Mio Animale Preferito", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Il Mio Sport Preferito", "Il Mio Ultimo Compleanno", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana", "Il Mio Sogno nel Cassetto"]
        
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
                    bookButton(shortStoryName: bookTitles[0], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                    bookButton(shortStoryName:bookTitles[1], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                }
                .padding(.bottom, 15)
                HStack{
                    Spacer()
                    bookButton(shortStoryName: bookTitles[2], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                    if inAppPurchaseModel.userPurchasedPackage1 {
                        bookButton(shortStoryName: bookTitles[3], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                    }
                
                }
                
                
                
                Text("Intermediate")
                    .font(Font.custom("Georgia", size: 25))
                    .frame(width: 160, height: 30)
                    .border(width: 2.25, edges: [.bottom], color: Color("espressoBrown"))
                    .padding(.bottom, 45)
                    .padding(.top, 40)
                
                HStack{
                    Spacer()
                    bookButton(shortStoryName: bookTitles[4], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                    bookButton(shortStoryName: bookTitles[5], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                }
                
                if inAppPurchaseModel.userPurchasedPackage1{
                    HStack{
                        Spacer()
                        bookButton(shortStoryName: bookTitles[6], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                        bookButton(shortStoryName: bookTitles[7], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
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
                    bookButton(shortStoryName:bookTitles[8], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                    bookButton(shortStoryName: bookTitles[9], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                    Spacer()
                }
                
                if inAppPurchaseModel.userPurchasedPackage1{
                    HStack{
                        Spacer()
                        bookButton(shortStoryName:bookTitles[10], attemptToBuyPopUp: $attemptToBuyPopUp, attemptedBuyName:     $attemptedBuyName)
                        Spacer()
                    }.padding(.top, 15)
                }
                
            }
        }
        
        
    }
    
}

struct bookButton: View {
    
    @EnvironmentObject var globalModel: GlobalModel
    
    let lockedStories: [String] = ["La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana"]
    
    var shortStoryName: String
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    @State var pressed = false
 
    var body: some View{
        ZStack {
            if lockedStories.contains(shortStoryName){
                if !checkIfUnlockedStory(dataSetName: shortStoryName){
                    VStack(spacing: 0){
                        
                        
                        Button(action: {
                            
                                attemptToBuyPopUp.toggle()
                                attemptedBuyName = shortStoryName
                            
                        }, label: {
                            VStack(spacing: 0){
                                Image("euro-2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                Text("25")
                                    .font(Font.custom("Arial Hebrew", size: 28))
                                    .foregroundColor(.black)
                                    //.bold()
                            }.offset(y:5)
                        }).background(
                            Image("book3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .padding()
                               // .background(.white)
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
                           
                        
                    }.padding()
                    
                }else{
                    if !checkIfCompleted(dataSetName: shortStoryName){
                        VStack(spacing: 0){
                            
                            var storyData: shortStoryData { shortStoryData(chosenStoryName: shortStoryName)}
                            
                            
                            var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
                            
                            NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName, shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: shortStoryName), storyData: storyData, storyObj: storyObj), label: {
                                Image("book3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .padding()
                                   // .background(.white)
                                    .cornerRadius(60)
//                                    .overlay( RoundedRectangle(cornerRadius: 60)
//                                        .stroke(.black, lineWidth: 2))
                                    .shadow(radius: 2)
                            }).id(UUID()).padding(.top, 5)
                                .simultaneousGesture(TapGesture().onEnded{
                                    print("Hello world!")
                                })
                            
                            Text(shortStoryName)
                                .font(Font.custom("Georgia", size: 15))
                                .frame(width: 130, height: 80)
                                .multilineTextAlignment(.center)
                            
                            
                        }
                    }else{
                        VStack(spacing: 0){
                            
                            var storyData: shortStoryData { shortStoryData(chosenStoryName: shortStoryName)}
                            
                            
                            var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
                            
                            NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName, shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: shortStoryName), storyData: storyData, storyObj: storyObj), label: {
                                VStack(spacing: 0){
                                    Image("check")
                                        .resizable()
                                        .scaledToFit()
                                        //.tint(Color("ForestGreen"))
                                        .frame(width: 80, height: 80)
                                }//.offset(y:5)
                            }).id(UUID()).background(
                                Image("book3")
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
                            
                            Text(shortStoryName)
                                .font(Font.custom("Georgia", size: 15))
                                .frame(width: 130, height: 80)
                                .multilineTextAlignment(.center)
                               
                            
                        }
                    }
                }
            }else{
                if !checkIfCompleted(dataSetName:  shortStoryName){
                    VStack(spacing: 0){
                        
                        var storyData: shortStoryData { shortStoryData(chosenStoryName: shortStoryName)}
                        
                        
                        var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
                        
                        
                        NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName, shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: shortStoryName), storyData: storyData, storyObj: storyObj), label: {
                            Image("book3")
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
                            print("Hello world!")
                        })
                        
                        
                        
                        Text(shortStoryName)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                    }
                }else{
                    VStack(spacing: 0){
                        var storyData: shortStoryData { shortStoryData(chosenStoryName: shortStoryName)}
                        
                        
                        var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
                        
                        NavigationLink(destination: shortStoryView(chosenStoryNameIn: shortStoryName, shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: shortStoryName), storyData: storyData, storyObj: storyObj), label: {
                            VStack(spacing: 0){
                                Image("check")
                                    .resizable()
                                    .scaledToFit()
                                    //.tint(Color("ForestGreen"))
                                    .frame(width: 80, height: 80)
                            }//.offset(y:5)
                        }).id(UUID()).background(
                            Image("book3")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .padding()
                                //.background(.white)
                                .cornerRadius(60)
//                                .overlay( RoundedRectangle(cornerRadius: 60)
//                                    .stroke(.black, lineWidth: 2))
                                .shadow(radius: 2)
                                
                        )
                        
                        Text(shortStoryName)
                            .font(Font.custom("Georgia", size: 15))
                            .frame(width: 130, height: 80)
                            .multilineTextAlignment(.center)
                           
                        
                    }
                }
                
            }
        }
    }
    
    func checkIfUnlockedStory(dataSetName: String)->Bool{
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

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addRect(CGRect(x: x, y: y, width: w, height: h))
        }
        return path
    }
}

struct availableShortStories_Previews: PreviewProvider {
    static var previews: some View {
        availableShortStories().environmentObject(GlobalModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(InAppPurchaseModel())
    }
}
