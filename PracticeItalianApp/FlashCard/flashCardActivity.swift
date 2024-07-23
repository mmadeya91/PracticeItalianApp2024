//
//  flashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/14/23.
//

import SwiftUI

extension Image {
    
    func imageStarModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
}

struct flashCardActivity: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var flashCardObj: flashCardObject
    
    var flashCardSetName: String
    
    @State  var flipped = false
    @State  var animate3d = false
    @State  var showButtonSet = false
    @State var nextBackClicked = false
    @State var correctShowGif = false
    @State var progress: CGFloat = 0
    
    @State var saved = false
    @State var animatingBear = false
    @State var correctChosen = false
    @State var showFinishedActivityPage = false
    
    @State  var counter: Int = 0
    
    @State var leadingPad: CGFloat = 20
    @State var trailingPad: CGFloat = 20
    @State var selected = false
    @State var showInfoPopUp = false
    @State var enableButtons = true
    @State var activityDone = false
    
    let infoText:Text =  (Text("Lines of audio from the dialogue will play one by one. Some of them will be missing important keywords that you must figure out and input in the text box. \n\nNot all of the dialogues pose a question, in that case use the  ") +
                         Text(Image(systemName: "arrow.forward.circle")) +
                         Text("  button to continue forward. If you need to hear a portion of the dialogue again, just use the  ") +
                         Text(Image(systemName: "arrow.triangle.2.circlepath")) +
                         Text("  button. If you are having trouble, there are hints available to you as well. \n\nRemember, spelling is important! including accents! It may be usefull to switch the keyboard on your phone to 'Italian' to make things easier."))
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
 
    

    
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
                    
                    HStack(spacing: 18){
                        Spacer()
                        NavigationLink(destination: ContentView(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                            
                        }).id(UUID())
                        
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color("ForestGreen"))
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 11)
                            .onChange(of: counter){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(flashCardObj.words.count + 1))
                            }
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.zIndex(2)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.6, height: 100)
                        .offset(x: 195, y: animatingBear ? (geo.size.height - 25 ): 750)
                    
                    if saved {
                        
                        Image("bubbleChatSaved")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(x: 155, y: geo.size.height - 90 )
                        
                    }
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 40)
                            .offset(x: 155, y: geo.size.height - 90 )
                    }
                    
                    
                    if showInfoPopUp{
                        ZStack(alignment: .topLeading){
                            Button(action: {
                                showInfoPopUp.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 15)
                                .zIndex(1)
                                .offset(y: -15)
                           
                         
             
                                
                            (Text("Click on the flashcard card to flip and review the English translation. Then choose if you guessed correctly with the corresponding buttons. \n\nIf you would like further practice with the word you can save it to 'MyList' using the save button in the bottom left for future practice. In the bottom right of each flashcard is how many correct guesses you have mad per total attempts. Each flash card is also given a star rating based on how many times you have correctly guessed this word. If you see a card with a 1 or 2 star rating, you may want to add it to 'MyList' for further practice! "))
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .offset(y: 20)
                                    
                         
                        }.frame(width: geo.size.width * 0.85, height: 500)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .transition(.slide).animation(.easeIn).zIndex(2)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                            .padding([.top, .bottom], geo.size.height * 0.12)
                            .zIndex(3)
                        
                        
                    }
                    
                    VStack{
                        
                    
                        var fCAM = FlashCardAccDataManager(cardName: activityDone ? "" : flashCardObj.words[counter].wordItal)
     
                        ScrollViewReader {scrollView in
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<flashCardObj.words.count, id: \.self) {i in
                                        cardView(flipped: $flipped, animate3d: $animate3d, counterTest: i , flashCardObj: $flashCardObj, showInfoPopUp: $showInfoPopUp)
                                            .frame(width: geo.size.width)
                                        
                                    }
                                }
                            }.scrollDisabled(true)
                            VStack(spacing: 0){
                                HStack{
                                    Button(action: {
                                        if counter + 1 >= flashCardObj.words.count{
                                            SoundManager.instance.playSound(sound: .correct)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                activityDone = true
                                            }
                                        }else{
                                            SoundManager.instance.playSound(sound: .wrong)
                                            enableButtons = false
                                            withAnimation{
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                                    animate3d.toggle()
                                                    
                                                    counter = counter + 1
                                                    
                                                    withAnimation{
                                                        scrollView.scrollTo(counter, anchor: .center)
                                                    }
                                                    enableButtons = true
                                                }
                                                
                                                if fCAM.isEmptyFlashCardAccData() {
                                                    fCAM.addNewCardAccEntityIncorrect(setName: flashCardSetName)
                                                }else{
                                                    
                                                    fCAM.updateIncorrectInput(card: fCAM.getAccData(), setName: flashCardSetName)
                                                }
                                                
                                               // self.selected.toggle()
                                                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                                                    selected.toggle()
                                                }
                                                
                                                selected.toggle()
                                                
                                            }
                                        }
                                    }, label:
                                            {Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .scaleEffect(1.5)
                                            .bold()
                                            .offset(x: selected ? -5 : 0)
      
                                        
                                        
                                        
                                    }).padding(.leading, 60)
                                        .frame(height: 60)
                                        .buttonStyle(ThreeDButtonCircle(backgroundColor: "terracotta"))
                                        
                                        .enabled(enableButtons)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        if counter + 1 >= flashCardObj.words.count{
                                            SoundManager.instance.playSound(sound: .correct)
                                            correctChosen = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                activityDone = true
                                            }
                                        }else{
                                            enableButtons = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                animate3d.toggle()
                                                correctChosen = false
                                                
                                                
                                                counter = counter + 1
                                                
                                                withAnimation{
                                                    scrollView.scrollTo(counter, anchor: .center)
                                                }
                                                enableButtons = true
                                            }
                                            SoundManager.instance.playSound(sound: .correct)
                                            correctChosen = true
                                            
                                            if fCAM.isEmptyFlashCardAccData() {
                                                fCAM.addNewCardAccEntityCorrect(setName: flashCardSetName)
                                            } else {
                                                fCAM.updateCorrectInput(card: fCAM.getAccData(), setName: flashCardSetName)
                                            }
                                            
                                            
                                            correctShowGif.toggle()
                                        }
                                        
                                    }, label:
                                            {Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .scaleEffect(1.5)
                                            .bold()
                                
                                        
                                        
                                        
                                        
                                    }).padding(.trailing, 60)
                                        .frame(height: 60)
                                        .buttonStyle(ThreeDButtonCircle(backgroundColor: "ForestGreen"))
                                        .enabled(enableButtons)
                                }
                                
                                
                            }.opacity(flipped ? 1 : 0)
                                .offset(y: -60)
                        }
                        
                        //                    scrollViewBuilder(flipped: self.$flipped, animate3d: self.$animate3d, flashCardObj: self.$flashCardObj, counter: self.$counter, showGif: self.$correctShowGif, saved: self.$saved, correctChosen: self.$correctChosen, setName: flashCardSetName)
                        //                        //.frame(width: geo.size.width * 0.9)
                        //                        //.padding([.leading, .trailing], geo.size.width * 0.05)
                        
                        
                        
                    }
                    .frame(width: geo.size.width)
                    .frame(minHeight: geo.size.height)
                    .offset(y: -45)
                    //.padding([.leading, .trailing], geo.size.width * 0.1)
                    
                    VStack{
                        HStack{
                            
                            saveToMyListButton(italLine1: flashCardObj.words[counter].wordItal,  engLine1: flashCardObj.words[counter].wordEng, engLine2: flashCardObj.words[counter].gender, saved: $saved)
                                .offset(y: -10)
                            
                            
                            PopOverViewBottom(textIn: infoText, infoBubbleColor: Color.black, frameHeight: CGFloat(500), isInfoPopTipShown: launchedBefore)
                        }
                       
                            
                        
                    }  .frame(maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(15)
                        .padding(.leading, 45)
                    
    
                    
                    NavigationLink(destination:  ActivityCompleteFlashCard(finishedCardSet: flashCardSetName),isActive: $activityDone,label:{}
                    ).isDetailLink(false).id(UUID())
                    
                }
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                }
                .onChange(of: counter) { questionNumber in
                    flipped = false
      
                }
                .navigationBarBackButtonHidden(true)
            }else{
                flashCardActivityIPAD(flashCardObj: flashCardObj, flashCardSetName: flashCardSetName)
            }
        }
    
    }
    
    func storeSetAccuracyData(){
        
    }
    
}

