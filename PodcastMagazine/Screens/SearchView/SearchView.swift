//
//  SearchView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 25.09.23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var store = SearchStore(
        state: SearchScreenDomain.State(),
        reduser: SearchScreenDomain.live.reduce(_:with:)
    )
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SearchView()
}
