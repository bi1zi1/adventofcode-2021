import Foundation
import AOCFramework

print("Hello, World!")

// DAY 1
//let depthIncrease = DepthIncrease()
//let depthIncreaseCount = depthIncrease.depthIncreaseCount()
//print("depthIncreaseCount: \(depthIncreaseCount)")
//let depthIncreaseCountSlidingWindow = depthIncrease.depthIncreaseCount(with: 3)
//print("depthIncreaseCount with sliding window of 3: \(depthIncreaseCountSlidingWindow)")

// DAY 2
//let diveNavigation = DiveNavigation()
//let (position, depth) = diveNavigation.positionAndDepth()
//print("diveNavigation position = \(position), depth = \(depth) [\(position * depth)]")
//let (positionWithAim, depthWithAim) = diveNavigation.positionAndDepthWithAim()
//print("diveNavigation positionWithAim = \(positionWithAim), depthWithAim = \(depthWithAim) [\(positionWithAim * depthWithAim)]")

// DAY 3
//let binaryDiagnostic = BinaryDiagnostic()
//let (gammaRate, epsilonRate) = binaryDiagnostic.gammaRateAndEpsilonRate()
//print("binaryDiagnostic gammaRate = \(gammaRate), epsilonRate = \(epsilonRate) [\(gammaRate * epsilonRate)]")
//let (oxygenGeneratorRating, co2ScrubberRating) = binaryDiagnostic.oxygenGeneratorRatingAndCO2ScrubberRating()
//print("binaryDiagnostic oxygenGeneratorRating = \(oxygenGeneratorRating), co2ScrubberRating = \(co2ScrubberRating) [\(oxygenGeneratorRating * co2ScrubberRating)]")

// DAY 4
let bingoCalculator = BingoCalculator()
let finalScore = bingoCalculator.finalScore()
print("bingoCalculator finalScore = \(finalScore)")
let lastCardFinalScore = bingoCalculator.lastCardFinalScore()
print("bingoCalculator lastCardFinalScore = \(lastCardFinalScore)")
