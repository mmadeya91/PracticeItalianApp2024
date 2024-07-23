//
//  chooseVerbListIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/5/24.
//

import SwiftUI

struct chooseVerbListIPAD: View {

    @EnvironmentObject var globalModel: GlobalModel
@State private var animatingBear = false
    @State private var showInfoPopUp = false
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
                    
                    NavigationLink(destination: chooseActivity(), label: {
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
                            .frame(width: 60, height: 50)
                            .shadow(radius: 10)
                            .padding()
                        
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 30))
                        }.padding(.trailing, 50)
                    }
                    
                }
                
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.20)
                    .offset(x: 380, y: animatingBear ? 90 : 300)
                
                VStack(spacing: 0){
               
                    HStack{
                        Spacer()
                        Text("Verb Sets").zIndex(1)
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
              
                    ScrollView{
                        VStack(spacing: 0){
                            HStack{
                                Spacer()
                                VStack{
                                    NavigationLink(destination: chooseVCActivity(), label: {ImageOnCircleVerbListIPAD(icon: "reading-book", radius: 75)
                                    })
                                    Text("20 Most Used Italian Verbs")
                                        .font(Font.custom("Futura", size: 20))
                                        .frame(width: 130, height: 80)
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                                VStack{
                                    NavigationLink(destination: ChooseVCActivityMyList(), label: {ImageOnCircleVerbListIPAD(icon: "reading-book", radius: 75)
                                    })
                                    Text("My List")
                                        .font(Font.custom("Futura", size: 20))
                                        .frame(width: 130, height: 80)
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                            }.padding(.top, 25)
                        }
                    }
                }.frame(width:  geo.size.width * 0.8, height: geo.size.height * 0.78)
                //.shadow(radius: 10)
                    .background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 5))
                    .padding([.leading, .trailing], geo.size.width * 0.1)
                    .padding([.top, .bottom], geo.size.height * 0.15)
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeIn(duration: 1.5)){
                        
                        animatingBear = true
                        
                        
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct verbSetNavigationButtonsIPAD: View{
    @EnvironmentObject var globalModel: GlobalModel
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var chosenVerbSetName: String
    var imageString: String
    
    var body: some View {
        
        VStack{
            VStack{
                NavigationLink(destination: chooseVCActivity(), label: {Image("reading-book")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .padding()
                        .background(.white)
                        .cornerRadius(60)
                        .overlay( RoundedRectangle(cornerRadius: 60)
                            .stroke(.black, lineWidth: 3))
                        .shadow(radius: 10)
                })
                Text("20 Most Used Italian Verbs")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 18))
                    .frame(width: 120, height: 50)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct ImageOnCircleVerbListIPAD: View {
    
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
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}

struct chooseVerbListIPAD_Previews: PreviewProvider {
    static var previews: some View {
        chooseVerbListIPAD().environmentObject(GlobalModel())
    }
}
