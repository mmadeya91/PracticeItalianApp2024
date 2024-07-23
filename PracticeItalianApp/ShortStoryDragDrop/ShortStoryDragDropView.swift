//
//  ShortStoryDragDropView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/29/23.
//

import SwiftUI

struct ShortStoryDragDropView: View{
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    var isPreview: Bool
    @State var questionNumber = 0
    @State var shortStoryName: String
    @State var showPlayer = false
    @State var showUserCheck = false
    @State var progress: CGFloat = 0.0
    @State var showInfoPopUp = false
    
    
    var body: some View{
            GeometryReader {geo in
                if horizontalSizeClass == .compact {
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
                                .font(.system(size: 25))
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
                        }.frame(height: 13)
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(shortStoryDragDropVM.currentDragDropQuestions.count + 1))
                            }
                    
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Spacer()
                    }.padding([.leading, .trailing], 15).zIndex(1)
                    
                    
                    ZStack(alignment: .topLeading){
                        HStack{
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.75)){
                                    showInfoPopUp.toggle()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            })
                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                        
                        VStack{
                            
                            
                            Text("Drag and the Italian words or phrases in the correct order in the grey boxes to form the sentence listed above in English.")
                                .font(.system(size:18))
                                .multilineTextAlignment(.center)
                                .padding()
                        }.padding(.top, 50)
                    }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.6)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .offset(x: showInfoPopUp ? ((geo.size.width / 2) - geo.size.width * 0.4): -550, y: (geo.size.height / 2) - geo.size.width * 0.35)
                        .zIndex(2)
                    
             
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: geo.size.width  * 0.95, height: geo.size.height * 0.73)
                        .zIndex(0)
                        .padding([.leading, .trailing], geo.size.width * 0.025)
                        .padding([.top, .bottom], geo.size.height * 0.135)
                        .padding(.top, geo.size.height * 0.09)
                        .shadow(radius: 15)
                    
                    ScrollViewReader{scroller in
                        
                        ZStack{
                            if showUserCheck {
                                userCheckNavigationPopUp(showUserCheck: $showUserCheck)
                                    .transition(.slide)
                                    .animation(.easeIn)
                                    .zIndex(2)
                            }
                            VStack{
                                HStack{
                                    Text("Form this sentence")
                                        .font(.title2.bold())
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
                                            .frame(width: 25, height: 25)
                                        
                                    })
                                    .padding(.leading, 5)
                                    .padding(.top, 30)
                                }.offset(y: 20)
                                
                                ScrollView(.horizontal){
                                    
                                    HStack{
                                        ForEach(0..<shortStoryDragDropVM.currentDragDropQuestions.count, id: \.self) { i in
                                            VStack{
                                                
                                                
                                                
                                                
                                                shortStoryDragDropViewBuilder(charactersSet: shortStoryDragDropVM.currentDragDropChoicesList, questionNumber: $questionNumber, progress: $progress, englishSentence: shortStoryDragDropVM.currentDragDropQuestions[i].fullSentence,questionNumberCount: shortStoryDragDropVM.currentDragDropQuestions.count).frame(width: geo.size.width)
                                                    .frame(minHeight: geo.size.height)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                    
                                    if questionNumber == shortStoryDragDropVM.currentDragDropQuestions.count {
                                        showPlayer = true
                                    }
                                }
                                
                                NavigationLink(destination: ShortStoryPlugInView(shortStoryPlugInVM: ShortStoryViewModel(currentStoryIn: shortStoryName), shortStoryName: shortStoryName, isPreview: false),isActive: $showPlayer,label:{}
                                ).isDetailLink(false).id(UUID())
                            }.zIndex(1)
                            
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color("WashedWhite"))
//                                .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.7)
//                                .overlay( /// apply a rounded border
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(.black, lineWidth: 4)
//                                )
//                                .zIndex(0)
//                                .offset(y: (geo.size.height / 9))
                            
                            
                            
                            
                        }
                        .onAppear{
                            shortStoryDragDropVM.setData()
                            shortStoryDragDropVM.setChoiceArrayDataSet()
                            
                        }
                    }
                }else{
                    ShortStoryDragDropViewIPAD(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false, shortStoryName: shortStoryName)
                }
            }.navigationBarBackButtonHidden(true)
    }
}

struct shortStoryDragDropViewBuilder: View {
        
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
    
    var englishSentence: String
    var questionNumberCount: Int
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack {
                    
                    VStack {
                        Text(englishSentence)
                            .bold()
                            .font(Font.custom("Marker Felt", size: geo.size.height * 0.027))
                            .padding()
                            .frame(width:geo.size.width * 0.93, height: geo.size.width * 0.35)
                            .background(Color.teal)
                            .cornerRadius(10)
                            .foregroundColor(Color("WashedWhite"))
                            .multilineTextAlignment(.center)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding([.leading, .trailing], geo.size.width * 0.035)
                    }
                    DropArea()
                        .padding(.vertical, 20)
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
                            .font(.system(size: 17))
                            .padding(.vertical, 5)
                            .padding(.horizontal, item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background{
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
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
        VStack(spacing: 20){
            ForEach(shuffledRows, id: \.self){row in
                HStack(spacing:25){
                    ForEach(row){item in
                        Text(item.value)
                            .font(.system(size: 17))
                            .padding(.vertical, 7)
                            .padding(.horizontal, item.padding)
                            .background{
                                RoundedRectangle(cornerRadius: 0, style: .continuous)
                                    .stroke(.black, lineWidth: 2)
                            }
                            .onDrag{
                                return .init(contentsOf: URL(string: item.id))!
                            } preview: {
                                Text(item.value)
                                    .font(.system(size: 17))
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, item.padding)
                                    .background{
                                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                                            .stroke(.black, lineWidth: 2)
                                    }
                            }
                            .opacity(item.isShowing ? 0 : 1)
        
                    }
                }
                
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
        
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 45
        
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
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
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

struct userCheckNavigationPopUp: View{
    @Binding var showUserCheck: Bool
    
    var body: some View{
        
        GeometryReader{ geo in
            ZStack{
                VStack{
                    
                    
                    Text("Are you Sure you want to Leave the Page?")
                        .bold()
                        .font(Font.custom("Arial Hebrew", size: geo.size.width * 0.05))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 15)
                    
                    Text("You will be returned to the 'select story page' and progress on this exercise will be lost")
                        .font(Font.custom("Arial Hebrew", size: geo.size.width * 0.04))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 15)
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: availableShortStories(), label: {
                            Text("Yes")
                                .font(Font.custom("Arial Hebrew", size: geo.size.width * 0.04))
                                .foregroundColor(Color.blue)
                        }).id(UUID())
                        Spacer()
                        Button(action: {showUserCheck.toggle()}, label: {
                            Text("No")
                                .font(Font.custom("Arial Hebrew", size: geo.size.width * 0.04))
                                .foregroundColor(Color.blue)
                        })
                        Spacer()
                    }.padding(.top, 15)
                    
                }
                
                
            }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.3)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .padding([.leading, .trailing], geo.size.width * 0.1)
                .padding([.top, .bottom], geo.size.height * 0.25)
            
        }
    }
}

struct ShortStoryDragDropView_Previews: PreviewProvider {
    static var shortStoryDragDropVM: ShortStoryDragDropViewModel = ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione")
    static var previews: some View {
        ShortStoryDragDropView(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: true, shortStoryName: "La Mia Introduzione")
    }
}

