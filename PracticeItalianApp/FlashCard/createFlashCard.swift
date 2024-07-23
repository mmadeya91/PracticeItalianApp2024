//
//  createFlashCard.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/16/23.
//

import SwiftUI


struct createFlashCard: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var showingSheet = false
    
    @State  var flipped = false
    @State  var animate3d = false
    @State var saved = true
    
    @State var frontUserInput1: String = ""
    @State var frontUserInput2: String = ""
    @State var backUserInput1: String = ""
    @State var backUserInput2: String = ""
    
    var editMyListManager: EditMyFlashCardListManager
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader {geo in
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
                    HStack(alignment: .top){
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                        }).padding(.leading, 25)
                            .padding(.top, 20)
                        
                        
                        
                        Spacer()
                     
                            Image("italy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .padding()
                            
                       
                    
                        
                    }
                    VStack{
                        
                   
                            Text("Saved!")
                                .font(Font.custom("Georgia", size: 25))
                                .opacity(saved ? 0.0 : 1.0)
                               // .offset(y: 35)
                             
                    
                        
                        VStack{
                            
                            Text("Front")
                                .font(Font.custom("Georgia", size: 25))
                                .padding(.top, 25)
                            VStack{
                                
                                
                                TextField("", text: $frontUserInput1)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .overlay( RoundedRectangle(cornerRadius: 2)
                                        .stroke(.black, lineWidth: 2))
                                    //.shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Georgia", size: 30))
                                    .padding([.leading, .trailing], 30)
                                    
                                    
                                
                                Spacer()
                            
                            }
                            
                        }.frame(width: geo.size.width * 0.85, height: geo.size.height * 0.30)
                            .background(Color("WashedWhite"))
                            .overlay( RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 3))
                            .cornerRadius(5)
                            .shadow(radius: 2)
                            .padding(.top, 10)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                        
                        
                        VStack{
                            
                            Text("Back")
                                .font(Font.custom("Georgia", size: 25))
                                .padding(.top, 25)
                            
                            
                            VStack{
                                Spacer()
                                
                                TextField("", text: $backUserInput1)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .overlay( RoundedRectangle(cornerRadius: 2)
                                        .stroke(.black, lineWidth: 2))
                                    //.shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Georgia", size: 30))
                                    .padding([.leading, .trailing], 30)
                                
                                
                                Spacer()
                                
                                TextField("", text: $backUserInput2)
                                    .background(Color.white.cornerRadius(10))
                                    .opacity(0.75)
                                    .overlay( RoundedRectangle(cornerRadius: 2)
                                        .stroke(.black, lineWidth: 2))
                                    //.shadow(color: Color.black, radius: 12, x: 0, y:10)
                                    .font(Font.custom("Georgia", size: 30))
                                    .padding([.leading, .trailing], 30)
                                    .padding(.bottom, 25)
                                 
                                
                                Spacer()
                            }
                            
                        }.frame(width: geo.size.width * 0.85, height: geo.size.height * 0.30)
                            .background(Color("WashedWhite"))
                            .overlay( RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 3))
                            .cornerRadius(5)
                            .shadow(radius: 2)
                            .padding(.top, 20)
                            .padding([.leading, .trailing], geo.size.width * 0.075)
                        
                        Spacer()
                        
                        HStack(spacing: 20){
                            saveButton(saved: $saved, fPI1: self.frontUserInput1, fPI2: self.frontUserInput2, bUI1: self.backUserInput1, bUI2: self.backUserInput2, editMyFlashCardListManager: editMyListManager)
                            previewButton(showingSheet: self.$showingSheet)
                        }
                        clearButton(fui1: self.$frontUserInput1, fui2: self.$frontUserInput2, bui1: self.$backUserInput1, bui2: self.$backUserInput2)
                            .offset(y:10)
                          
                        
                            .sheet(isPresented: $showingSheet) {
                                SheetView(flipped: self.$flipped, animate3d: self.$animate3d, fPI1: frontUserInput1, fPI2: frontUserInput2, bUI1: backUserInput1, bUI2: backUserInput2)
                            }
                        
                        Spacer()
                    }.padding(.top, 35)
               
                }.navigationBarBackButtonHidden(true)
                    .onDisappear{
                        editMyListManager.updateObservableList()
                    }
            }else{
                createFlashCardIPAD()
            }
            
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View {
        GeometryReader {geo in
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
            ZStack(alignment: .topLeading){
                
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .tint(Color.black)
                    
                }).padding()
                
                cardViewPreview(flipped: $flipped, animate3d: $animate3d, fPI1: fPI1, fPI2: fPI2, bUI1: bUI1, bUI2: bUI2).frame(width: geo.size.width * 0.9, height: 200)
                    .padding([.leading, .trailing], geo.size.width * 0.05)
                    .padding(.top, 200)
            }
        }
    }
}


