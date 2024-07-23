//
//  RightWrongButtons.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/1/23.
//

import SwiftUI




struct spellConjVerbButton: View {
    
    var userAnswer: String
    var correctAnswer: String
    
    @State var selected = false
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    
    var body: some View {
        Button(action: {
            if userAnswer.elementsEqual(correctAnswer) {
                questionNumber += 1
                SoundManager.instance.playSound(sound: .correct)
                
            }else {
                selected.toggle()
                SoundManager.instance.playSound(sound: .wrong)
            }
        }, label: {
            Text("Check")
            
        }).font(Font.custom("Marker Felt", size:  18))
            .frame(width:180, height: 40)
            .background(Color.teal)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .offset(x: selected ? -5 : 0)
            .shadow(radius: 10)
            .padding(.trailing, 5)
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.pressed = pressing
                }
            }, perform: { })
    }
}

struct RightWrongButtons_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("test")
        }
    }
}
