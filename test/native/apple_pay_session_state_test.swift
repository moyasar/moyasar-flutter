import Foundation

@main
struct ApplePaySessionStateChecks {
    static func main() {
        let checks = processingMayFinishAfterDismissal()
            && dismissalMayFinishAfterProcessing()
            && cancellationIsReportedOnce()
            && authorizationCannotBeSubmittedTwice()
        precondition(checks)
        print("Apple Pay session ordering checks passed")
    }

    private static func processingMayFinishAfterDismissal() -> Bool {
        var state = ApplePaySessionState()
        precondition(state.submit())
        precondition(state.beginDismissal())
        state.completeDismissal()
        precondition(state.takeOutcome() == nil)
        state.completeProcessing()
        precondition(state.takeOutcome() == .payment)
        precondition(state.takeOutcome() == nil)
        return true
    }

    private static func dismissalMayFinishAfterProcessing() -> Bool {
        var state = ApplePaySessionState()
        precondition(state.submit())
        state.completeProcessing()
        precondition(state.takeOutcome() == nil)
        precondition(state.beginDismissal())
        state.completeDismissal()
        precondition(state.takeOutcome() == .payment)
        return true
    }

    private static func cancellationIsReportedOnce() -> Bool {
        var state = ApplePaySessionState()
        precondition(state.beginDismissal())
        precondition(!state.beginDismissal())
        state.completeDismissal()
        precondition(state.takeOutcome() == .canceled)
        precondition(state.takeOutcome() == nil)
        return true
    }

    private static func authorizationCannotBeSubmittedTwice() -> Bool {
        var state = ApplePaySessionState()
        precondition(state.submit())
        precondition(!state.submit())
        precondition(!state.beginDismissal() || state.submitted)
        return true
    }
}
