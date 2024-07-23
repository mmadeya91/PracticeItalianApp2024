//
//  chooseVCActivityIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/5/24.
//

import SwiftUI

struct chooseVCActivityIPAD: View {
    
    @State private var selectedTense = ""
    @State private var showActivity: Bool = false
    @State private var myListIsEmpty: Bool = false
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    
    var fetchedResults: [verbObject] = [verbObject]()
    
    let chooseVCActivityVM = ChooseVCActivityViewModel()
    let verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    let spellConjVerbVM = SpellConjVerbViewModel()
    let dragDropVerbConjugationVM = DragDropVerbConjugationViewModel()
    
    
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
                        
                        NavigationLink(destination: chooseVerbList(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 45))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25)
                            .padding(.top, 20)

                        
                        Spacer()
                        VStack(spacing: 0){
                            Image("italyFlag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 55, height: 55)
                                .shadow(radius: 10)
                                .padding()
                            
                          
                            }
                        }
                    
                    
                    if showInfoPopUp{
                        
                        ZStack(alignment: .topLeading){
                            HStack{
                                Button(action: {
                                    showInfoPopUp.toggle()
                                }, label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 35))
                                        .foregroundColor(.black)
                                    
                                })
                            }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                            
                            VStack{
                                
                                
                                Text("Choose from the following activities to practice conjugating Italian verbs in different tenses. \n\n Choose one of the available tenses from the picker wheel before picking your activity.")
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
                        
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text("Conjugation Exercises").zIndex(1)
                                .font(Font.custom("Marker Felt", size: 50))
                                .foregroundColor(.white)
                           
                            
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
                            Spacer()
                        }.frame(width:  geo.size.width * 0.8, height: 100)
                            .background(Color("DarkNavy")).opacity(0.75)
                            .border(width: 8, edges: [.bottom], color: .teal)
                  
                        Spacer()
                        VStack{
                            HStack{
                                Spacer()
                                VStack{
                                    Button(action: {
                                        chooseVCActivityVM.chosenActivity = 0
                                        verbConjMultipleChoiceVM.currentTense = getTenseInt(tenseString:    selectedTense)
                                        loadData()
                                        showActivity = true
                                    }, label: {
                                        ImageOnCircleVerbConjIPAD(icon: "multipleChoice", radius: geo.size.height * 0.08)
                                        
                                    })
                                    
                                    Text("Multiple Choice")
                                        .font(Font.custom("Futura", size: 20))
                                        .frame(width: 130, height: 80)
                                        .multilineTextAlignment(.center)
                                }.frame(width: 140, height: 200).padding()
                                
                                Spacer()
                                
                                VStack{
                                    Button(action: {
                                        chooseVCActivityVM.chosenActivity = 1
                                        dragDropVerbConjugationVM.currentTense = getTenseInt(tenseString: selectedTense)
                                        dragDropVerbConjugationVM.setNonMyListDragDropData()
                                        showActivity = true
                                    }, label: {
                                        ImageOnCircleVerbConjIPAD(icon: "dragDrop", radius: geo.size.height * 0.08)
                                        
                                    })
                                    
                                    Text("Complete Conjugation Table")
                                        .multilineTextAlignment(.center)
                                        .font(Font.custom("Futura", size: 20))
                                        .frame(width: 130, height: 80)
                                    
                                }.frame(width: 140, height: 200)
                                    .padding()
                                //.offset(y:-1)
                                Spacer()
                            }
                            HStack{
                                VStack{
                                    Button(action: {
                                        chooseVCActivityVM.chosenActivity = 2
                                        spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                                        spellConjVerbVM.setSpellVerbData()
                                        spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                                        showActivity = true
                                    }, label: {
                                        ImageOnCircleVerbConjIPAD(icon: "spellOut", radius: geo.size.height * 0.08)
                                        
                                    })
                                    
                                    Text("Spell it Out")
                                        .font(Font.custom("Futura", size: 20))
                                        .frame(width: 130, height: 80)
                                        .multilineTextAlignment(.center)
                                }.frame(width: 100, height: 100)
                                
                            }.padding()
                        }
                        let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                        Spacer()
                        Picker("Please choose a color", selection: $selectedTense) {
                            ForEach(tenses, id: \.self) {
                                Text($0)
                                    .font(.system(size: 40))
                                    .padding([.top, .bottom], 10)
                                
                            }
                        }.pickerStyle(WheelPickerStyle())
                            .padding(.bottom, 30)
                            
                        
                    }.frame(width:  geo.size.width * 0.8, height: geo.size.height * 0.78)
                    //.shadow(radius: 10)
                        .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                            .stroke(.black, lineWidth: 5))
                        .padding([.leading, .trailing], geo.size.width * 0.1)
                        .padding([.top, .bottom], geo.size.height * 0.15)
                }.onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                }
                
                
                
                
            }.fullScreenCover(isPresented: $showActivity) {
                NavigationView{
                    switch chooseVCActivityVM.chosenActivity {
                    case 0:
                        verbConjMultipleChoiceView(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, isPreview: false)
                    case 1:
                        DragDropVerbConjugationView(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
                    case 2:
                        SpellConjugatedVerbView(spellConjVerbVM: spellConjVerbVM, isPreview: false)
                    default:
                        ChooseVCActivityMyList()
                    }
                }.navigationViewStyle(StackNavigationViewStyle())
            }
            .navigationBarBackButtonHidden(true)
        
    }
    
    func getTenseInt(tenseString: String)->Int{
        switch tenseString {
        case "Presente":
            return 0
        case "Passato Prossimo":
            return 1
        case "Futuro":
            return 2
        case "Imperfetto":
            return 3
        case "Presente Condizionale":
            return 4
        case "Imperativo":
            return 5
        default:
            return 0
        }
    }
    
    func loadData() {
        verbConjMultipleChoiceVM.setMultipleChoiceData()
        verbConjMultipleChoiceVM.isMyList = false
    }
}

struct ImageOnCircleVerbConjIPAD: View {
    
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
                .padding(10)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}

struct chooseVCActivityIPAD_Previews: PreviewProvider {
    static var previews: some View {
        chooseVCActivityIPAD()
    }
}

