//
//  ContentView.swift
//  final
//
//  Created by Tech on 2026-04-07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Guessing Game")
                NavigationLink("Start Game") {
                    GameScreen()
                }
                NavigationLink("View Records") {
                    Records()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
