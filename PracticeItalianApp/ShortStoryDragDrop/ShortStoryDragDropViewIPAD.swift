//
//  ShortStoryDragDropViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/2/24.
//

import SwiftUI

struct ShortStoryDragDropViewIPAD: View{
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    @Environment(\.dismiss) var dismiss
    var isPreview: Bool
    @State var shortStoryName: String
    @State var questionNumber = 0
    @State var showPlayer = false
    @State var showUserCheck = false
    @State var progress: CGFloat = 0.0
    @State var correctChosen = false
    @State var animateBear = false
    @State var showInfoPopUp = false
    
    var body: some View{
        
            GeometryReader {geo in
                ZStack(alignment: .topLeading){
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    HStack{
                        Button(action: {
                            withAnimation(.linear){
                                showUserCheck.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                            
                        })
                        
                        
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color.green)
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 15)
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(shortStoryDragDropVM.currentDragDropQuestions.count + 1))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Spacer()
                    }.padding([.leading, .trailing], 15).zIndex(1)
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.35)
                        .offset(x: geo.size.width - geo.size.width * 0.4, y: animateBear ? geo.size.height - geo.size.height * 0.125 : 9000)
                        .zIndex(0)
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.height * 0.14, height: geo.size.height * 0.14)
                            .offset(x: geo.size.width - geo.size.width * 0.5, y: geo.size.height - geo.size.height * 0.16)
                    }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.58)
                        .zIndex(0)
                        .padding([.leading, .trailing], geo.size.width * 0.035)
                        .padding([.top, .bottom], geo.size.height * 0.225)
                        .shadow(radius: 15)
                    
                    
                    ZStack(alignment: .topLeading){
                        HStack{
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.75)){
                                    showInfoPopUp.toggle()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 35))
                                    .foregroundColor(.black)
                                
                            })
                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                        
                        VStack{
                            
                            
                            Text("Drag and drop the available Italian words or phrases to the correct position in the grey boxes to form the sentence.")
                                .font(.system(size:25))
                                .multilineTextAlignment(.center)
                                .padding()
                        }.padding(.top, 70)
                    }.frame(width: geo.size.width * 0.6, height: geo.size.height * 0.3)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .offset(x: showInfoPopUp ? ((geo.size.width / 2) - geo.size.width * 0.3): -1550, y: (geo.size.height / 2) - geo.size.width * 0.24)
                        .zIndex(2)
                    
               
                    
                    ScrollViewReader{scroller in
                        
                        ZStack{
                            if showUserCheck {
                                userCheckNavigationPopUpIPAD(showUserCheck: $showUserCheck)
                                    .transition(.slide)
                                    .animation(.easeIn)
                                //.padding(.leading, 20)
                                    .padding(.top, 60)
                                    .zIndex(2)
                            }
                            VStack{
                                
                                ScrollView(.horizontal){
                                    
                                    HStack{
                                        ForEach(0..<shortStoryDragDropVM.currentDragDropQuestions.count, id: \.self) { i in
                                            VStack{
                                                
                                                
                                                
                                                
                                                shortStoryDragDropViewBuilderIPAD(charactersSet: shortStoryDragDropVM.currentDragDropChoicesList, questionNumber: $questionNumber, progress: $progress, showInfoPopUp: $showInfoPopUp, englishSentence: shortStoryDragDropVM.currentDragDropQuestions[i].fullSentence,questionNumberCount: shortStoryDragDropVM.currentDragDropQuestions.count).frame(width: geo.size.width)
                                                    .frame(minHeight: geo.size.height)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    correctChosen = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        correctChosen = false
                                    }
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                    
                                    if questionNumber == shortStoryDragDropVM.currentDragDropQuestions.count {
                                        showPlayer = true
                                    }
                                }
                                
                                NavigationLink(destination: ShortStoryPlugInViewIPAD(shortStoryPlugInVM: ShortStoryViewModel(currentStoryIn: shortStoryName), shortStoryName: shortStoryName, isPreview: false),isActive: $showPlayer,label:{}
                                ).isDetailLink(false).id(UUID())
                                
                                
                            }.zIndex(1)
                            
                            
                            
                            
                            
                            
                        }
                        .onAppear{
                            shortStoryDragDropVM.setData()
                            shortStoryDragDropVM.setChoiceArrayDataSet()
                            withAnimation{
                                animateBear = true
                            }
                        }
                    }
                    
                }
                
            }.navigationBarBackButtonHidden(true)
    }
}

struct shortStoryDragDropViewBuilderIPAD: View {
        
    //choices
    @State var charactersSet: [[dragDropShortStoryCharacter]]
    
    @State var characters: [dragDropShortStoryCharacter] = []
    
    //for drag
    @State var shuffledRows: [[dragDropShortStoryCharacter]] = []
    //for drop
    @State var rows: [[dragDropShortStoryCharacter]] = []
    
    @State var draggingItem: dragDropShortStoryCharacter?
    @State var updating: Bool = false
    
    @State var animateWrongText: Bool = false
    
    @State var droppedCount: CGFloat = 0
    @Binding var questionNumber: Int
    @Binding var progress: CGFloat
    @Binding var showInfoPopUp: Bool
    
