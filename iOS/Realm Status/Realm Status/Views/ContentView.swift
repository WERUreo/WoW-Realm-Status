//
//  ContentView.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/17/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RealmListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading realms...")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView {
                        Label(
                            "Unable to Load Realms",
                            systemImage: "wifi.exclamationmark"
                        )
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Retry") {
                            Task {
                                await viewModel.loadRealms()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(viewModel.filteredRealms) { realm in
                        RealmRow(realm: realm)
                    }
                    .overlay {
                        if viewModel.filteredRealms.isEmpty {
                            ContentUnavailableView.search(
                                text: viewModel.searchText
                            )
                        }
                    }
                    .searchable(
                        text: $viewModel.searchText,
                        prompt: "Search realms"
                    )
                }
            }
            .navigationTitle("Realm Status")
            .task {
                await viewModel.loadRealms()
            }
        }
    }
}

#Preview {
    ContentView()
}
