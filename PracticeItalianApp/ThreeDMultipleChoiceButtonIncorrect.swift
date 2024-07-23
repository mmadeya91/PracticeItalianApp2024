//
//  ThreeDMultipleChoiceButtonIncorrect.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/30/24.
//

import SwiftUI

struct ThreeDMultipleChoiceButtonIncorrect: ButtonStyle {
    var isPressed: Bool
    func makeBody(configuration: Configuration)-> some View{
        ZStack{
            let offset:CGFloat = 5
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isPressed ? Color("darkTerracotta") : Color("LightGrey"))
                .offset(y:5)
                //.offset(y: configuration.isPressed ? offset : 0)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(isPressed ? Color("terracotta") : .white)
                .offset(y: configuration.isPressed ? offset : 0)
            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)
        }
        .compositingGroup()
        .shadow(radius: 1)
    }
}

#Preview {
   
    Button("button"){
       
    }.frame(height: 30)
        .foregroundColor(.black)
        .buttonStyle(ThreeDMultipleChoiceButtonIncorrect(isPressed: false))
}
