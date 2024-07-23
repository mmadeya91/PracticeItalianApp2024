//
//  myListFlashCardActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/17/23.
//

import SwiftUI

extension View {
    func border5(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct myListFlashCardActivity: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
   // var myListCards: FetchedResults<UserMadeFlashCard>
    
    var isEmpty: Bool {myListCards.isEmpty}
    
    //@FetchRequest var myListCards: FetchedResults<UserMadeFlashCard>

//    init() {
//        self._myListCards = FetchRequest(entity: UserMadeFlashCard.entity(), sortDescriptors: [])
//    }
//    
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
    @State var showInfoPopUp = false
    
    @FetchRequest(
        entity: UserFlashCardList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var myListCards: FetchedResults<UserFlashCardList>

    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading) {

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
                                progress = (CGFloat(newValue) / CGFloat(myListCards.count + 1))
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
                
                
                    ZStack{
                        VStack{
                            

                            scrollViewBuilderMyList(flipped: self.$flipped, animate3d: self.$animate3d, counter: self.$counter, showGif: self.$correctShowGif, saved: self.$saved, correctChosen: self.$correctChosen, myListCards: myListCards).padding(.bottom, 160).padding(.top, 40)
                            
                            
                        }.frame(width: geo.size.width)
                            .frame(minHeight: geo.size.height)
   
                        NavigationLink(destination:  ActivityCompleteFlashCard(finishedCardSet: "MyList"),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false).id(UUID())
                    }
                    
                }
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                }
                .onChange(of: counter) { questionNumber in
                    
                    if questionNumber > myListCards.count - 1{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showFinishedActivityPage = true
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
            }else{
                myListFlashCardActivityIPAD()
            }
        }
    
    }
    

}


struct scrollViewBuilderMyList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var leadingPad: CGFloat = 30
    @State var trailingPad: CGFloat = 20
    @State var selected = false

    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    @Binding var counter: Int
    @Binding var showGif: Bool
    @Binding var saved: Bool
    @Binding var correctChosen: Bool
    
    var myListCards: FetchedResults<UserFlashCardList>
    
    var body: some View{
        GeometryReader{geo in
            ScrollViewReader {scrollView in
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<myListCards.count, id: \.self) {i in
                            cardViewMyList(flipped: $flipped, animate3d: $animate3d, counterTest: i, myListCards: myListCards).frame(width: geo.size.width)
                            
                        }
                    }
                }.scrollDisabled(true)
                VStack{
                    HStack{
                        Button(action: {
                            
                            withAnimation{
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    animate3d.toggle()
                                    if counter < myListCards.count - 1 {
                                        counter = counter + 1
                                    }
                                    withAnimation{
                                        scrollView.scrollTo(counter, anchor: .center)
                                    }
                                }
                                
                                self.selected.toggle()
                                SoundManager.instance.playSound(sound: .wrong)
                                
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
                        
                        Spacer()
                        
                        
                        Button(action: {
                            
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                animate3d.toggle()
                                showGif.toggle()
                                if counter < myListCards.count - 1 {
                                    counter = counter + 1
                                }
                                withAnimation{
                                    scrollView.scrollTo(counter)
                                }
                                correctChosen = false
                                
                            }
                            SoundManager.instance.playSound(sound: .correct)
                            correctChosen = true
                            
                        }, label:
                                {Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .scaleEffect(1.5)
                                .bold()
                            
                            
                            
                            
                            
                        }).padding(.trailing, 60)
                            .frame(height: 60)
                            .buttonStyle(ThreeDButtonCircle(backgroundColor: "ForestGreen"))
                    }
                    //                Button(action: {
                    //                    deleteItems(cardToDelete: myListCards[counter])
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    //                        animate3d.toggle()
                    //                        if counter < myListCards.count - 1 {
                    //                            counter = counter + 1
                    //                        }
                    //                        withAnimation{
                    //                            scrollView.scrollTo(counter, anchor: .center)
                    //                        }
                    //                    }
                    //                }, label: {
                    //                    Text("Remove from List").padding(.top, 5)
                    //                        .font(Font.custom("Arial Hebrew", size: 15))
                    //                        .foregroundColor(Color.black)
                    //                       // .frame(width: 150, height: 40)
                    //                       // .background(Color.orange)
                    //                        .cornerRadius(20)
                    //                    
                    //                }).buttonStyle(ThreeDButton(backgroundColor: "white"))     .frame(width: 150, height: 40).padding(.top, 20)
                }.opacity(flipped ? 1 : 0).animation(.easeIn(duration: 0.3), value: flipped)
            }
        }
      
    }
    
    func deleteItems(cardToDelete: UserFlashCardList) {
        withAnimation {

                    viewContext.delete(cardToDelete)
            
            do {
                try viewContext.save()
            } catch {
                
            }
        }
    }
}

struct noCardsInList: View {
    var body: some View{
        Text("You have no cards in your list!")
            .bold()
            .font(Font.custom("Marker Felt", size: 35))
            .frame(width: 350, height: 200)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(20)
            .padding([.leading, .trailing], 20)
            .multilineTextAlignment(.center)
    }
}


struct cardViewMyList: View {
    @State var flip: Bool = false
    @State var showBack = false
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var counterTest: Int
    var myListCards: FetchedResults<UserFlashCardList>
    
    
    var body: some View{
        ZStack() {

            flashCardItalMyList(counterTest: counterTest, userMadeFlashCards: myListCards).modifier(FlipOpacityMyList(percentage: showBack ? 0 : 1))
            .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
            flashCardEngMyList(counterTest: counterTest, userMadeFlashCards: myListCards).modifier(FlipOpacityMyList(percentage: showBack ? 1 : 0))
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

private struct FlipOpacityMyList: AnimatableModifier {
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

struct flashCardItalMyList: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserFlashCardList>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].italianLine1!)
                .font(Font.custom("Georgia", size: 30))
                .padding(.top, 70)
                .padding([.leading, .trailing], 10)
            
            starAndAccuracy(cardName: userMadeFlashCards[counterTest].italianLine1!)
            
            

        } .frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 5)
            )
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding([.top, .bottom], 75)
    }
}

struct flashCardEngMyList: View {
    
    var counterTest: Int

    var userMadeFlashCards: FetchedResults<UserFlashCardList>
    
    
    var body: some View{
        VStack{
            Text(userMadeFlashCards[counterTest].englishLine1!)
                .font(Font.custom("Georgia", size: 30))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(userMadeFlashCards[counterTest].englishLine2!)
                .font(Font.custom("Georgia", size: 20))
                .foregroundColor(Color.black)
                .padding(.top, 2)
                .padding([.leading, .trailing], 10)
            
        } .frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 5)
            )
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding([.top, .bottom], 75)
    }
}

struct starAndAccuracyMyList: View {
    
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


struct myListFlashCardActivity_Previews: PreviewProvider {

   static var previews: some View {
       myListFlashCardActivity().environment(\.managedObjectContext,
      PersistenceController.preview.container.viewContext)

   }
}
