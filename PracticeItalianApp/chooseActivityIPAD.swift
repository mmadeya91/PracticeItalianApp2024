//
//  chooseActivityIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 12/24/23.
//

import SwiftUI

extension Image {
    
    func imageIconModifierIPAD() -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(10)
            .frame(width: 115, height: 120)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 6))
    }
}


struct chooseActivityIPAD: View {
    @State var animatingBear = false
    @State var showChatBubble = false
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                Image("horizontalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .opacity(1.0)
                
                HStack{
                    Image("coin2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 45)
                    
                    Text(String(globalModel.userCoins))
                        .font(Font.custom("Arial Hebrew", size: 22))
                    
                    Spacer()
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 50)
                        .shadow(radius: 10)
                        .padding()
                    
                }
                
                Image("bubbleChat2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.14, height: geo.size.width * 0.14)
                    .offset(x: geo.size.width - geo.size.width * 0.57, y: geo.size.height * 0.03)
                    .opacity(showChatBubble ? 1.0 : 0.0)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.20)
                    .offset(x: geo.size.width - geo.size.width * 0.5, y: animatingBear ? geo.size.width * 0.125 : 300)
                
                
                
                VStack(spacing: 0){
                    Text("Exercises")
                        .font(Font.custom("Marker Felt", size: geo.size.width * 0.08))
                        .foregroundColor(.white)
                        .frame(width: geo.size.width, height: geo.size.width * 0.14)
                        .background(Color("DarkNavy")).opacity(0.75)
                        .cornerRadius(13)
                        .border(width: 8, edges: [.bottom], color: .teal)
                    
                    VStack(spacing: 0){
                        HStack{
                            Spacer()
                            VStack{
                                NavigationLink(destination: availableShortStories(), label: {Image("reading-book")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.22)
                                        .background(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.black, lineWidth: 6))
                                })
                                Text("Reading")
                                    .bold()
                                    .font(Font.custom("Marker Felt", size: geo.size.width * 0.04))
                                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.1)
                                
                            }
                            Spacer()
                            VStack{
                                
                                
                                NavigationLink(destination: chooseAudio(), label: {
                                    Image("talking")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.22)
                                        .background(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.black, lineWidth: 6))
                                })
                                Text("Listening")
                                    .bold()
                                    .font(Font.custom("Marker Felt", size: geo.size.width * 0.04))
                                    .frame(width: geo.size.width * 0.25, height: geo.size.width * 0.1)
                            }
                            Spacer()
                        }
                        
                        
                        
                        HStack(spacing: 0){
                            Spacer()
                            VStack{
                                NavigationLink(destination: chooseFlashCardSet(), label: {
                                    Image("flash-card")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.22)
                                        .background(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.black, lineWidth: 6))
                                        .padding(.top, 55)
                                })
                                Text("Flash \nCards")
                                    .bold()
                                    .font(Font.custom("Marker Felt", size: geo.size.width * 0.04))
                                    .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.15)
                                
                            }
                            
                            Spacer()
                            VStack{
                                NavigationLink(destination: chooseVerbList(), label:{
                                    Image("spell-check")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(15)
                                        .frame(width: geo.size.width * 0.22, height: geo.size.width * 0.22)
                                        .background(.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.black, lineWidth: 6))
                                        .padding(.top, 55)
                                })
                                Text("Verb Conjugation")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .font(Font.custom("Marker Felt", size: geo.size.width * 0.04))
                                    .frame(width: geo.size.width * 0.27, height: geo.size.width * 0.15)
                                
                            }
                            Spacer()
                        }
                    }.padding(.top, geo.size.height * 0.05)
                    
                    
                    Spacer()
                }.frame(width:  geo.size.width * 0.8, height: geo.size.height * 0.78)
                //.shadow(radius: 10)
                    .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 5))
                    .padding([.leading, .trailing], geo.size.width * 0.1)
                    .padding([.top, .bottom], geo.size.height * 0.15)
                //.offset(y: (geo.size.height / 2) - (geo.size.height / 2.8))
                
                
                
                
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeIn(duration: 1.5)){
                        
                        animatingBear = true
                        
                        
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeIn(duration: 0.5)){
                        
                        showChatBubble = true
                        
                        
                    }
                  
                }
                
                flashCardSetAccObj.checkSetData()
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct chooseActivityIPAD_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivityIPAD().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
        
        
    }
}
