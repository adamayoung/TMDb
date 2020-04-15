//
//  StillImage.swift
//  TMDbSwiftUI
//
//  Created by Adam Young on 15/04/2020.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI
import TMDb

public struct StillImage: View {

  @ObservedObject private var configurationManager: ConfigurationManager

  let path: URL?
  let size: CGFloat

  public init(path: URL? = nil, size: CGFloat = 100) {
    self.path = path
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
    .frame(width: size, height: (size / 2))
    .cornerRadius(size / 50)
    .clipped()
    .onAppear(perform: fetchConfiguration)
  }

  private var placeholder: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.secondary)
    }
  }

  private func fetchConfiguration() {
    guard path != nil, path?.scheme == nil else {
      return
    }

    configurationManager.fetchIfNeeded()
  }

}

struct StillImage_Previews: PreviewProvider {

  static var previews: some View {
    let url =
      URL(string: "https://image.tmdb.org/t/p/w780/hq9MKfml8tYRM7Y4OJ2wYIng6QM.jpg")
    return Group {
      StillImage(path: url, size: 100)
      StillImage(path: url, size: 150)
      StillImage(path: url, size: 200)
    }
  }

}
