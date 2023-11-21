//
//  Sequence+Uniqued.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension Sequence where Element: Hashable, Element: Identifiable {

    func uniqued() -> [Element] {
        var seen = Set<Element.ID>()
        return filter { seen.insert($0.id).inserted }
    }

}
