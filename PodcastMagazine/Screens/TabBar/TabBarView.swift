//
//  TabBarView.swift
//  PodcastMagazine
//
//  Created by dsm 5e on 03.10.2023.
//

import SwiftUI

struct TabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    
    var body: some View {
        tabBar
    }
}

extension TabBarView {
    
    private var tabBar: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(8)
        .background(Color.white.edgesIgnoringSafeArea(.bottom))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(tab.iconName)
        }
        .foregroundColor(selection == tab ? Color.accentColor : .gray.opacity(0.5))
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
    }
    
    private func switchToTab(tab: TabBarItem) {
        withAnimation {
            selection = tab
        }
    }
}

#Preview {
    VStack {
        Spacer()
        TabBarView(tabs: TabBarItem.preview, selection: .constant(TabBarItem.preview[0]))
    }
}
