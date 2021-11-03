import Foundation

extension Sequence where Element: Hashable {

    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }

}
