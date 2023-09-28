//
//  FavoritesRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import Models
import Combine
import APIProvider

public struct FavoritesAndPlaylistsRepositoryProvider {
    public var getFavoritesFeeds: () -> Repository.ResponsePublisher<[Feed]>
    public var getPlaylists: () -> Repository.ResponsePublisher<[Playlist]>
    public var getEpisodes: (Endpoint) -> Repository.ResponsePublisher<EpisodesResponse>
    
    public static var live: FavoritesAndPlaylistsRepositoryProvider {
        let repository = Repository.shared
        return .init(
            getFavoritesFeeds: Empty().eraseToAnyPublisher,
            getPlaylists: Empty().eraseToAnyPublisher,
            getEpisodes: { repository.perform(request: .api($0)) })
    }
    
    /// Создает экземпляр провайдера, публикующий передаваемые модели с заданной задержкой по времени.
    /// Подходит для эмуляции работы репозитория, например, во время верстки и работы с канвасом.
    /// - Parameters:
    ///   - feedResult: Желаемый результат запроса подкастов.
    ///   - categoryResult: Желаемый результат запроса категорий.
    ///   - delay: Задержка, в секундах, перед срабатываем паблишера ответа.
    public static func preview(
        feedResult: Repository.Response<[Feed]> = .success([.sample]),
        playlistsResult: Repository.Response<[Playlist]> = .success([.sample]),
        episodesResult: Repository.Response<EpisodesResponse> = .success(.sample),
        delay: DispatchQueue.SchedulerTimeType.Stride = 2
    ) -> Self {
        .init(
            getFavoritesFeeds: Just(feedResult)
                .delay(for: delay, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher,
            getPlaylists: Just(playlistsResult)
                .delay(for: delay, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher,
            getEpisodes: { _ in
                Just(episodesResult)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
        )
    }
}
