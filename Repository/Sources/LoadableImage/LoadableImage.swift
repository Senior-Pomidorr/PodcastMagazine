//
//  LoadableImage.swift
//
//
//  Created by Илья Шаповалов on 29.09.2023.
//

import SwiftUI

/// A view that asynchronously loads and displays an image.
public struct LoadableImage<I, P>: View where I: View, P: View {
    private let url: URL?
    private let scale: CGFloat
    private let content: (Image) -> I
    private let placeholder: P
    
    //MARK: - Body
    public var body: some View {
        AsyncImage(
            url: url,
            scale: scale,
            content: handle(phase:)
        )
    }
    
    //MARK: - init(_:)
    /// Вью для асинхронной загрузки изображений.
    /// Валидирует полученный URL и всегда загружает контент по защищенному протоколу https.
    /// - Parameters:
    ///   - urlString: URL-строка для загрузки изображения.
    ///   - scale: The scale to use for the image. The default is 1. Set a different value when loading images designed for higher resolution displays.
    ///   - content: A closure that takes the loaded image as an input, and returns the view to show. You can return the image directly, or modify it as needed before returning it.
    ///   - placeholder: A closure that returns the view to show until the load operation completes successfully. ProgressView by default.
    public init(
        _ urlString: String,
        scale: CGFloat = 1,
        content: @escaping (Image) -> I = { $0 },
        placeholder: @escaping () -> P = ProgressView.init
    ) {
        var components = URLComponents(string: urlString)
        if components?.scheme == "http" {
            components?.scheme = "https"
            self.url = components?.url
        } else {
            self.url = URL(string: urlString)
        }
        self.scale = scale
        self.content = content
        self.placeholder = placeholder()
    }
    
    //MARK: - Private methods
    @ViewBuilder
    func handle(phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty: placeholder
        case .success(let image): content(image)
        case .failure(let error): ErrorView(error: error)
        @unknown default: Text("Unknown").background(.red)
        }
    }
    
}

#Preview {
    LoadableImage(
        "http://www.theincomparable.com/imgs/logos/logo-batmanuniversity-3x.jpg?cache-buster=2019-06-11"
    )
}
