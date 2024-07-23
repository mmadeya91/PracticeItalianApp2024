//
//  ListeningActivtyViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import Foundation

final class ListeningActivityViewModel: ObservableObject {
    private(set) var audioAct: audioActivty
    
    init(audioAct: audioActivty) {
        self.audioAct = audioAct
    }
    func setAudioData(chosenAudio: String){
        switch chosenAudio {
        case "Pasta alla Carbonara":
            audioAct = audioActivty.pastaCarbonara
          
        case "Cosa Desidera?":
            audioAct = audioActivty.cosaDesidera
      
        case "Indicazioni per gli Uffizi":
            audioAct = audioActivty.uffizi
  
        case "Stili di Bellagio":
            audioAct = audioActivty.bellagio
   
        case "Il Rinascimento":
            audioAct = audioActivty.rinascimento
        
        case "Il Colloquio di Lavoro":
            audioAct = audioActivty.colloquio
            
        case "Il Festival di Sanremo":
            audioAct = audioActivty.sanremo
            
        case "Alla Ricerca di un Appartamento":
            audioAct = audioActivty.appartamento
  
        default:
            audioAct = audioActivty.pastaCarbonara
           
        }
    }
    
}

struct audioActivty {
    let id = UUID()
    let title: String
    let description: String
    let duration: TimeInterval
    let track: String
    let image: String
    let ipadImage:String
    let isConversation: Bool
    let numberofDialogueQuestions: Int
    let speaker1Image: String
    let speaker2Image: String
    let audioTranscriptItalian: String
    let audioTranscriptEnglish: String
    let keywords: [Keyword]
    let comprehensionQuestions: [ComprehensionQuestion]
    let comprehensionQuestionChoices: [[String]]
    let fillInDialogueQuestionElement: [FillInDialogueQuestion]
    let putInOrderSentenceArray: [PutInOrderDialogueBox]
    let audioCutFileNames: [String]

    static let pastaCarbonara = audioActivty(title: "Pasta alla Carbonara", description: "The Italian chef is reciting instructions on how how make one of Italy's most famous pasta dishes! Do you're best to follow along and maybe even give it a try yourself at home!", duration: 70, track: "pastaCarbonara", image: "pot", ipadImage: "pot", isConversation: ListeningActivityElement.pastaCarbonara.isConversation, numberofDialogueQuestions: ListeningActivityElement.pastaCarbonara.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.pastaCarbonara.speaker1Image, speaker2Image: ListeningActivityElement.pastaCarbonara.speaker2Image, audioTranscriptItalian: ListeningActivityElement.pastaCarbonara.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.pastaCarbonara.audioTranscriptEnglish, keywords: ListeningActivityElement.pastaCarbonara.keywords,  comprehensionQuestions: ListeningActivityElement.pastaCarbonara.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.pastaCarbonara.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.pastaCarbonara.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.pastaCarbonara.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.pastaCarbonara.audioCutArrays)
    
    static let cosaDesidera = audioActivty(title: "Cosa Desidera?", description: "A stranger is trying to find a table at a local restaurant. Do your best to follow the interaction between herself and the waiter. This is a good introduction to ordering food in an Italian restaurant and find out whats on the menu!", duration: 52, track: "cosaDesidera", image: "dinner", ipadImage: "cosaDesideraIPAD", isConversation: ListeningActivityElement.cosaDesidera.isConversation, numberofDialogueQuestions: ListeningActivityElement.cosaDesidera.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.cosaDesidera.speaker1Image, speaker2Image: ListeningActivityElement.cosaDesidera.speaker2Image, audioTranscriptItalian: ListeningActivityElement.cosaDesidera.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.cosaDesidera.audioTranscriptEnglish, keywords: ListeningActivityElement.cosaDesidera.keywords,  comprehensionQuestions: ListeningActivityElement.cosaDesidera.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.cosaDesidera.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.cosaDesidera.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.cosaDesidera.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.cosaDesidera.audioCutArrays)
    
    static let uffizi = audioActivty(title: "Indicazioni per gli Uffizi", description: "Mateo is lost on his way to the Galleria degli Uffizi. Luckily, he finds a stranger who is willing to help him and give him directions. Follow along and try to see what path Mateo must take in order to reach his destination", duration: 59, track: "uffizi", image: "directions", ipadImage: "uffiziIPAD", isConversation: ListeningActivityElement.uffizi.isConversation, numberofDialogueQuestions: ListeningActivityElement.uffizi.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.uffizi.speaker1Image, speaker2Image: ListeningActivityElement.uffizi.speaker2Image, audioTranscriptItalian: ListeningActivityElement.uffizi.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.uffizi.audioTranscriptEnglish, keywords: ListeningActivityElement.uffizi.keywords, comprehensionQuestions: ListeningActivityElement.uffizi.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.uffizi.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.uffizi.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.uffizi.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.uffizi.audioCutArrays)
    
