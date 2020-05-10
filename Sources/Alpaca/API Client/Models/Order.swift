import Foundation

public struct Order: Codable, Hashable {

	public let id: String
	/// Client unique order ID.
	public let clientOrderID: String
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
	public let assetID: String
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

	public enum CodingKeys: String, CodingKey {
		case id
		case clientOrderID = "clientOrderId"
		case createdAt
		case updatedAt
		case submittedAt
		case filledAt
		case expiredAt
		case canceledAt
		case failedAt
		case replacedAt
		case replacedBy
		case replaces
		case assetID = "assetId"
		case symbol
		case assetClass
		case qty
		case filledQty
		case type
		case side
		case timeInForce
		case limitPrice
		case stopPrice
		case filledAvgPrice
		case status
		case extendedHours
		case legs
	}

}


@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Order: Identifiable { }

/// See [Alpaca’s docs](https://alpaca.markets/docs/trading-on-alpaca/orders/#order-lifecycle) for more details.
public enum OrderStatus: String, Codable, Hashable {
	case new
	case partiallyFilled
	case filled
	case doneForDay
	case canceled
	case expired
	case replaced
	case pendingCancel
	case pendingReplace
	case accepted
	case pendingNew
	case acceptedForBidding
	case stopped
	case rejected
	case suspended
	case calculated
}
