import Foundation

public struct Position: Codable, Hashable {

	/// Asset ID.
	public let assetId: String
	/// Symbol name of the asset.
	public let symbol: String
	/// Exchange name of the asset.
	public let exchange: String
	/// Asset class name.
	public let assetClass: String
	/// Average entry price of the position.
	public let avgEntryPrice: Money
	/// The number of shares.
	public let qty: Quantity
	public let side: PositionSide
	/// Total dollar amount of the position.
	public let marketValue: Money
	/// Total cost basis in dollars.
	public let costBasis: Money
	/// Unrealized profit/loss in dollars.
	public let unrealizedPl: Money
	/// Unrealized profit/loss percent (by a factor of 1).
	public let unrealizedPlpc: String
	/// Unrealized profit/loss in dollars for the day.
	public let unrealizedIntradayPl: Money
	/// Unrealized profit/loss percent (by a factor of 1) for the day.
	public let unrealizedIntradayPlpc: String
	/// Current asset price per share.
	public let currentPrice: Money
	/// Last day’s asset price per share based on the closing value of the last trading day.
	public let lastdayPrice: Money
	/// Percent change from last day price (by a factor of 1).
	public let changeToday: String

}

public enum PositionSide: String, Codable, Hashable {
	case long
	case short
}
