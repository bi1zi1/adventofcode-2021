import Foundation

public final class TrickShot {
    let targetAreaX: ClosedRange<Int>
    let targetAreaY: ClosedRange<Int>

    public init(
        targetAreaX: ClosedRange<Int> = 29...73,
        targetAreaY: ClosedRange<Int> = (-248)...(-194)
    ) {
        self.targetAreaX = targetAreaX
        self.targetAreaY = targetAreaY
    }

    public func shootHighest() -> Int {
        let allowedStepsCountForY = allowedStepsCountForY(in: targetAreaY)
        let maxVelocity = allowedStepsCountForY.map({ $0.velocity }).max() ?? .zero

        return sumArithmeticSequence(for: maxVelocity)
    }

    public func allShotsOnTarget() -> Int {
        let allowedStepsCountForX = allowedStepsCountForX(in: targetAreaX)

        let allowedStepsCountForY = allowedStepsCountForY(in: targetAreaY)
        let allowedNegativeStepsCountForY = allowedNegativeStepsCountForY(in: targetAreaY)

        var count = Int.zero
        for xItem in allowedStepsCountForX {
            for yItem in allowedStepsCountForY + allowedNegativeStepsCountForY {
                let value = xItem.steps.overlaps(yItem.steps) ? 1 : 0
//                print("xItem <> yItem =", value,
//                      "|", xItem.velocity, yItem.velocity,
//                      "|", xItem.steps, yItem.steps
//                )
                count += value
            }
        }

        return count
    }

    func allowedStepsCountForX(in targetAreaX: ClosedRange<Int>) -> [VelocityX] {
        var result = [VelocityX]()

        for velocityX in (0...(targetAreaX.last! + 1)) {
            let sumArithmeticSequence = sumArithmeticSequence(for: velocityX)
            if targetAreaX.contains(sumArithmeticSequence) {
                let minStep = minStepForAritmeticX(for: velocityX, in: targetAreaX)
                result.append(
                    VelocityX(velocity: velocityX, steps: minStep!...(.max))
                )
                continue
            }

            if let steps = allStepsX(for: velocityX, in: targetAreaX) {
                result.append(
                    VelocityX(velocity: velocityX, steps: steps)
                )
            }

        }

        return result
    }

    func minStepForAritmeticX(for velocityX: Int, in targetAreaX: ClosedRange<Int>) -> Int? {
        var stepsTaken = 1
        var velocityXsteps = velocityX
        var resultPathX = 0
        while velocityXsteps > 0, resultPathX < targetAreaX.last! {
            resultPathX += velocityXsteps

            if targetAreaX.contains(resultPathX) {
                return stepsTaken
            }

            velocityXsteps = max(velocityXsteps - 1, 0)
            stepsTaken += 1
        }

        return nil
    }

    func allowedStepsCountForY(in targetAreaY: ClosedRange<Int>) -> [VelocityY] {
        var result = [VelocityY]()

        for velocityY in (0...(abs(targetAreaY.first!) + 1)) {
            if let steps = allStepsY(for: velocityY, in: targetAreaY) {
                result.append(
                    VelocityY(velocity: velocityY, steps: steps)
                )
            }
        }

        return result
    }

    func allowedNegativeStepsCountForY(in targetAreaY: ClosedRange<Int>) -> [VelocityY] {
        var result = [VelocityY]()

        for velocityY in ((targetAreaY.first! - 1)..<0) {
            if let steps = allStepsY(for: velocityY, in: targetAreaY) {
                result.append(
                    VelocityY(velocity: velocityY, steps: steps)
                )
            }
        }

        return result
    }

    func sumArithmeticSequence(for nInts: Int) -> Int {
        (nInts + 1) * nInts / 2
    }

    func allStepsX(for velocityX: Int, in targetAreaX: ClosedRange<Int>) -> ClosedRange<Int>? {
        var minStep: Int?
        var maxStep: Int?

        var stepsTaken = 1
        var velocityXsteps = velocityX
        var resultPathX = 0
        while velocityXsteps > 0, resultPathX < targetAreaX.last! {
            resultPathX += velocityXsteps

            if targetAreaX.contains(resultPathX) {
                minStep = min(minStep ?? .max, stepsTaken)
                maxStep = max(maxStep ?? .min, stepsTaken)
            }

            velocityXsteps = max(velocityXsteps - 1, 0)
            stepsTaken += 1
        }

        guard let minRange = minStep, let maxRange = maxStep else {
            return nil
        }

        return (minRange...maxRange)
    }

    func allStepsY(for velocityY: Int, in targetAreaY: ClosedRange<Int>) -> ClosedRange<Int>? {
        var minStep: Int?
        var maxStep: Int?

        var stepsTaken = 1
        let backToZeroSteps = 2 * velocityY + 1
        var velocityYsteps = -(velocityY + 1)
        var resultPathY = 0
        while resultPathY > targetAreaY.first! {
            resultPathY += velocityYsteps

            if targetAreaY.contains(resultPathY) {
                minStep = min(minStep ?? .max, stepsTaken)
                maxStep = max(maxStep ?? .min, stepsTaken)
            }

            velocityYsteps -= 1
            stepsTaken += 1
        }

        guard let minRange = minStep, let maxRange = maxStep else {
            return nil
        }

        return ((backToZeroSteps + minRange)...(backToZeroSteps + maxRange))
    }

    func allNegativeStepsY(for velocityY: Int, in targetAreaY: ClosedRange<Int>) -> ClosedRange<Int>? {
        var minStep: Int?
        var maxStep: Int?

        var stepsTaken = 1
        var velocityYsteps = velocityY
        var resultPathY = 0
        while resultPathY > targetAreaY.first! {
            resultPathY += velocityYsteps

            if targetAreaY.contains(resultPathY) {
                minStep = min(minStep ?? .max, stepsTaken)
                maxStep = max(maxStep ?? .min, stepsTaken)
            }

            velocityYsteps -= 1
            stepsTaken += 1
        }

        guard let minRange = minStep, let maxRange = maxStep else {
            return nil
        }

        return (minRange...maxRange)
    }
}

struct VelocityX {
    let velocity: Int
    let steps: ClosedRange<Int>
}

struct VelocityY {
    let velocity: Int
    let steps: ClosedRange<Int>
}
