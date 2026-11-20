//
//  RealmRow.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/19/26.
//

import SwiftUI

struct RealmRow: View {
    let realm: Realm
    
    var body: some View {
        HStack {
            Text(realm.name)
            
            Spacer()
            
            Image(
                systemName: realm.status == .online
                ? "circle.fill"
                : "circle"
            )
            .foregroundStyle(
                realm.status == .online
                ? .green
                : .red
            )
        }
    }
}

#Preview {
    RealmRow(
        realm: Realm(
            id: 5,
            name: "Proudmoore",
            slug: "proudmoore",
            status: .online,
            population: "Full"
        )
    )
    .padding()
}
