//
//  GameWords.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-24.
//

import Foundation


struct GameWords {
    
    //    var user: String
    
    // 5 sekunder
    func easyModeWords() -> [(swedish: String, english: String)] {
        
        let easyWords: [(swedish: String, english: String)] = [
            ("Apelsin", "Orange"),
            ("Banan", "Banana"),
            ("Vindruvor", "Grapes"),
            ("Äpple", "Apple"),
            ("Kokosnöt", "Coconut"),
            ("Kiwi", "Kiwi"),
            ("Ananas", "Pineapple")
        ]
        return easyWords
    }
    
    // 7 sekunder
    func mediumModeWords() -> [(swedish: String, english: String)] {
        let mediumWords: [(swedish: String, english: String)] = [
            
            ("fågelskrämma", "scarecrow"),
            ("räknesnurra", "calculator"),
            ("jordgubbe", "strawberry"),
            ("ficklampa", "flashlight"),
            ("äventyr", "adventure"),
            ("målarpensel", "paintbrush"),
            ("handduk", "towel"),
            ("köttbulle", "meatball"),
            ("växthuseffekt", "greenhouse effect"),
            ("spindelnät", "spider web"),
            ("matsäck", "packed lunch"),
            ("fjärrkontroll", "remote control"),
            ("långkalsonger", "long johns"),
            ("snöflinga", "snowflake"),
            ("skogspromenad", "forest walk"),
            ("leksaksaffär", "toy store"),
            ("fågelfjäder", "bird feather"),
            ("ryggsäck", "backpack"),
            ("telefonnummer", "phone number"),
            ("bänkpress", "bench press")
        ]
        
        return mediumWords
    }
    
    // 10 sekunder
    func hardModeWords() -> [(swedish: String, english: String)] {
        
        let hardWords: [(swedish: String, english: String)] = [
            ("samhällsbyggnad", "urban planning"),
            ("världsarv", "world heritage"),
            ("ansvarsfullhet", "responsibility"),
            ("flygplansmotor", "aircraft engine"),
            ("självförverkligande", "self-actualization"),
            ("trådlös kommunikation", "wireless communication"),
            ("klimatförändringar", "climate change"),
            ("vägtrafikinspektör", "traffic inspector"),
            ("bostadsrättsförening", "housing cooperative"),
            ("mellanösternpolitik", "middle eastern politics"),
            ("livsmedelshantering", "food handling"),
            ("miljötillstånd", "environmental permit"),
            ("elektronikkonstruktion", "electronics design"),
            ("höghastighetståg", "high-speed train"),
            ("försvarsminister", "defense minister"),
            ("kriminalteknik", "forensic science"),
            ("samarbetsorganisation", "cooperation organization"),
            ("internationella relationer", "international relations"),
            ("högskolebehörighet", "university eligibility"),
            ("organisationspsykologi", "organizational psychology")
        ]
        
        return hardWords
    }
    
    //16 sekunder ⚠️
    func extremelyHardModeWords() -> [(swedish: String, english: String)] {
        let extremeWords = [
            
            ("verksamhetsutveckling", "business development"),
            ("självständighetsförklaring", "declaration of independence"),
            ("industrirobotautomation", "industrial robot automation"),
            ("besiktningsförrättare", "certified inspector"),
            ("mikrovågsteknologi", "microwave technology"),
            ("internationellt samfund", "international community"),
            ("rekonstruktionsplanering", "restructuring planning"),
            ("förundersökningsledare", "preliminary investigation leader"),
            ("signalbehandlingsalgoritm", "signal processing algorithm"),
            ("flerskiktsarkitektur", "multi-layered architecture"),
            ("övergångsregering", "transitional government"),
            ("industriforskningsinstitut", "industrial research institute"),
            ("blodproppsförebyggande", "thrombosis prevention"),
            ("energimyndighetsrapport", "energy agency report"),
            ("havsövervakningssystem", "marine monitoring system"),
            ("tvärvetenskaplig forskning", "interdisciplinary research"),
            ("folkhälsomyndigheten", "public health agency"),
            ("obligatorisk vaccinationsplan", "mandatory vaccination plan"),
            ("avfallshanteringsstrategi", "waste management strategy"),
            ("integritetslagstiftning", "data protection legislation")
            
        ]
        
        return extremeWords
    }
    
}