struct scrollViewBuilder: View {
    
    @State var leadingPad: CGFloat = 20
    @State var trailingPad: CGFloat = 20
    @State var selected = false

    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var flashCardObj: flashCardObject
    @Binding var counter: Int
    @Binding var showGif: Bool
    @Binding var saved: Bool
    @Binding var correctChosen: Bool
    @Binding var showInfoPopUp: Bool
    
    var setName: String
    
    var body: some View{
        
        let fCAM = FlashCardAccDataManager(cardName: flashCardObj.words[counter].wordItal)
        
        ScrollViewReader {scrollView in
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<flashCardObj.words.count, id: \.self) {i in
                        cardView(flipped: $flipped, animate3d: $animate3d, counterTest: i , flashCardObj: $flashCardObj, showInfoPopUp: $showInfoPopUp)
                            
                    }
                }
            }.scrollDisabled(true)
            VStack{
                HStack{
                    Button(action: {
                        SoundManager.instance.playSound(sound: .wrong)
                        withAnimation{
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                animate3d.toggle()
                                if counter < flashCardObj.words.count - 1 {
                                    counter = counter + 1
                                }
                                withAnimation{
                                    scrollView.scrollTo(counter, anchor: .center)
                                }
                            }
                            
                            if fCAM.isEmptyFlashCardAccData() {
                                fCAM.addNewCardAccEntityIncorrect(setName: setName)
                            }else{
                                
                                fCAM.updateIncorrectInput(card: fCAM.getAccData(), setName: setName)
                            }
                            
                            self.selected.toggle()

                        }
                    }, label:
                            {Image("cancel")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .offset(x: selected ? -5 : 0)
                            .animation(Animation.default.repeatCount(5).speed(6))
                        
                        
                        
                    }).padding(.leading, 60)
                    
                    Spacer()
                    
                    saveToMyListButton(italLine1: flashCardObj.words[counter].wordItal,  engLine1: flashCardObj.words[counter].wordEng, engLine2: flashCardObj.words[counter].gender, saved: $saved)
                    
                    Spacer()
                    
                    Button(action: {
                        
    
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            animate3d.toggle()
                            correctChosen = false
                            if counter < flashCardObj.words.count - 1 {
                                counter = counter + 1
                            }
                            withAnimation{
                                scrollView.scrollTo(counter, anchor: .center)
                            }
                        }
                            SoundManager.instance.playSound(sound: .correct)
                            correctChosen = true
                        
                        if fCAM.isEmptyFlashCardAccData() {
                            fCAM.addNewCardAccEntityCorrect(setName: setName)
                        } else {
                            fCAM.updateCorrectInput(card: fCAM.getAccData(), setName: setName)
                        }
                        
                        
                            showGif.toggle()
                        
                    }, label:
                            {Image("checked")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                        
                        
                        
                        
                    }).padding(.trailing, 60)
                }
                
    
            }.opacity(flipped ? 1 : 0).animation(.easeIn(duration: 0.3), value: flipped)
        }
      
    }
}


