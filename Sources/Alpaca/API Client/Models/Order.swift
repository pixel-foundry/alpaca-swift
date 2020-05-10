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
	public let qty: Int
	/// Filled quantity.
	public let filledQty: Int
	public let type: OrderType
	public let side: OrderSide
	public let timeInForce: TimeInForce
	public let limitPrice: Decimal?
	public let stopPrice: Decimal?
	public let filledAvgPrice: Decimal?
	public let status: OrderStatus
	/// If true, eligible for execution outside regular trading hours.
	public let extendedHours: Bool
	/// When querying non-simple `OrderClass` orders in a nested style,
	/// an array of Order entities associated with this order. Otherwise, null.
	public let legs: [Order]?
	
}

@available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Order: Identifiable { }

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
}
