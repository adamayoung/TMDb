//
//  PosterImage.swift
//  TMDbSwiftUI
//
//  Created by Adam Young on 08/04/2020.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI
import TMDb

public struct PosterImage: View {

  @ObservedObject private var configurationManager: ConfigurationManager

  let path: URL?
  let title: String?
  let size: CGFloat

  public init(path: URL? = nil, title: String? = nil, size: CGFloat = 100) {
    self.path = path
    self.title = title
    self.size = size
    self.configurationManager = .shared
  }

  public var body: some View {
    Group {
      if path?.scheme != nil {
        WebImage(url: path)
          .resizable()
      } else if configurationManager.imagesConfiguration != nil {
        WebImage(url: configurationManager.imagesConfiguration?.imageURL(forPosterPath: self.path, size: self.size))
          .resizable()
          .placeholder { placeholder }
      } else {
        placeholder
      }
    }
    .scaledToFill()
    .frame(width: size, height: (size * 1.5))
    .cornerRadius(size / 50)
    .clipped()
    .onAppear(perform: fetchConfiguration)
  }

  private var placeholder: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.secondary)

      if title != nil {
        Text(title ?? "")
          .frame(width: size * 0.8)
          .multilineTextAlignment(.center)
          .foregroundColor(.secondary)
      }
    }
  }

  private func fetchConfiguration() {
    guard path != nil, path?.scheme == nil else {
      return
    }

    configurationManager.fetchIfNeeded()
  }

}

struct PosterView_Previews: PreviewProvider {

  static var previews: some View {
    let url =
      URL(string: "https://image.tmdb.org/t/p/w780/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg")
    return Group {
      PosterImage(path: url, title: "Some title 1", size: 100)
      PosterImage(path: url, title: "Some title 2", size: 150)
      PosterImage(path: url, title: "Some title 3", size: 200)
    }
  }

}
