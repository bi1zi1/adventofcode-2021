import Foundation

func callWithVariadic(items: [Int], method: (Int ...) -> Int) -> Int {
    if items.count > 9 {
        var toBeProcessed = items
        var result = method(items[0], items[1])
        toBeProcessed.removeFirst(2)
        while toBeProcessed.count > 0 {
            let thisTimeRun = toBeProcessed.count > 8 ? 8 : toBeProcessed.count
            result = callWithVariadic(
                items: [result] + Array(toBeProcessed[0..<thisTimeRun]),
                method: method
            )
            toBeProcessed.removeFirst(thisTimeRun)
        }

        return result
    }

    switch items.count {
    case 0:
        return method()
    case 1:
        return method(items[0])
    case 2:
        return method(items[0], items[1])
    case 3:
        return method(items[0], items[1], items[2])
    case 4:
        return method(items[0], items[1], items[2], items[3])
    case 5:
        return method(items[0], items[1], items[2], items[3], items[4])
    case 6:
        return method(items[0], items[1], items[2], items[3], items[4], items[5])
    case 7:
        return method(items[0], items[1], items[2], items[3], items[4], items[5], items[6])
    case 8:
        return method(items[0], items[1], items[2], items[3], items[4], items[5], items[6], items[7])
    case 9:
        return method(items[0], items[1], items[2], items[3], items[4], items[5], items[6], items[7], items[8])
    default:
        assertionFailure()
        return -1
    }
}
