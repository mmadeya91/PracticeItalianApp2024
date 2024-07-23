//
//  ActivityCompleteShortStory.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/2/24.
//



import SwiftUI

struct ActivityCompleteShortStory: View {
   
    @Environment(\.managedObjectContext) private var viewContext
    //@State var questionCount: Int
    //@State var correctCount: Int
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var counter1 = 0
    @State private var counter2 = 0
    @State var animatingBear = false
    @State var goNext = false
    @State var homeButtonDisabled = true
    var finishedStoryName: String
    
    var availableStories: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana", "Il Mio Animale Preferito", "Il Mio Sport Preferito", "Il Mio Ultimo Compleanno", "Il Mio Sogno nel Cassetto"]
    
    @FetchRequest(
        entity: LastStoryCompleted.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedLastStoryCompleted: FetchedResults<LastStoryCompleted>
    

    
    @FetchRequest(
        entity: UserCompletedActivities.entity(),
        sortDescriptors: [NSSortDescriptor(key: "activityName", ascending: true)]
    ) var fetchedCompletedActivities: FetchedResults<UserCompletedActivities>
    
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
                            Image("cypress2")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.5)
                                .offset(x: geo.size.width * 0.095, y: geo.size.height * 0.1)
                              
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
              
                    HStack{
                        Image("euro-2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 30)
                            .padding(.leading, 25)
                        
                        Text("\(self.counter2)")
                            .font(Font.custom("Arial Hebrew", size: 22))
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
                                .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.05))
                                .padding(.trailing, 5)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        
                                        
                                        self.runCounter(counter: self.$counter1, start: 0, end: 15, speed: 0.05)
                                    }
                                }.padding(.top, 20)
                        }.frame(width: geo.size.width * 0.5, height: geo.size.height * 0.5)
                            .padding([.leading, .trailing], geo.size.width * 0.25).padding(.top, 50)
                        
                        if finishedStoryName != "Il Mio Fine Settimana"{
                            VStack(spacing: 0){
                                
                                var storyData: shortStoryData { shortStoryData(chosenStoryName: findNextStoryName(finishedIn: finishedStoryName))}
                                
                                
                                var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
                                
                                
                                NavigationLink(destination: shortStoryView(chosenStoryNameIn: findNextStoryName(finishedIn: finishedStoryName), shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: findNextStoryName(finishedIn: finishedStoryName)), storyData: storyData, storyObj: storyObj), label: {
                                    Text("Continue to Next Story")
                                        .font(Font.custom("Georgia", size: 19))
                                        .bold()
                                        .foregroundColor(.black)
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("terracotta"))
                                                .frame(width: 225, height: 2.25)
                                            , alignment: .bottom
                                        )
                                        .frame(width: 250, height: 40)
                                        .multilineTextAlignment(.center)
                                        .simultaneousGesture(TapGesture().onEnded {
                                            updateUserCoins()
                                        })
                                    
                                }).id(UUID()).disabled(homeButtonDisabled)
                                
                                Image("book3")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .padding()
                                
                                
                                
                                Text(findNextStoryName(finishedIn: finishedStoryName))
                                    .font(Font.custom("Georgia", size: 15))
                                    .frame(width: 200, height: 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        

                    }
                    
                }.onAppear{
                    counter2 = globalModel.userCoins
                    updateCompletedActivity(finishedIn: finishedStoryName)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                           homeButtonDisabled = false
                           
                       }
                }
            } else{
                ActivityCompletePageIPAD()
            }
        
        }.navigationBarBackButtonHidden(true)
       
    }
    
    func updatedLastCompletedEntities(){
        for entity in fetchedLastStoryCompleted{
            entity.setValue(finishedStoryName, forKey: "storyName")
            entity.setValue(true, forKey: "didComplete")
            
            globalModel.lastStoryCompleted.storyName = finishedStoryName
            globalModel.lastStoryCompleted.didComplete = true
                
        }
        
        do {
            try viewContext.save()
            print("saved!")
           } catch {
         print(error.localizedDescription)
     }
        
    }
    
    func updateCompletedActivity(finishedIn: String){
        for dataSet in fetchedCompletedActivities {
           
            if dataSet.activityName == finishedIn {
                dataSet.isCompleted = true
            }
        }
        
        for i in 0...globalModel.currentUnlockableDataSets.count-1{
            if globalModel.currentUnlockableDataSets[i].setName == finishedIn {
                globalModel.currentUnlockableDataSets[i].isCompleted = true
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("error saving")
        }
    }
    
    
    
    func findNextStoryName(finishedIn: String)->(String){
        var availableStories: [String] = ["La Mia Introduzione", "Il Mio Migliore Amico", "La Mia Famiglia", "Il Mio Animale Preferito", "Le Mie Vacanze in Sicilia", "La Mia Routine", "Il Mio Sport Preferito", "Il Mio Ultimo Compleanno", "Ragù Di Maiale Brasato", "Il Mio Fine Settimana", "Il Mio Sogno nel Cassetto"]
        
        var package1Stories: [String] = ["Il Mio Animale Preferito", "Il Mio Sport Preferito", "Il Mio Ultimo Compleanno", "Il Mio Sogno nel Cassetto"]
        
        var nextStoryIndex: Int = availableStories.firstIndex(of: finishedIn)! + 1
        var nextStory = ""
        
        
        if package1Stories.contains(availableStories[nextStoryIndex]){
            if globalModel.package1Purchased {
                return availableStories[nextStoryIndex]
            }
        }else{
            
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
    
    

    

    
    func updateUserCoins(){
            userCoins[0].coins = Int32((globalModel.userCoins + 1005))
            globalModel.userCoins = (globalModel.userCoins + 1005)
        
        do {
            try viewContext.save()
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


struct ActivityCompleteShortStory_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCompleteShortStory(finishedStoryName: "Il Mio Migliore Amico").environmentObject(GlobalModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
