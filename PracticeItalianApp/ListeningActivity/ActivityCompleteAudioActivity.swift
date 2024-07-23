//
//  ActivityCompleteAudioActivity.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/2/24.
//



import SwiftUI

struct ActivityCompleteAudioActivity: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    //@State var questionCount: Int
    //@State var correctCount: Int
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var counter1 = 0
    @State private var counter2 = 0
    @State var animatingBear = false
    @State var goNext = false
    @State var homeButtonDisabled = true
    
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    
    var finishedAudioName: String
    
    var availableAudio: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento", "Il Colloquio di Lavoro", "Alla Ricerca di un Appartamento", "Il Festival di Sanremo"]
    
    var audioImages: [String] = ["pot", "dinner", "directions", "clothesStore", "renaissance", "interview", "rent", "festival"]
    
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
                        
                        if finishedAudioName != "Il Rinascimento"{
                            VStack(spacing: 0){
                                
                                
                                
                                NavigationLink(destination: listeningActivity( listeningActivityVM: listeningActivityVM), label: {
                                    Text("Continue to Next Audio")
                                        .font(Font.custom("Georgia", size: 19))
                                        .bold()
                                        .foregroundColor(.black)
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("terracotta"))
                                                .frame(width: 230, height: 2.25)
                                            , alignment: .bottom
                                        )
                                        .frame(width: 250, height: 40)
                                        .multilineTextAlignment(.center)
                                    
                                    
                                }).id(UUID())
                                .simultaneousGesture(TapGesture().onEnded{
                                    updateUserCoins()
                                    listeningActivityVM.setAudioData(chosenAudio: findNextStoryName(finishedIn: finishedAudioName))
                                })
                                
                                Image(findNextStoryImage(finishedIn: findNextStoryName(finishedIn: finishedAudioName)))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .padding()
                                
                                
                                
                                Text(findNextStoryName(finishedIn: finishedAudioName))
                                    .font(Font.custom("Georgia", size: 15))
                                    .frame(width: 200, height: 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        

                    }
                    
                }.onAppear{
                    counter2 = globalModel.userCoins
                    updateCompletedActivity(finishedIn: finishedAudioName)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                           homeButtonDisabled = false
                           
                       }
                }
            } else{
                ActivityCompletePageIPAD()
            }
        
        }.navigationBarBackButtonHidden(true)
       
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
            try managedObjectContext.save()
        } catch {
            print("error saving")
        }
    }
    
    func findNextStoryName(finishedIn: String)->String{
        var availableAudio: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Alla Ricerca di un Appartamento", "Il Festival di Sanremo", "Il Rinascimento", "Il Colloquio di Lavoro"]
        
        var package1Audio: [String] = ["Il Colloquio di Lavoro", "Alla Ricerca di un Appartamento", "Il Festival di Sanremo"]
        
        
        var nextStoryIndex: Int = availableAudio.firstIndex(of: finishedIn)! + 1
        var nextAudio = ""
        
        if package1Audio.contains(availableAudio[nextStoryIndex]){
            if globalModel.package1Purchased {
                return availableAudio[nextStoryIndex]
            }
        }else{
            
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
    
    
    func findNextStoryImage(finishedIn: String)->String{
        var availableAudio: [String] = ["Pasta alla Carbonara", "Cosa Desidera?", "Indicazioni per gli Uffizi", "Stili di Bellagio", "Il Rinascimento", "Il Colloquio di Lavoro", "Alla Ricerca di un Appartamento", "Il Festival di Sanremo"]
        
        var nextStoryIndex: Int = availableAudio.firstIndex(of: finishedIn)! 
        
        return audioImages[nextStoryIndex]
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


struct ActivityCompleteAudioActivity_Previews: PreviewProvider {
    static let listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.cosaDesidera)
    static var previews: some View {
        ActivityCompleteAudioActivity(listeningActivityVM:  listeningActivityVM, finishedAudioName: "Cosa Desidera?").environmentObject(GlobalModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

