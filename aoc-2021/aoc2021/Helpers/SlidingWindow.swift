import Foundation

struct SlidingWindow {
    private let size: Int
    private var items: [Int]

    var full: Bool {
        items.count >= size
    }

    init(size: Int) {
        assert(size > .zero)

        self.size = size
        self.items = []
    }

    mutating func push(_ value: Int) {
        if full {
            items.remove(at: .zero)
        }

        items.append(value)
    }

    func sum() -> Int {
        items.reduce(.zero, +)
    }
}
