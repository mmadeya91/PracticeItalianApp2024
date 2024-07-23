//
//  flashCardData.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/15/23.
//

import Foundation

class flashCardData{
    
    var chosenFlashSetIndex: Int
    
    init(chosenFlashSetIndex: Int) {
        self.chosenFlashSetIndex = chosenFlashSetIndex
    }
    
    func collectChosenFlashSetData(index: Int) -> flashCardObject {
    
        
        switch index {
        case 0:
            return flashCardObject.Food

        case 1:
            return flashCardObject.Animals

        case 2:
            return flashCardObject.Clothing
        
        case 3:
            return flashCardObject.Family
            
        case 4:
            return flashCardObject.CommonNouns
            
        case 5:
            return flashCardObject.CommonAdjectives
            
        case 6:
            return flashCardObject.CommonAdverbs
            
        case 7:
            return flashCardObject.CommonVerbs
            
        case 8:
            return flashCardObject.CommonPhrases

        default:
            return flashCardObject.CommonNouns
        }
        
        
        
        
        
    }
    
    func getSetName(index: Int) -> String {
    
        
        switch index {
        case 0:
            return "Food"

        case 1:
            return "Animals"

        case 2:
            return "Clothing"
        
        case 3:
            return "Family"
            
        case 4:
            return "Common Nouns"
            
        case 5:
            return "Common Adjectives"
            
        case 6:
            return "Common Adverbs"
            
        case 7:
            return "Common Verbs"
            
        case 8:
            return "Common Phrases"

        default:
            return "Common Nouns"
        }
        
        
        
        
        
    }
    
    
}
