import Foundation

public struct Order: Codable, Hashable {

	public let id: String
	/// Client unique order ID.
	public let clientOrderId: String
	public let createdAt: Date
	public let updatedAt: Date?
	public let submittedAt: Date?
	public let filledAt: Date?
	public let expiredAt: Date?
	public let canceledAt: Date?
	public let failedAt: Date?
	public let replacedAt: Date?
	/// The order ID that this order was replaced by.
	public let replacedBy: String?
	/// The order ID that this order replaces.
	public let replaces: String?
	public let assetId: String
	/// Asset symbol.
	public let symbol: String
	public let assetClass: String
	/// Ordered quantity.
	public let qty: Quantity
	/// Filled quantity.
	public let filledQty: Quantity
	public let type: OrderType
	public let side: OrderSide
	public let timeInForce: TimeInForce
	public let limitPrice: Money?
	public let stopPrice: Money?
	public let filledAvgPrice: Money?
	public let status: OrderStatus
	/// If true, eligible for execution outside regular trading hours.
	public let extendedHours: Bool
	/// When querying non-simple `OrderClass` orders in a nested style,
	/// an array of Order entities associated with this order. Otherwise, null.
	public let legs: [Order]?

}


@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Order: Identifiable { }

/// See [Alpaca’s docs](https://alpaca.markets/docs/trading-on-alpaca/orders/#order-lifecycle) for more details.
public enum OrderStatus: String, Codable, Hashable {
	case new
	case partiallyFilled = "partially_filled"
	case filled
	case doneForDay = "done_for_day"
	case canceled
	case expired
	case replaced
	case pendingCancel = "pending_cancel"
	case pendingReplace = "pending_replace"
	case accepted
	case pendingNew = "pending_new"
	case acceptedForBidding = "accepted_for_bidding"
	case stopped
	case rejected
	case suspended
	case calculated
}
