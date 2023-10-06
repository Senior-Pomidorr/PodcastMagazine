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
    public var getFavoritesFeeds: () -> AnyPublisher<[Feed], Never>
    public var getPlaylists: () -> AnyPublisher<[Playlist], Never>
    public var getEpisodes: (Endpoint) -> Repository.ResponsePublisher<EpisodesResponse>
    public var getPersistedEpisodes: () -> AnyPublisher<[Episode], Never>
    public var addToFavorites: (Playlist) throws -> Playlist
    public var removeFromFavorites: (Playlist) throws -> Playlist
    
    public static var live: FavoritesAndPlaylistsRepositoryProvider {
        let repository = Repository.shared
        return .init(
            getFavoritesFeeds: repository.loadPersisted,
            getPlaylists: repository.loadPersisted,
            getEpisodes: repository.request,
            getPersistedEpisodes: repository.loadPersisted,
            addToFavorites: repository.addPersisted,
            removeFromFavorites: repository.deletePersisted
        )
    }
    
    /// Создает экземпляр провайдера, публикующий передаваемые модели с заданной задержкой по времени.
    /// Подходит для эмуляции работы репозитория, например, во время верстки и работы с канвасом.
    /// - Parameters:
    ///   - feedResult: Желаемый результат запроса подкастов.
    ///   - categoryResult: Желаемый результат запроса категорий.
    ///   - delay: Задержка, в секундах, перед срабатываем паблишера ответа.
    public static func preview(
        feedResult: [Feed] = [.sample],
        playlistsResult: [Playlist] = [.sample],
        episodesResult: Repository.Response<EpisodesResponse> = .success(.sample),
        persistedEpisodes: [Episode] = [.sample],
        writeToFavoritesResult: @escaping (Playlist) throws -> Playlist = { $0 },
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
            },
            getPersistedEpisodes: Just(persistedEpisodes)
                .delay(for: delay, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher,
            addToFavorites: writeToFavoritesResult,
            removeFromFavorites: writeToFavoritesResult
        )
    }
}
