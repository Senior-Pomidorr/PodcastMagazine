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
    
    public static var live: HomeRepositoryProvider {
        let repository = Repository.shared
        return .init(
            getFeedRequest: { repository.perform(request: .api($0)) },
            getCategoryRequest: { repository.perform(request: .api(.categories)) }, 
            getFeedDetail: { repository.perform(request: .api(.feeds(by: $0))) }
        )
    }
    
    /// Создает экземпляр провайдера, публикующий передаваемые модели с заданной задержкой по времени.
    /// Подходит для эмуляции работы репозитория, например, во время верстки и работы с канвасом.
    /// - Parameters:
    ///   - feedResult: Желаемый результат запроса подкастов.
    ///   - categoryResult: Желаемый результат запроса категорий.
    ///   - delay: Задержка, в секундах, перед срабатываем паблишера ответа.
    public static func preview(
        feedResult: Repository.Response<FeedsResponse> = .success(.sample),
        feedDetailResult: Repository.Response<FeedDetail> = .success(.sample),
        categoryResult: Repository.Response<CategoryResponse> = .success(.sample),
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
            }
        )
    }
}
