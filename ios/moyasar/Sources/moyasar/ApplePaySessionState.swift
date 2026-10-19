/// The sheet can finish before or after the processor responds. Keep the
/// session reserved until both complete, and publish exactly one outcome.
struct ApplePaySessionState {
    enum Outcome: Equatable {
        case canceled
        case payment
    }

    private(set) var submitted = false
    private(set) var processed = false
    private(set) var dismissing = false
    private(set) var dismissed = false
    private var finishing = false

    mutating func submit() -> Bool {
        guard !submitted, !dismissing, !dismissed else { return false }
        submitted = true
        return true
    }

    mutating func completeProcessing() {
        guard submitted else { return }
        processed = true
    }

    mutating func beginDismissal() -> Bool {
        guard !dismissing, !dismissed else { return false }
        dismissing = true
        return true
    }

    mutating func completeDismissal() {
        dismissed = true
    }

    mutating func takeOutcome() -> Outcome? {
        guard dismissed, !finishing, !submitted || processed else { return nil }
        finishing = true
        return submitted ? .payment : .canceled
    }
}
