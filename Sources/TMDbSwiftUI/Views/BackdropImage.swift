//
//  BackdropImage.swift
//  TMDbSwiftUI
//
//  Created by Adam Young on 08/04/2020.
//

import SDWebImageSwiftUI
import SwiftUI
import TMDb

public struct BackdropImage: View {

  @ObservedObject private var configurationManager: ConfigurationManager

  let path: URL?

  public init(path: URL? = nil) {
    self.path = path
    self.configurationManager = .shared
  }

  public var body: some View {
    Group {
      if path?.scheme != nil {
        WebImage(url: path)
          .resizable()
      } else if configurationManager.imagesConfiguration != nil {
        WebImage(url: configurationManager.imagesConfiguration?.imageURL(forBackdropPath: self.path))
          .resizable()
      } else {
        EmptyView()
      }
    }
    .transition(.fadeIn)
    .scaledToFill()
    .onAppear(perform: fetchConfiguration)
  }

  private func fetchConfiguration() {
    guard path != nil else {
      return
    }

    configurationManager.fetchIfNeeded()
  }

}

struct BackdropImage_Previews: PreviewProvider {

  static var previews: some View {
    let url =
      URL(string: "https://image.tmdb.org/t/p/w780/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg")
    return Group {
      BackdropImage(path: url)
      BackdropImage(path: url)
      BackdropImage(path: url)
    }
  }

}
