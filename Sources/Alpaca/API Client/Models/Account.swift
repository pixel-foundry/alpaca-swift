import Foundation

/// The Alpaca account API serves important information related to an account,
/// including account status, funds available for trade, funds available for withdrawal,
/// and various flags relevant to an account’s ability to trade.
public struct Account: Codable, Hashable {
	public let id: String
	public let accountNumber: String
	public let accountStatus: AccountStatus
}

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Account: Identifiable { }

/// Alpaca account status values.
///
/// Most likely, the account status is `active` unless there is any problem.
/// The account status may get in `accountUpdated` when personal information is being updated from the dashboard,
/// in which case you may not be allowed to trade for a short period of time until the change is approved.
public enum AccountStatus: String, Codable, Hashable {
	///  The account is onboarding.
	case onboarding
	/// The account application submission failed for some reason.
	case submissionFailed
	///  The account application has been submitted for review.
	case submitted
	/// The account information is being updated.
	case accountUpdated
	/// The final account approval is pending.
	case approvalPending
	/// The account is active for trading.
	case active
	/// The account application has been rejected.
	case rejected
}
