//
//  chooseVCActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/12/23.
//

import SwiftUI


class ChooseVCActivityViewModel: ObservableObject {
    @Published var chosenActivity: Int = 0
}

struct chooseVCActivity: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedTense = ""
    @State private var showActivity: Bool = false
    @State private var myListIsEmpty: Bool = false
    @State private var animatingBear = false
    @State private var showInfoPopUp = false
    @State var myList = false
    
    var fetchedResults: [verbObject] = [verbObject]()
    
    let chooseVCActivityVM = ChooseVCActivityViewModel()
    let verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    let spellConjVerbVM = SpellConjVerbViewModel()
    let dragDropVerbConjugationVM = DragDropVerbConjugationViewModel()
    
    var infoManager = InfoBubbleDataManager(activityName: "chooseVCActivity")
    
    let infoText:Text =  (Text("Choose what tense you want to practice with from the picker wheel on the bottom and then pick an exercise. You can create a customized list of verbs to practice with by clicking EditMyList. If you want to use your personalized list with the exercises, toggle the UseMyList button in the top right corner. \n\nIf at anytime during the exercises you see a verb you want to save to your personal list, look for the ") +
                          Text(Image(systemName: "square.and.arrow.down")) +
                         Text("  symbol. If you need some help to understand how to do the activities themselves, look for the  ") +
                         Text(Image(systemName: "info.circle.fill")) +
                         Text("  symbol."))
    
    @FetchRequest(
        entity: UserVerbList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "verbNameItalian", ascending: true)]
    ) var items: FetchedResults<UserVerbList>
    
    
    var body: some View {
            GeometryReader{ geo in
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
                                    .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.45)
                                    .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.1)
                                  
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
                        
                        HStack(alignment: .top){
                            
                            NavigationLink(destination: ContentView(), label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            }).padding(.leading, 25)
                                .padding(.top, 20).id(UUID())
                            
                            
                            Spacer()
                          
                                
                                Toggle("Use MyList", isOn: $myList).frame(width: 150).padding(.top, 20).padding(.trailing, 25)
                                
                                
                                
                            
                        }
                    
                    
                        VStack{
                            VStack{
                                ZStack{
                                    HStack(spacing: 0){
                                        Text("Practice Activities")
                                            .font(Font.custom("Georgia", size: 28))
                                            .foregroundColor(.white)
                                            .padding(.leading, 35)
                                        
                                        
                                        PopOverViewTopWithImages(textIn: infoText, infoBubbleColor: Color.white, frameHeight: CGFloat(440), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                                    } .frame(width: 350, height: 60)
                                        .background(Color("espressoBrown"))
                                        .cornerRadius(15)
                                        .shadow(radius: 3)
                                        .zIndex(1)
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: 350, height: 60)
                                        .foregroundColor(Color("darkEspressoBrown"))
                                        .zIndex(0)
                                        .offset(y:7)
                                        .shadow(radius: 3)
                                        .zIndex(0)
                                }.offset(y: -7)
                            }
                            VStack{
                                HStack{
                                    Spacer()
                                    VStack{
                                        Button(action: {
                                            if myList{
                                                chooseVCActivityVM.chosenActivity = 0
                                                verbConjMultipleChoiceVM.currentTense = getTenseInt(tenseString: selectedTense)
                                                verbConjMultipleChoiceVM.createMultipleChoiceVerbObjects(myListIn: items)
                                                verbConjMultipleChoiceVM.setMyListMultipleChoiceData()
                                                showActivity = true
                                            }else{
                                                chooseVCActivityVM.chosenActivity = 0
                                                verbConjMultipleChoiceVM.currentTense = getTenseInt(tenseString:    selectedTense)
                                                loadData()
                                                showActivity = true
                                            }
                                        }, label: {
                                            Image("multipleChoice")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 45)
                                                .padding()
                                                .background(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2)
                                            
                                        })
                                        
                                        Text("Multiple Choice")
                                            .font(Font.custom("Georgia", size: 15))
                                            .frame(width: 130, height: 50)
                                            .multilineTextAlignment(.center)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack{
                                        Button(action: {
                                            if myList{
                                                chooseVCActivityVM.chosenActivity = 1
                                                dragDropVerbConjugationVM.currentTense = getTenseInt(tenseString: selectedTense)
                                                dragDropVerbConjugationVM.setAllUserMadeList(myListIn: items)
                                                dragDropVerbConjugationVM.setMyListDragDropData()
                                                showActivity = true
                                            }else{
                                                chooseVCActivityVM.chosenActivity = 1
                                                dragDropVerbConjugationVM.currentTense = getTenseInt(tenseString: selectedTense)
                                                dragDropVerbConjugationVM.setNonMyListDragDropData()
                                                showActivity = true
                                            }
                                        }, label: {
                                            Image("dragDrop")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 45)
                                                .padding()
                                                .background(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2)
                                            
                                        })
                                        
                                        Text("Complete Conjugation Table")
                                            .font(Font.custom("Georgia", size: 15))
                                            .frame(width: 130, height: 50)
                                            .multilineTextAlignment(.center)
                                    }
                                    Spacer()
                                }
                                HStack{
                                    Spacer()
                                    VStack{
                                        Button(action: {
                                            if myList{
                                                chooseVCActivityVM.chosenActivity = 2
                                                spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                                                spellConjVerbVM.setSpellVerbData()
                                                spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                                                showActivity = true
                                            }else{
                                                chooseVCActivityVM.chosenActivity = 2
                                                spellConjVerbVM.currentTense = getTenseInt(tenseString: selectedTense)
                                                spellConjVerbVM.setSpellVerbData()
                                                spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                                                showActivity = true
                                            }
                                        }, label: {
                                            Image("spellOut")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75, height: 45)
                                                .padding()
                                                .background(.white)
                                                .cornerRadius(10)
                                                .shadow(radius: 2)
                                            
                                        })
                                        
                                        Text("Spell it Out")
                                            .font(Font.custom("Georgia", size: 15))
                                            .frame(width: 130, height: 50)
                                            .multilineTextAlignment(.center)
                                    }
                                    Spacer()
                                    VStack{
                                       
                                        
                                        VStack{
                                            Button(action: {
                                                if myList{
                                                    chooseVCActivityVM.chosenActivity = 3
                                                    showActivity = true
                                                    
                                                }else{
                                                    chooseVCActivityVM.chosenActivity = 3
                                                    showActivity = true
                                                }
                                                
                                            }, label: {
                                                Image("myVerbList")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 75, height: 45)
                                                    .padding()
                                                    .background(.white)
                                                    .cornerRadius(10)
                                                    .shadow(radius: 2)
                                                
                                            })
                                            
                                            Text("Edit My List")
                                                .font(Font.custom("Georgia", size: 15))
                                                .frame(width: 130, height: 50)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    Spacer()
                                }.padding(.top, 15)
                                
                                let tenses: [String] = ["Presente", "Passato Prossimo", "Futuro", "Imperfetto", "Presente Condizionale", "Imperativo"]
                                
                                Picker("Please choose a color", selection: $selectedTense) {
                                    ForEach(tenses, id: \.self) {
                                        Text($0)
                                            .font(.title)
                                        
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                    .padding(.bottom, 20)
                                    .frame(width: geo.size.width * 0.8)
                                
                            }.frame(width:  geo.size.width * 0.86, height: geo.size.height * 0.85)
                                .background(Color("WashedWhite").opacity(0.0)).cornerRadius(10)
                                .padding([.leading, .trailing], geo.size.width * 0.07).opacity(myListIsEmpty && myList ? 0.0 : 1.0)
                           
                        }.offset(y: geo.size.height * 0.14)
                        
                        
                        //.padding(.top, geo.size.height * 0.14)
                    }.onAppear{
                        myListIsEmpty = isEmptyMyListVerbData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            withAnimation(.spring()){
                                animatingBear = true
                            }
                        }
                    }
                    
                    
                }else{
                    chooseVCActivityIPAD()
                }
                
            }.fullScreenCover(isPresented: $showActivity, onDismiss: {myListIsEmpty = isEmptyMyListVerbData()}) {
                switch chooseVCActivityVM.chosenActivity {
                case 0:
                    verbConjMultipleChoiceView(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, isPreview: false)
                case 1:
                    DragDropVerbConjugationView(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
                case 2:
                    SpellConjugatedVerbView(spellConjVerbVM: spellConjVerbVM, isPreview: false)
                case 3:
                    ListViewOfAvailableVerbs()
                default:
                    ChooseVCActivityMyList()
                }
            
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
    
    func isEmptyMyListVerbData() -> Bool {
        
        let fR =  UserVerbList.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
}


struct chooseVCActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseVCActivity().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
