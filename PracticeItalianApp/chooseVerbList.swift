//
//  chooseVerbList.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/5/23.
//

import SwiftUI

struct chooseVerbList: View {

    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var showInfoPopUp = false
    
@State private var animatingBear = false
    
    var infoManager = InfoBubbleDataManager(activityName: "chooseVerbList")
    
    let infoText:Text =  (Text("Tackle the difficult task of learning how to conjugate Italian verbs with 3 different challenging exercises. First, choose a list of verbs you want to practice with from the options below, then choose your activity and the tense you would like to practice with on the next page. \n\nYou will also have the option to create your own personal practice list which you can edit and choose on the next page.") )
    var body: some View {
        GeometryReader{ geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
               
                    
//                    HStack(alignment: .top){
//
//                        HStack{
//                            Image("euro-2")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 38, height: 38)
//                            Text(String(globalModel.userCoins))
//                                .font(Font.custom("Arial Hebrew", size: 25))
//                        }.padding(.leading, 45)
//                            .padding(.top, 20)
//                        Spacer()
//                        
//                    }
//                    
//                    
//                    Image("bearHalf")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.12, height: geo.size.width * 0.1)
//                        .padding(.top, animatingBear ? geo.size.height * 0.102 : geo.size.height * 0.154)
//                        .offset(x:geo.size.width * 0.6)
//                        //.offset(y:geo.size.width / 3)
//                        .zIndex(0)
//                    
                    
                
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
                           
                         
             
                                
                            Text("Choose from the following available verb lists to use in the different exercises. You can also choose the verbs you want to practice my editing your custom 'MyList' or even input your own verbs to practice.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .offset(y: 20)
                                    .padding([.leading, .trailing], 20)
                                    
                         
                        }.frame(width: geo.size.width * 0.8, height: 260)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .opacity(showInfoPopUp ? 1.0 : 0.0).zIndex(2)
                            .padding([.leading, .trailing], geo.size.width * 0.1)
                            .padding([.top, .bottom], geo.size.height * 0.3)
                            .zIndex(3)
                        
                        
                    
                    
                    VStack{
                        
                     
                            VStack{
                                ZStack{
                                    HStack{
                                        Text("Verb Conjugation").zIndex(1)
                                            .font(Font.custom("Georgia", size: 28))
                                            .foregroundColor(.white)
                                            .padding(.leading, 35)
                                        
                                        
                                        PopOverViewTopWithImages(textIn: infoText, infoBubbleColor: Color.white, frameHeight: CGFloat(360), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                                    }.frame(width: geo.size.width * 0.9, height: 60)
                                        .background(Color("espressoBrown"))
                                        .cornerRadius(20)
                                        .shadow(radius: 2)
                                        .zIndex(1)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .frame(width: geo.size.width * 0.9, height: 60)
                                        .foregroundColor(Color("darkEspressoBrown"))
                                        .zIndex(0)
                                        .offset(y:7)
                                        .shadow(radius: 2)
                                        .zIndex(0)
                                }.offset(y:-7)
                                ScrollView(showsIndicators: false){
                                HStack{
                                    Spacer()
                                    VStack(spacing: 0){
                                        NavigationLink(destination: chooseVCActivity(), label: {Image("italy")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 55, height: 55)
                                                .padding()
                                                //.background(.white)
                                                .cornerRadius(60)
            //                                    .overlay( RoundedRectangle(cornerRadius: 60)
            //                                        .stroke(.black, lineWidth: 2))
                                                .shadow(radius: 2)
                                        }).id(UUID())
                                        Text("20 Most Used Italian Verbs")
                                            .font(Font.custom("Georgia", size: 15))
                                            .frame(width: 130, height: 80)
                                            .multilineTextAlignment(.center)
                                    }
                                    Spacer()
  
                                }.padding(.top, 25)
                            }.frame(width:  geo.size.width * 0.86, height: geo.size.height * 0.95)
                                    .background(Color("WashedWhite").opacity(0.0)).cornerRadius(10)
                                    .padding([.leading, .trailing], geo.size.width * 0.07)
                        }.padding([.top, .bottom], geo.size.height * 0.14)
                    }
                }.onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        withAnimation(.easeIn(duration: 1.5)){
                            animatingBear = true
                        }
                    }
                }
            }else{
                chooseVerbListIPAD()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct verbSetNavigationButtons: View{
    @EnvironmentObject var globalModel: GlobalModel
    
    @Binding var attemptToBuyPopUp: Bool
    @Binding var attemptedBuyName: String
    
    var chosenVerbSetName: String
    var imageString: String
    
    var body: some View {
        
        VStack{
            VStack{
                NavigationLink(destination: chooseVCActivity(), label: {Image("italy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .padding()
                        .background(.white)
                        .cornerRadius(60)
                }).id(UUID())
                Text("20 Most Used Italian Verbs")
                    .font(Font.custom("Georgia", size: 15))
                    .frame(width: 130, height: 80)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct chooseVerbList_Previews: PreviewProvider {
    static var previews: some View {
        chooseVerbList().environmentObject(GlobalModel())
    }
}