struct cardView: View {
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    @Binding var flashCardObj: flashCardObject
    @Binding var showInfoPopUp: Bool
    @State var flip: Bool = false
    @State var showBack = false

    
    var body: some View{
        ZStack{
            flashCardItal(counterTest: counterTest, fcO: $flashCardObj, showInfoPopUp: $showInfoPopUp).modifier(FlipOpacity(percentage: showBack ? 0 : 1))
                .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
            flashCardEng(counterTest: counterTest, fcO: $flashCardObj)   .modifier(FlipOpacity(percentage: showBack ? 1 : 0))
                .rotation3DEffect(Angle.degrees(showBack ? 0 : 180), axis: (0,1,0))
        }
        .rotation3DEffect(.degrees(flip ? -180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(Animation.linear(duration: 0.4)) {
                self.showBack.toggle()
                self.flipped.toggle()
            }
        }
        
    }
}

private struct FlipOpacity: AnimatableModifier {
   var percentage: CGFloat = 0
   
   var animatableData: CGFloat {
      get { percentage }
      set { percentage = newValue }
   }
   
   func body(content: Content) -> some View {
      content
           .opacity(Double(percentage.rounded()))
   }
}


struct flashCardItal: View {
    
    var counterTest: Int
    
    @Binding var fcO: flashCardObject
    @Binding var showInfoPopUp: Bool
    
    
    var body: some View{
        ZStack(alignment: .topLeading){

            VStack{
                Text(fcO.words[counterTest].wordItal)
                    .font(Font.custom("Georgia", size: 30))
                    .multilineTextAlignment(.center)
                    .padding(.top, 70)
                    .padding([.leading, .trailing], 10)
                
                starAndAccuracy(cardName: fcO.words[counterTest].wordItal)
                
                
                
            }
            
            
        }.frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 5)
            )
            .cornerRadius(5)
            .shadow(radius: 10)
            .padding([.top, .bottom], 75)
    }
}

