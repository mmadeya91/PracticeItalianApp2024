//
//  ThreeDButtonCircle.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/29/24.
//

import SwiftUI

import SwiftUI

struct ThreeDButtonCircle: ButtonStyle {
    var backgroundColor: String
    func makeBody(configuration: Configuration)-> some View{
        ZStack{
            let offset:CGFloat = 5
            
            Circle()
                .foregroundColor(backgroundColor == "ForestGreen" ? Color("darkForestGreen") : Color("darkTerracotta"))
                .offset(y:5)
                //.offset(y: configuration.isPressed ? offset : 0)
            
            Circle()
                .foregroundColor(Color(backgroundColor))
                .offset(y: configuration.isPressed ? offset : 0)
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
        .compositingGroup()
        .shadow(radius: 1)
    }
}

#Preview {
    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
        Image(systemName: "checkmark")
            .foregroundColor(.white)
            .scaleEffect(1)
            .bold()
    }).frame(height: 60)
        .foregroundColor(.black)
        .buttonStyle(ThreeDButtonCircle(backgroundColor: "ForestGreen"))

}
