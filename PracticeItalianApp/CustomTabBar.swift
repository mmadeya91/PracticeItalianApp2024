//
//  CustomTabBar.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/9/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Reading
    case Audio
    case Home
    case Cards
    case Verbs
}




struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }


    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases, id: \.rawValue) {tab in
                    Spacer()
                    VStack{
                        Image(selectedTab == tab ? fillImage : tab.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width:20, height: 20)
                            .scaleEffect(selectedTab == tab ? 1.35 : 1.0)

                                .onTapGesture {
                                    //withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                //}
                            }
                        
                        Text(tab.rawValue)
                            .font(Font.system(size: 11))
                            .padding(.top, 2)
                    }.padding(.top, 5)
                       
                    Spacer()
                }
              
            }.frame(width: UIScreen.main.bounds.width - 25, height: 60)
                .background(Color("themeGray").opacity(0.8)).cornerRadius(8)
            
           
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.Home))
}