    var englishSentence: String
    var questionNumberCount: Int
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack {
                    
                    VStack {
                        HStack{
                            Text("Form this sentence")
                                .font(.system(size: 25))
                                .bold()
                                .padding(.bottom, 15)
                                .padding(.top, 45)
                            
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.75)){
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
                            .padding(.top, 30)
                        }.offset(y: 20)
                            .padding(.top, 20)
                        
                        Text(englishSentence)
                            .bold()
                            .font(Font.custom("Marker Felt", size: geo.size.height * 0.028))
                            .padding()
                            .frame(width:geo.size.width * 0.85, height: geo.size.height * 0.175)
                            .background(Color.teal)
                            .cornerRadius(10)
                            .foregroundColor(Color("WashedWhite"))
                            .multilineTextAlignment(.center)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                            .padding(.top, 20)
                    }
                    DropArea()
                        .padding(.vertical, 70)
                    DragArea()
                }.zIndex(1)
            
            }
        }
        .padding()
        .onChange(of: questionNumber) { newIndex in
            rows.removeAll()
            shuffledRows.removeAll()
            if questionNumber == questionNumberCount {
                
            }else{
                characters = charactersSet[newIndex]
            }
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                //characters = characters.shuffled()
                rows = generateGrid()
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                //rows = generateGrid()
             
            }
    
        }
        .onAppear{
            if questionNumber == 0{
                characters = charactersSet[0]
            }else{
                characters = charactersSet[questionNumber]
            }
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                //characters = characters.shuffled()
                rows = generateGrid()
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                //rows = generateGrid()
            }
        }
        .offset(x: animateWrongText ? -30 : 0)
    }
    
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 12){
            ForEach($rows, id: \.self){$row in
                HStack(spacing:10){
                    ForEach($row){$item in
                        Text(item.value)
                            .font(.system(size: 24))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1: 0)
                            }
                            .onDrop(of: [.url], delegate: ShortStoryDragDropDelegate(currentItem: $item, characters: $characters, draggingItem: $draggingItem, updating: $updating, droppedCount: $droppedCount, animateWrongText: $animateWrongText, shuffledRows: $shuffledRows, progress: $progress, questionNumber: $questionNumber))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func DragArea()->some View {
        VStack(spacing: 40){
            ForEach(shuffledRows, id: \.self){row in
                HStack(spacing:45){
                    ForEach(row){item in
                        Text(item.value)
                            .font(.system(size: 24))
                            .padding(.vertical, 7)
                            .padding(.horizontal, item.padding)
                            .background{
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.black, lineWidth: 3)
                            }
                            .onDrag{
                                return .init(contentsOf: URL(string: item.id))!
                            }
                            .opacity(item.isShowing ? 0 : 1)
                           
                            
                    }
                }//.frame(width: UIScreen.main.bounds.size.width - 200)
                
            }
        }
    }
    
    func generateGrid()->[[dragDropShortStoryCharacter]]{
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
            
        }
        
        var gridArray: [[dragDropShortStoryCharacter]] = []
        var tempArray: [dragDropShortStoryCharacter] = []
        
        var currentWidth: CGFloat = 0
        
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 400
        
        for character in characters {
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth{
                tempArray.append(character)
            }else {
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        if !tempArray.isEmpty{
            gridArray.append(tempArray)
        }
        
        return gridArray
    }
    
    func textSize(character: dragDropShortStoryCharacter)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize )
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2)
    }
    
    func updateShuffledArray(character: dragDropShortStoryCharacter){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateWrongText = false
            }
        }
    }
}

struct userCheckNavigationPopUpIPAD: View{
    @Binding var showUserCheck: Bool
    
    var body: some View{
       
        GeometryReader{ geo in
            ZStack{
                VStack{
                    
                    
                    Text("Are you Sure you want to Leave the Page?")
                        .bold()
                        .font(Font.custom("Arial Hebrew", size: 23))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 25)
                    
                    Text("You will be returned to the 'select story page' and progress on this exercise will be lost.")
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 25)
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: availableShortStories(), label: {
                            Text("Yes")
                                .font(Font.custom("Arial Hebrew", size: 22))
                                .foregroundColor(Color.blue)
                        })
                        Spacer()
                        Button(action: {showUserCheck.toggle()}, label: {
                            Text("No")
                                .font(Font.custom("Arial Hebrew", size: 22))
                                .foregroundColor(Color.blue)
                        })
                        Spacer()
                    }.padding(.top, 25)
                    
                }
                
                
            }.frame(width: geo.size.width * 0.5, height: geo.size.height * 0.3)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .padding([.leading, .trailing], geo.size.width * 0.25)
                .padding([.top, .bottom], geo.size.height * 0.35)
                
        }
        
    }
}

struct ShortStoryDragDropViewIPAD_Previews: PreviewProvider {
    static var shortStoryDragDropVM: ShortStoryDragDropViewModel = ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione")
    static var previews: some View {
        ShortStoryDragDropViewIPAD(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: true, shortStoryName: "La Mia Introduzione")
    }
}