    static let bellagio = audioActivty(title: "Stili di Bellagio", description: "Theres a new clothing store opening up in Bellagio! A beautiful town on Lake Como in northern Italy. Listen along and see what types of clothes the store is selling and other things that may be useful to know about the new shop.", duration: 59, track: "stileBellagio", image: "clothesStore", ipadImage: "bellagioIPAD", isConversation: ListeningActivityElement.bellagio.isConversation, numberofDialogueQuestions: ListeningActivityElement.bellagio.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.bellagio.speaker1Image, speaker2Image: ListeningActivityElement.bellagio.speaker2Image, audioTranscriptItalian: ListeningActivityElement.bellagio.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.bellagio.audioTranscriptEnglish, keywords: ListeningActivityElement.bellagio.keywords, comprehensionQuestions: ListeningActivityElement.bellagio.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.bellagio.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.bellagio.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.bellagio.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.bellagio.audioCutArrays)
    
    static let rinascimento = audioActivty(title: "Il Rinascimento", description: "The Renaissance, one of the most important movements in the world and Italian history. Listen along to this brief description of how this famous movement came to be and some of the incredible accomplishments that resulted from it.", duration: 82, track: "rinascimento", image: "renaissance", ipadImage: "renaissanceIPAD", isConversation: ListeningActivityElement.rinascimento.isConversation, numberofDialogueQuestions: ListeningActivityElement.rinascimento.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.rinascimento.speaker1Image, speaker2Image: ListeningActivityElement.rinascimento.speaker2Image, audioTranscriptItalian: ListeningActivityElement.rinascimento.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.rinascimento.audioTranscriptEnglish, keywords: ListeningActivityElement.rinascimento.keywords,  comprehensionQuestions: ListeningActivityElement.rinascimento.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.rinascimento.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.rinascimento.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.rinascimento.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.rinascimento.audioCutArrays)
    
    static let colloquio = audioActivty(title: "Il Colloquio di Lavoro", description: "Gianna is interviewing for a position as an English teacher in Italy. The manager has some good questions for her and she is doing her best to show that she is the right candidate for the job. Listen along and see if you think Gianna will be successful in her job hunt.", duration: 126, track: "colloquioMain", image: "interview", ipadImage: "renaissanceIPAD", isConversation: ListeningActivityElement.colloquio.isConversation, numberofDialogueQuestions: ListeningActivityElement.colloquio.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.colloquio.speaker1Image, speaker2Image: ListeningActivityElement.colloquio.speaker2Image, audioTranscriptItalian: ListeningActivityElement.colloquio.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.colloquio.audioTranscriptEnglish, keywords: ListeningActivityElement.colloquio.keywords,  comprehensionQuestions: ListeningActivityElement.colloquio.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.colloquio.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.colloquio.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.colloquio.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.colloquio.audioCutArrays)
    
    static let appartamento = audioActivty(title: "Alla Ricerca di un Appartamento", description: "Isabella is looking for her first apartment. She reads about one in the newspaper she is interested in being rented by a women named Chiara. She gives her a call to find out more about the apartment and if it is a good fit. Listen along and learn what you can about the appartment for rent.", duration: 158, track: "appartamentoMainWithRing", image: "rent", ipadImage: "renaissanceIPAD", isConversation: ListeningActivityElement.appartamento.isConversation, numberofDialogueQuestions: ListeningActivityElement.appartamento.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.appartamento.speaker1Image, speaker2Image: ListeningActivityElement.appartamento.speaker2Image, audioTranscriptItalian: ListeningActivityElement.appartamento.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.appartamento.audioTranscriptEnglish, keywords: ListeningActivityElement.appartamento.keywords,  comprehensionQuestions: ListeningActivityElement.appartamento.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.appartamento.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.appartamento.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.appartamento.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.appartamento.audioCutArrays)
    
    static let sanremo = audioActivty(title: "Alla Ricerca di un Appartamento", description: "You are listening to the radio and hear an advertisement come on for this years Festival di Sanremo. There are a few changes to the rules and you are interested in the celebrities hosting this year. Listen and along and see if you can get a good understaning of what will be happening in the competition.", duration: 90, track: "sanremoMain", image: "festival", ipadImage: "renaissanceIPAD", isConversation: ListeningActivityElement.sanremo.isConversation, numberofDialogueQuestions: ListeningActivityElement.sanremo.numberOfDialogueQuestions, speaker1Image: ListeningActivityElement.sanremo.speaker1Image, speaker2Image: ListeningActivityElement.sanremo.speaker2Image, audioTranscriptItalian: ListeningActivityElement.sanremo.audioTranscriptItalian, audioTranscriptEnglish: ListeningActivityElement.sanremo.audioTranscriptEnglish, keywords: ListeningActivityElement.sanremo.keywords,  comprehensionQuestions: ListeningActivityElement.sanremo.comprehensionQuestions, comprehensionQuestionChoices: setComprehensionQuestions(arrayIn: ListeningActivityElement.sanremo.comprehensionQuestions), fillInDialogueQuestionElement: ListeningActivityElement.sanremo.fillInDialogueQuestion, putInOrderSentenceArray: ListeningActivityElement.sanremo.putInOrderDialogueBoxes, audioCutFileNames: ListeningActivityElement.sanremo.audioCutArrays)

    
}

func setComprehensionQuestions(arrayIn: [ComprehensionQuestion]) -> [[String]]{
    var tempStringArray = [[String]]()
    for question in arrayIn{
        tempStringArray.append(question.choices.shuffled())
    }
    
    return tempStringArray
}

