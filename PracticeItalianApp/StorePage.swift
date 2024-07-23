//
//  StorePage.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/16/24.
//

import SwiftUI

enum SubscriptionType {
    case lessonPack1
    case coins
}

struct StorePage: View {
    @EnvironmentObject var inAppPurchaseModel: InAppPurchaseModel  
    
    @State var selectedSubscription: SubscriptionType? = .lessonPack1
    var body: some View {
        GeometryReader{geo in
            VStack{
                Spacer()
                VStack{
                    
                    switch selectedSubscription {
                    case .lessonPack1:
                        FeatureView()
                        
                    case .coins:
                        FeatureViewCoins()
                        
                        
                    default:
                        FeatureView().opacity(0.0)
                    }
                }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.5)
                
                
                Rectangle()
                        .fill(Color("terracotta"))
                        .frame(width: geo.size.width * 0.9, height:6)
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                
                Spacer()
                HStack{
                    subView(title: "Lesson Pack 1", price: "$5.99", details: "Click for details", type: .lessonPack1, selectedSubscription: $selectedSubscription)
                    
                    subView(title: "25 Coin Bundle", price: "$0.99", details: "Click for details", type: .coins, selectedSubscription: $selectedSubscription)
                    
                }
                
                Spacer()
                
                Button(action: {
                    inAppPurchaseModel.makePurchase(product: inAppPurchaseModel.products[0])
                }, label: {
                    Text("Purchase")
                        .font(Font.custom("Georgia", size: 20))
                    
                }).buttonStyle(ThreeDButton(backgroundColor: "white"))
                    .frame(width: 300, height: 50).opacity(selectedSubscription == .lessonPack1  || selectedSubscription == .coins ? 1.0 : 0.0)
            }
            .padding()
        }
    }
    
    struct FeatureView: View {
        var features: [String] = ["4 New Short Stories", "2 New Audio Stories", "Automatically Unlocked"]
        
        var body: some View {
            VStack(spacing: 20){
                Image("lessonPack1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                    .background{
                        RoundedRectangle(cornerRadius: 25)
                            .fill((.white))
                            .frame(width: 180, height: 180)
                            .shadow(radius: 2)
                    }
                    .padding(.bottom, 10)
                ForEach(features, id: \.self) { item in
                    HStack{
                        Image(systemName: "checkmark")
                        Text(item).font(.headline)
                        Spacer()
                    }
                }
            }
        }
    }
    
    struct FeatureViewCoins: View {
        var features: [String] = ["25 Coins Added to your Profile to help unlock activities"]
        
        var body: some View {
            VStack(spacing: 20){
                Image("euro-3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170, height: 170)
                ForEach(features, id: \.self) { item in
                    HStack{
                        Image(systemName: "checkmark")
                        Text(item).font(.headline)
                        Spacer()
                    }
                }
            }
        }
    }
    
    struct CircleView: View{
        @Binding var show: Bool
        var body: some View {
            Group{
                Circle()
                    .frame(width: show ? 500 : 30, height: show ? 500 : 30)
                    .foregroundColor(.white)
                Image(systemName: show ? "checkmark.circle.fill" : "circle.fill").font(.system(size: 30))
                    .foregroundStyle(show ? .blue : .white)
                    //.contentTransition(.symbolEffect)
            }
        }
    }
    
    
    struct subView: View {
        var title: String
        var price: String
        var details: String
        var type: SubscriptionType
        
        @Binding var selectedSubscription: SubscriptionType?
        
        var body: some View {
            ZStack{
                Rectangle()
                    .foregroundStyle(.black.gradient)
                CircleView(show: .constant(selectedSubscription == type))
                    .offset(x: 60, y: -60)
            }.frame(width: 170, height: 170)
                .contentShape(Rectangle())
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedSubscription == type ? .black : .clear, lineWidth: 4)
                })
                .overlay(alignment: .topLeading, content: {
                    VStack(alignment: .leading){
                        Text(title).bold().font(.title2)
                           
                        Spacer()
                        VStack(alignment: .leading, spacing: 1){
                            
                                Spacer()
                                Text(price).font(.largeTitle.bold())
                                Spacer()
                                Text(details)
                                    .multilineTextAlignment(.leading)
                            
                            
                            
                            
                        }
                    }
                    .foregroundStyle(selectedSubscription == type ? .black : .white)
                    .padding()
                })
                .onTapGesture {
                    withAnimation{
                        selectedSubscription = selectedSubscription == type ? nil : type
                    }
                }
                .clipShape(.rect(cornerRadius: 20))
               
        }
    }
    
}

#Preview {
    StorePage().environmentObject(InAppPurchaseModel())
}
