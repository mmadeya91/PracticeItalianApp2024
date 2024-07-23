//
//  ActivityHeader.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 6/12/24.
//

import SwiftUI

struct ActivityHeader: View {
    @EnvironmentObject var globalModel: GlobalModel
    @State var animatingBear = false
    @State var showInfoPopup = false
    var body: some View {
        GeometryReader{geo in
            ZStack(alignment: .topLeading){
                
                
                HStack(alignment: .top){
                    
                    HStack{
                        Image("euro-2")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 38, height: 38)
                        Text(String(globalModel.userCoins))
                            .font(Font.custom("Arial Hebrew", size: 25))
                    }.padding(.leading, 45)
                        .padding(.top, 20)
                    Spacer()
                    
                }
                
                
                Image("bearHalf")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.height * 0.12, height: geo.size.width * 0.1)
                    .padding(.top, animatingBear ? geo.size.height * 0.09 : geo.size.height * 0.145)
                    .offset(x:geo.size.width * 0.6)
                //.offset(y:geo.size.width / 3)
                    .zIndex(0)
                
                VStack{
                    ZStack{
                        HStack{
                         
                          
                        } .frame(width: geo.size.width * 0.9, height: 60)
                            .background(Color("espressoBrown"))
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            .zIndex(1)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: geo.size.width * 0.9, height: 60)
                            .foregroundColor(Color("darkEspressoBrown"))
                            .zIndex(0)
                            .offset(y:7)
                            .shadow(radius: 3)
                            .zIndex(0)
                    }.offset(y: -7)
                }.padding([.top, .bottom], geo.size.height * 0.14)
                    .padding([.leading, .trailing], geo.size.width * 0.05)
                
                ZStack(alignment: .topLeading){
                    HStack{
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.25)){
                                showInfoPopup.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        })
                    }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                    
                    VStack{
                        
                        
                        Text("Do your best to read and understand the following short stories on various topics. \n \nWhile you read, pay attention to key vocabulary words as you will be quizzed after on your comprehension!")
                            .font(.system(size:18))
                            .multilineTextAlignment(.center)
                            .padding()
                    }.padding(.top, 50)
                }.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.7)
                    .background(Color("WashedWhite"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 3)
                    )
                    .offset(x: (geo.size.width / 2) - geo.size.width * 0.4, y: (geo.size.height / 2) - geo.size.width * 0.35)
                    .opacity(showInfoPopup ? 1.0 : 0.0)
                    .zIndex(2)
                
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeIn(duration: 1.5)){
                        
                        animatingBear = true
                        
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityHeader().environmentObject(GlobalModel())
}
