import Foundation
import AOCFramework

print("Hello, World!")

let depthIncrease = DepthIncrease()
let depthIncreaseCount = depthIncrease.depthIncreaseCount()
print("depthIncreaseCount: \(depthIncreaseCount)")
let depthIncreaseCountSlidingWindow = depthIncrease.depthIncreaseCount(with: 3)
print("depthIncreaseCount with sliding window of 3: \(depthIncreaseCountSlidingWindow)")
