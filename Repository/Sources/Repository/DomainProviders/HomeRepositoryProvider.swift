//
//  HomeRepositoryProvider.swift
//
//
//  Created by Илья Шаповалов on 27.09.2023.
//

import Foundation
import APIProvider
import Models
import Combine

public struct HomeRepositoryProvider {
    public var getFeedRequest: (Endpoint) -> Repository.ResponsePublisher<FeedsResponse>
    public var getCategoryRequest: () -> Repository.ResponsePublisher<CategoryResponse>
    public var getFeedDetail: (Int) -> Repository.ResponsePublisher<FeedDetail>
    public var getEpisodes: (Int) -> Repository.ResponsePublisher<EpisodesResponse>
    public var getPersistedFeeds: () -> AnyPublisher<[Feed], Never>
    public var getCurrentUser: () -> Repository.ResponsePublisher<UserAccount>
    public var addToFavorites: (Feed) throws -> Feed
    public var removeFromFavorites: (Feed) throws -> Feed
    
    //MARK: - Live provider
    public static var live: HomeRepositoryProvider {
        let repository = Repository.shared
        return .init(
            getFeedRequest: repository.request,
            getCategoryRequest: { repository.request(.categories) },
            getFeedDetail: { repository.request(.feeds(by: $0)) }, 
            getEpisodes: { repository.request(.episodes(by: $0)) },
            getPersistedFeeds: repository.loadPersisted,
            getCurrentUser: { repository.firebase(.currentUser) },
            addToFavorites: repository.addPersisted,
            removeFromFavorites: repository.deletePersisted
        )
    }
    
    //MARK: - Preview provider
    /// Создает экземпляр провайдера, публикующий передаваемые модели с заданной задержкой по времени.
    /// Подходит для эмуляции работы репозитория, например, во время верстки и работы с канвасом.
    /// - Parameters:
    ///   - feedResult: Желаемый результат запроса подкастов.
    ///   - categoryResult: Желаемый результат запроса категорий.
    ///   - delay: Задержка, в секундах, перед срабатываем паблишера ответа.
    ///   - feedDetailResult: Желаемый результат запросе детализации подкаста.
    ///   - episodesResult: Желаемый результат запроса эпизодов.
    ///   - persistedFeeds: Желаемый результат запроса подскастов в базу данных.
    ///   - favoritesResponse: Желаемый результат запроса на добавление/удаления в базу данных подкаста.
    public static func preview(
        feedResult: Repository.Response<FeedsResponse> = .success(.sample),
        feedDetailResult: Repository.Response<FeedDetail> = .success(.sample),
        categoryResult: Repository.Response<CategoryResponse> = .success(.sample),
        episodesResult: Repository.Response<EpisodesResponse> = .success(.sample),
        userResponse: Repository.Response<UserAccount> = .success(.sample),
        persistedFeeds: [Feed] = [.sample],
        favoritesResponse: @escaping (Feed) throws -> Feed,
        delay: DispatchQueue.SchedulerTimeType.Stride = 2
    ) -> Self {
        .init(
            getFeedRequest: { _ in
                Just(feedResult)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            },
            getCategoryRequest: {
                Just(categoryResult)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }, 
            getFeedDetail: { _ in
                Just(feedDetailResult)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }, 
            getEpisodes: { _ in
                Just(episodesResult)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            },
            getPersistedFeeds: {
                Just(persistedFeeds)
                    .delay(for: delay, scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }, 
            getCurrentUser: Just(userResponse)
                .delay(for: delay, scheduler: DispatchQueue.main)
                .eraseToAnyPublisher,
            addToFavorites: favoritesResponse,
            removeFromFavorites: favoritesResponse
        )
    }
}