struct cardViewPreview: View {
    @State var flip: Bool = false
    @State var showBack = false
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var body: some View{
        ZStack() {
            flashCardItalPreview(frontUserInput1: fPI1).modifier(FlipOpacityCreateCard(percentage: showBack ? 0 : 1))
                .rotation3DEffect(Angle.degrees(showBack ? 180 : 360), axis: (0,1,0))
            flashCardEngPreview(backUserInput1: bUI1, backUserInput2: bUI2).modifier(FlipOpacityCreateCard(percentage: showBack ? 1 : 0))
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

private struct FlipOpacityCreateCard: AnimatableModifier {
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

struct flashCardItalPreview: View {
    
    var frontUserInput1: String
    //var frontUserInput2: String
    
    var body: some View{
        VStack{
            Text(frontUserInput1)
                .font(Font.custom("Georgia", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
//            Text(frontUserInput2)
//                .font(Font.custom("Futura", size: 30))
//                .foregroundColor(Color.black)
//                .padding(.top, 2)
//                .padding([.leading, .trailing], 10)
            
        }.frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 5)
                .stroke(.black, lineWidth: 4))
            .cornerRadius(5)
            .shadow(radius: 3)
        
        
    }
}

struct flashCardEngPreview: View {
    
    var backUserInput1: String
    var backUserInput2: String
    
    var body: some View{
        
        VStack{
            Text(backUserInput1)
                .font(Font.custom("Georgia", size: 40))
                .foregroundColor(Color.black)
                .padding(.bottom, 30)
                .padding([.leading, .trailing], 10)
            
            
            Text(backUserInput2)
                .font(Font.custom("Georgia", size: 30))
                .foregroundColor(Color.black)
                .padding(.top, 2)
                .padding([.leading, .trailing], 10)
            
        }.frame(width: 315, height: 250)
            .background(Color("WashedWhite"))
            .overlay( RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 4))
            .cornerRadius(5)
            .shadow(radius: 3)
    }
    
}

struct saveButton: View{
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var saved: Bool
    var fPI1: String
    var fPI2: String
    var bUI1: String
    var bUI2: String
    
    var editMyFlashCardListManager: EditMyFlashCardListManager
    
    var body: some View{
        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              saved = true
            }
            editMyFlashCardListManager.addItem(f1: fPI1, f2: fPI2, b1: bUI1, b2: bUI2)
            
            saved = false
        }, label: {
            Text("Save to My List")
                .font(Font.custom("Georgia", size: 15))
                .foregroundColor(Color.black)
               //.frame(width: 150, height: 35)
                //.background(Color("terracotta"))
                .cornerRadius(20)
                //.shadow(radius: 10)
                .enabled(saved)
        }).buttonStyle(ThreeDButton(backgroundColor: "white"))                .frame(width: 150, height: 35)
        
        
    }
    

}

struct clearButton: View{
    
    @Binding var fui1: String
    @Binding var fui2: String
    @Binding var bui1: String
    @Binding var bui2: String
    
    var body: some View{
        Button(action: {
            fui1 = ""
            fui2 = ""
            bui1 = ""
            bui2 = ""
            
        }, label: {
            Text("Clear")
                .font(Font.custom("Georgia", size: 15))
                //.foregroundColor(Color.black)
                //.frame(width: 150, height: 35)
                //.background(Color("terracotta"))
                .cornerRadius(20)
                //.shadow(radius: 10)
        }).buttonStyle(ThreeDButton(backgroundColor: "white"))                .frame(width: 150, height: 35)
    }
}

struct previewButton: View{
    
    @Binding var showingSheet: Bool
    
    var body: some View{
        Button(action: {
            withAnimation(Animation.spring()){
                showingSheet.toggle()
            }
        }, label: {
            Text("Preview")
                .font(Font.custom("Georgia", size: 15))
                .foregroundColor(Color.black)
                //.frame(width: 150, height: 35)
               //.background(Color("terracotta"))
                .cornerRadius(20)
                //.shadow(radius: 10)
        }).buttonStyle(ThreeDButton(backgroundColor: "white"))                .frame(width: 150, height: 35)
    }
}



struct FlipEffectPreview: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}

struct createFlashCard_Previews: PreviewProvider {
    
    static var editMyListManager = EditMyFlashCardListManager()
    static var previews: some View {
        createFlashCard(editMyListManager: editMyListManager)
    }
}
