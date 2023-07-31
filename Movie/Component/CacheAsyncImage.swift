//
//  CacheAsyncImage.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
        
    init(url: URL, scale: CGFloat = 1.0, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
//            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
//            let _ = print("request \(url.absoluteString)")
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        return content(phase)
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CacheAsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")!) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
            case .failure(let error):
                fatalError(error.localizedDescription)
            @unknown default:
                fatalError()
            }
        }
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    static private let size = 250
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            let keys = cache.keys
            if keys.count > size {
                ImageCache.cache.remove(at: keys.startIndex)
            }
            ImageCache.cache[url] = newValue
        }
    }
}
