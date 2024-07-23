//
//  ActivityCompleteFlashCard.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/4/24.
//

import SwiftUI

struct ActivityCompleteFlashCard: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@State var questionCount: Int
    //@State var correctCount: Int
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var counter1 = 0
    @State private var counter2 = 0
  
    @State var goNext = false
    @State var homeButtonDisabled = true
    
    @State var dataObj = flashCardData(chosenFlashSetIndex: 1)
    //let flashCardSetAccObj = FlashCardSetAccDataManager()
    
    
    var finishedCardSet: String
    
    var availableCards: [String] = ["Food", "Animals", "Clothing", "Family", "Common Nouns", "Common Adjectives", "Common Adverbs", "Common Verbs", "Common Phrases"]
    
    var cardImages: [String] = ["food", "animal", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking"]
    
 
    
    @FetchRequest(
        sortDescriptors: [
            //SortDescriptor(\.userCoins)
        ]
    ) var userCoins: FetchedResults<UserCoins>
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
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
              
                    HStack{
                        Image("euro-2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 30)
                            .padding(.leading, 25)
                        
                        Text("\(self.counter2)")
                            .font(Font.custom("Georgia", size: 22))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    
                                    
                                    self.runCounter(counter: self.$counter2, start: globalModel.userCoins, end: (globalModel.userCoins + 1005), speed: 0.05)
                                }
                            }
                        
                        Spacer()
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding()
                        
                    }//.padding(.bottom, 670)
                        .zIndex(2)
                    
                    
                    VStack{
                        Spacer()
                    Button {
                        updateUserCoins()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            goNext = true
                        }
                        
                        
                    } label: {
                        Image("Home.fill")
                            .resizable()
                            .scaledToFill()
                            .padding(13)
                    }.padding(.bottom, 115)
                            .buttonStyle(ThreeDButton(backgroundColor: "white"))  .frame(width: 60, height: 60)
                    
                    NavigationLink(destination: ContentView(),isActive: $goNext,label:{}
                    ).isDetailLink(false).id(UUID()).disabled(homeButtonDisabled)
                    
                    }.frame(width: geo.size.width, height: geo.size.height)
                    
                    VStack{
    
                        VStack{
                            
                            Text("Good Work!")
                                .font(Font.custom("Georgia", size: geo.size.width * 0.08))
                            
                            Image("euro-3")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.height * 0.16, height: geo.size.height * 0.15)
                                .shadow(radius: 5)
                                
                            
                            Text("+"+"\(self.counter1)")
                                .font(Font.custom("Georgia", size: geo.size.height * 0.05))
                                .padding(.trailing, 5)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        
                                        
                                        self.runCounter(counter: self.$counter1, start: 0, end: 15, speed: 0.05)
                                    }
                                }.padding(.top, 20)
                        }.frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                            .padding([.leading, .trailing], geo.size.width * 0.25).padding(.top, 50)
                        
                        if finishedCardSet != "Common Phrases" && finishedCardSet != "MyList"{
                            VStack(spacing: 0){
                                
                                
                                
                                NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: findNextStoryIndex(finishedIn: finishedCardSet)), flashCardSetName: findNextStoryName(finishedIn: finishedCardSet)), label: {
                                    Text("Continue to")
                                        .font(Font.custom("Georgia", size: 19))
                                        .bold()
                                        .foregroundColor(.black)
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("terracotta"))
                                                .frame(width: 130, height: 2.25)
                                            , alignment: .bottom
                                        )
                                        .frame(width: 250, height: 40)
                                        .multilineTextAlignment(.center)
                                    
                                    
                                }).id(UUID())
                                .simultaneousGesture(TapGesture().onEnded{
                                    updateUserCoins()
                                })
                                
                                Image(findNextStoryImage(finishedIn: findNextStoryName(finishedIn: finishedCardSet)))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .padding()
                                
                                
                                
                                Text(findNextStoryName(finishedIn: finishedCardSet))
                                    .font(Font.custom("Georgia", size: 15))
                                    .frame(width: 200, height: 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        if finishedCardSet == "Common Phrases" {
                            VStack(spacing: 0){
                                
                                
                                
                                NavigationLink(destination: flashCardActivity(flashCardObj: dataObj.collectChosenFlashSetData(index: 0), flashCardSetName: "Food"), label: {
                                    Text("Continue to")
                                        .font(Font.custom("Georgia", size: 19))
                                        .bold()
                                        .foregroundColor(.black)
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("terracotta"))
                                                .frame(width: 130, height: 2.25)
                                            , alignment: .bottom
                                        )
                                        .frame(width: 250, height: 40)
                                        .multilineTextAlignment(.center)
                                    
                                    
                                }).id(UUID())
                                .simultaneousGesture(TapGesture().onEnded{
                                    updateUserCoins()
                                })
                                
                                Image("food")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .padding()
                                
                                
                                
                                Text("Food")
                                    .font(Font.custom("Georgia", size: 15))
                                    .frame(width: 200, height: 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        

                    }
                    
                }.onAppear{
                    if finishedCardSet != "MyList"{
                        dataObj = flashCardData(chosenFlashSetIndex: findNextStoryIndex(finishedIn: finishedCardSet))
                        counter2 = globalModel.userCoins
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                           homeButtonDisabled = false
                           
                       }
                }
            } else{
                ActivityCompletePageIPAD()
            }
        
        }.navigationBarBackButtonHidden(true)
       
    }
    
    func findNextStoryIndex(finishedIn: String)->Int{
  
        
        let nextStoryIndex: Int = availableCards.firstIndex(of: finishedIn)! + 1
        
        return nextStoryIndex

    }

    
    func findNextStoryName(finishedIn: String)->String{
  
        
        let nextStoryIndex: Int = availableCards.firstIndex(of: finishedIn)! + 1
       

        return availableCards[nextStoryIndex]
    }

    
    func findNextStoryImage(finishedIn: String)->String{
        var cardImages: [String] = ["food", "animal", "clothes", "family", "dictionary", "dictionary", "dictionary", "dictionary", "talking"]
        
        var nextStoryIndex: Int = availableCards.firstIndex(of: finishedIn)! + 1
        
        return cardImages[nextStoryIndex]
    }
    
    func updateUserCoins(){
            userCoins[0].coins = Int32((globalModel.userCoins + 1005))
            globalModel.userCoins = (globalModel.userCoins + 1005)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("error saving")
        }
    }
    
    
    func runCounter(counter: Binding<Int>, start: Int, end: Int, speed: Double) {
        let maxSteps = 20
        counter.wrappedValue = start
        
        let steps = min(abs(end), maxSteps)
        var increment = 1
        if steps == maxSteps {increment = end/maxSteps}
        
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            counter.wrappedValue += increment
            if counter.wrappedValue >= end {
                counter.wrappedValue = end
                timer.invalidate()
            }
        }
    }
    
    
}


#Preview {
    ActivityCompleteFlashCard(finishedCardSet: "Animals").environmentObject(GlobalModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
