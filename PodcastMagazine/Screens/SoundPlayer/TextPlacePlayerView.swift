//
//  SoundPlayerView.swift
//  PodcastMagazine
//
//  Created by Павел Грицков on 03.10.23.
//

import AVKit
import Models
import SwiftUI

struct TextPlacePlayerView: View {
    let episode = Episode.sample
    let audioManager = AudioManager()
    
    @State private var value: Double = 0.0
    @State private var isEditing = false
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1)
            VStack(spacing: 30) {
                VStack {
                    Button("add") {
                        audioManager.addTrackBy(url: episode.enclosureUrl)
                    }
                    Button("preper") {
                        audioManager.preperPlayer()
                    }
                }
                
                VStack {
                    Button("Play") {
                        audioManager.play()
                    }
                    
                    Button("pause") {
                        audioManager.pause()
                    }
                }
                
                HStack {
                    Button("Next") {
                        audioManager.next()
                    }
                    
                    Text("|")
                    
                    Button("back") {
                        audioManager.back()
                    }
                }
                VStack {
                    HStack {
                        Text(DateComponentsFormatter.positional.string(from: audioManager.currentTime) ?? "0:00")
                        Spacer()
                        Text(DateComponentsFormatter.positional.string(from: audioManager.duration - audioManager.currentTime) ?? "0:00")
                    }
                    
                    Slider(
                        value: $value,
                        in: 0...audioManager.duration) {editing in
                            print("\(editing)")
                            isEditing = editing
                            if !editing {
                                // тут как-то делаем промотку трека
                                audioManager.seek(value)
                            }
                        }
                }
                .padding()
                
                VStack {
                    Button("Print data player") {
                        audioManager.checkPlayer()
                    }
                    
                    Button("playList count") {
                        audioManager.pListCount()
                    }
                }
            }
            .font(.title3.bold())
            .onAppear {
                audioManager.addTrackBy(url: episode.enclosureUrl)
                // preperPlayer не любит вызываться 2 раза, крашется
                audioManager.preperPlayer()
            }
            // подписываемся на уведомления
            .onReceive(timer) { _ in
                guard let player = audioManager.playerQueue, !isEditing else { return }
                value = player.currentTime().seconds
            }
        }
    }
}

#Preview {
    TextPlacePlayerView()
}

extension DateComponentsFormatter {
    static let abbreviated: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        
        return formatter
    }()
    
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter
    }()
}