struct flashCardEng: View {
    
    var counterTest: Int

    @Binding var fcO: flashCardObject
    
    
    var body: some View{
        VStack{
            Text(fcO.words[counterTest].wordEng)
                .font(Font.custom("Georgia", size: 30))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(fcO.words[counterTest].gender)
                .multilineTextAlignment(.center)
                .font(Font.custom("Georgia", size: 20))
                .foregroundColor(Color.black)
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 5)
            )
            .cornerRadius(5)
            .shadow(radius: 10)
            .padding([.top, .bottom], 75)
            //.shadow(radius: 10)
            //.padding()
    }
}

struct starAndAccuracy: View {
    
    var cardName: String
    
    var body: some View{
        let fCAM = FlashCardAccDataManager(cardName: cardName)
        let isEmpty = fCAM.isEmptyFlashCardAccData()
        

        if isEmpty {
            HStack{
                Image("emptyStar")
                    .imageStarModifier()
                Image("emptyStar")
                    .imageStarModifier()
                Image("emptyStar")
                    .imageStarModifier()
                Spacer()
                Text("0/0")
                    .font(Font.custom("Arial Hebrew", size: 30))
            }.padding([.leading, .trailing], 20)
                .padding(.top, 55)
        } else {
            
            let fetchedResults = fCAM.getAccData()
            let numOfStars = fCAM.getNumOfStars(card: fetchedResults)
            
            switch numOfStars {
                case 0:
                    HStack{
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                
                case 1:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 2:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Image("emptyStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                case 3:
                    HStack{
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Image("fullStar")
                            .imageStarModifier()
                        Spacer()
                        Text(String(fetchedResults.correct) + " / " + String(fetchedResults.cardAttempts))
                    }.padding([.leading, .trailing], 20).padding(.top, 55)
                default:
                    HStack{
                        Text("Error")
                    }
            }
            
        }
        
    }
}


struct saveToMyListButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var italLine1: String
    var engLine1: String
    var engLine2: String
    
    @Binding var saved: Bool
    
    var body: some View{
        Button(action: {
            addItem()
            saved = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                saved = false
            }
            
        }, label: {
            Image(systemName: "square.and.arrow.down")
                .foregroundColor(.black)
                .font(.system(size: 45))
                .frame(width: 40, height: 40)
        })
    }
    
    private func addItem() {
        withAnimation {
            let newFlashCardEntity = UserFlashCardList(context: viewContext)
            newFlashCardEntity.italianLine1 = italLine1
            newFlashCardEntity.italianLine2 = ""
            newFlashCardEntity.englishLine1 = engLine1
            newFlashCardEntity.englishLine2 = engLine2
            

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
            }
        }
    }
}




struct flashCardActivity_Previews: PreviewProvider {
 
    static var previews: some View {
        flashCardActivity(flashCardObj: flashCardObject.Family, flashCardSetName: "Family")
    }
}
