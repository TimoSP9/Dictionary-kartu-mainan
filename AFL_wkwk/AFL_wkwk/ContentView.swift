//
//  ContentView.swift
//  AFL_wkwk
//
//  Created by MacBook Pro on 10/11/23.
//

import SwiftUI

struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let manaCost: String
    let typeLine : String
    let oracleText : String
    let colors : [String]
    let rarity: String
    let set: String
    let imageUrl : String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case manaCost = "mana_cost"
        case typeLine = "type_line "
        case oracleText = "oracle_text"
        case colors
        case rarity
        case set
        case imageUrl="image_uris.normal"
    }
}

struct CardResponse: Codable{
    let data: [Card]
}

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
    
    init(){
        if let url = Bundle.main.url(forResource:"WOT-Scryfall", withExtension: "json"){
            do{
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(CardResponse.self, from: data)
                self.cards = response.data
            } catch{
                print("error decoding JSON: \(error)")
            }
        }
    }
}


struct ContentView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    
    var body: some View{
        NavigationView {
            List (cardViewModel.cards) {card in
                VStack(alignment: .leading){
                    Text("Name: \(card.name)")
                        .font(.headline)
                    Text("Mana Cost: \(card.manaCost)")
                        .font(.subheadline)
                    Text("Type: \(card.typeLine)")
                        .font(.body)
                    Text("Oracle Text: \(card.oracleText)")
                        .font(.body)
                    Text("Colors: \(card.colors.joined(separator:","))")
                        .font(.body)
                    Text("Rarity: \(card.rarity)")
                        .font(.body)
                    Text("Set: \(card.set)")
                        .font(.body)
                    if let imageUrl = card.imageUrl{
                        Text("Image URL: \(imageUrl)")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Scryfall Dictionary")
        }
    }
}

struct MagicCardApp: App{
    var body: some Scene{
        WindowGroup{
            ContentView()
        }
    }
}
