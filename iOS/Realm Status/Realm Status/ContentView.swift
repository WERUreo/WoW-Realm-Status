//
//  ContentView.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/17/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Realms Loaded",
                systemImage: "network",
                description: Text("Realm statuses will appear here.")
            )
            .navigationTitle("Realm Status")
        }
    }
}

#Preview {
    ContentView()
}
