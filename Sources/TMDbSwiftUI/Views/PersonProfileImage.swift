//
//  PersonProfileImage.swift
//  TMDbSwiftUI
//
//  Created by Adam Young on 15/04/2020.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI
import TMDb

public struct PersonProfileImage: View {

  @ObservedObject private var configurationManager: ConfigurationManager

  private var initials: String? {
    name?
      .components(separatedBy: " ")
      .reduce("") {
        ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)"
    }
  }

  let path: URL?
  let name: String?
  let size: CGFloat

  public init(path: URL? = nil, name: String?, size: CGFloat = 100) {
    self.path = path
    self.name = name
    self.size = size
    self.configurationManager = .shared
  }

  public var body: some View {
    Group {
      if path?.scheme != nil {
        WebImage(url: path)
          .resizable()
      } else if configurationManager.imagesConfiguration != nil {
        WebImage(url: configurationManager.imagesConfiguration?.imageURL(forPersonProfilePath: self.path, size: self.size))
          .resizable()
          .placeholder { placeholder }
          .transition(.fade)
      } else {
        placeholder
      }
    }
    .scaledToFill()
    .frame(width: size, height: size)
    .clipped()
    .onAppear(perform: fetchConfiguration)
  }

  private var placeholder: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.secondary)

      if initials != nil {
        Text(initials!)
          .lineLimit(1)
          .font(.system(size: size / 2))
          .minimumScaleFactor(0.5)
          .frame(width: size * 0.8)
          .foregroundColor(.init(white: 0.7))
      } else {
        #if os(iOS) || os(watchOS) || os(tvOS)
        Image(systemName: "person")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.init(white: 0.7))
          .padding(size / 5)
          .scaledToFit()
        #endif
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

struct PersonProfileImage_Previews: PreviewProvider {

  static var previews: some View {
    let url =
      URL(string: "https://image.tmdb.org/t/p/w780/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg")
    return Group {
      PersonProfileImage(path: url, name: "Adam Young", size: 100)
      PersonProfileImage(path: url, name: "Adam Young", size: 150)
      PersonProfileImage(path: url, name: "Adam Young", size: 200)
    }
  }

}
