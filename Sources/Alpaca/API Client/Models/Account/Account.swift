import Foundation

/// The Alpaca account API serves important information related to an account,
/// including account status, funds available for trade, funds available for withdrawal,
/// and various flags relevant to an account’s ability to trade.
public struct Account: Codable, Hashable {

	/// Account ID.
	public let id: String
	/// Account number.
	public let accountNumber: String
	public let status: AccountStatus
	public let currency: Currency
	public let cash: Money
	/// Whether or not the account has been flagged as a pattern day trader.
	public let patternDayTrader: Bool
	/// User setting. If true, the account is not allowed to place orders.
	public let tradeSuspendedByUser: Bool
	/// If true, the account is not allowed to place orders.
	public let tradingBlocked: Bool
	/// If true, the account is not allowed to request money transfers.
	public let transfersBlocked: Bool
	/// If true, the account activity by user is prohibited.
	public let accountBlocked: Bool
	/// Timestamp this account was created at.
	public let createdAt: Date
	///	Flag to denote whether or not the account is permitted to short.
	public let shortingEnabled: Bool
	/// Real-time MtM value of all long positions held in the account.
	public let longMarketValue: Money
	/// Real-time MtM value of all short positions held in the account.
	public let shortMarketValue: Money
	/// `cash` + `longMarketValue` + `shortMarketValue`
	public let equity: Money
	/// Equity as of previous trading day at 16:00:00 ET.
	public let lastEquity: Money
	/// Buying power multiplier that represents account margin classification.
	///
	/// Valid values:
	///  * 1 (standard limited margin account with 1x buying power),
	///  * 2 (reg T margin account with 2x intraday and overnight buying power;
	///  this is the default for all non-PDT accounts with $2,000 or more equity)
	///  * 4 (PDT account with 4x intraday buying power and 2x reg T overnight buying power)
	public let multiplier: String
	/// Current available $ buying power.
	///
	/// If multiplier = 4, this is your daytrade buying power
	/// which is calculated as (`lastEquity` - (last) `maintenanceMargin`) * 4;
	/// if multiplier = 2, `buyingPower` = max(`equity` – `initialMargin`,0) * 2;
	/// if multiplier = 1, `buyingPower` = `cash`.
	public let buyingPower: Money
	/// Reg T initial margin requirement (continuously updated value).
	public let initialMargin: Money
	/// Maintenance margin requirement (continuously updated value).
	public let maintenanceMargin: Money
	/// Value of special memorandum account
	/// (will be used at a later date to provide additional `buyingPower`).
	public let sma: Money
	/// The current number of daytrades that have been made in the last 5 trading days
	/// (inclusive of today).
	public let daytradeCount: Quantity
	/// Your maintenance margin requirement on the previous trading day.
	public let lastMaintenanceMargin: Money
	/// Your buying power for day trades (continuously updated value).
	public let daytradingBuyingPower: Money
	/// Your buying power under Regulation T
	/// (your excess equity - equity minus margin value - times your margin multiplier).
	public let regtBuyingPower: Money

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
	case onboarding = "ONBOARDING"
	/// The account application submission failed for some reason.
	case submissionFailed = "SUBMISSION_FAILED"
	///  The account application has been submitted for review.
	case submitted = "SUBMITTED"
	/// The account information is being updated.
	case accountUpdated = "ACCOUNT_UPDATED"
	/// The final account approval is pending.
	case approvalPending = "APPROVAL_PENDING"
	/// The account is active for trading.
	case active = "ACTIVE"
	/// The account application has been rejected.
	case rejected = "REJECTED"
}

public enum Currency: String, Codable, Hashable {
	case usd = "USD"
}
