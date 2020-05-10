import Foundation

public struct Order: Hashable {

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

extension Order: Encodable { }

extension Order: Decodable {

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(String.self, forKey: .id)
		clientOrderID = try values.decode(String.self, forKey: .clientOrderID)
		createdAt = try values.decode(Date.self, forKey: .createdAt)
		updatedAt = try values.decode(Date?.self, forKey: .updatedAt)
		submittedAt = try values.decode(Date?.self, forKey: .submittedAt)
		filledAt = try values.decode(Date?.self, forKey: .filledAt)
		expiredAt = try values.decode(Date?.self, forKey: .expiredAt)
		canceledAt = try values.decode(Date?.self, forKey: .canceledAt)
		failedAt = try values.decode(Date?.self, forKey: .failedAt)
		replacedAt = try values.decode(Date?.self, forKey: .replacedAt)
		replacedBy = try values.decode(String?.self, forKey: .replacedBy)
		replaces = try values.decode(String?.self, forKey: .replaces)
		assetID = try values.decode(String.self, forKey: .assetID)
		symbol = try values.decode(String.self, forKey: .symbol)
		assetClass = try values.decode(String.self, forKey: .assetClass)
		let quantityString = try values.decode(String.self, forKey: .qty)
		guard let quantity = Int(quantityString) else { throw OrderDecodeError.invalidQuantity }
		qty = quantity
		let filledQuantityString = try values.decode(String.self, forKey: .filledQty)
		guard let filledQuantity = Int(filledQuantityString) else { throw OrderDecodeError.invalidQuantity }
		filledQty = filledQuantity
		type = try values.decode(OrderType.self, forKey: .type)
		side = try values.decode(OrderSide.self, forKey: .side)
		timeInForce = try values.decode(TimeInForce.self, forKey: .timeInForce)

		let limitString = try values.decode(String?.self, forKey: .limitPrice)
		let limitDecimal = Decimal(string: limitString ?? "")
		limitPrice = limitDecimal

		let stopString = try values.decode(String?.self, forKey: .stopPrice)
		let stopDecimal = Decimal(string: stopString ?? "")
		stopPrice = stopDecimal

		let filledString = try values.decode(String?.self, forKey: .filledAvgPrice)
		let filledDecimal = Decimal(string: filledString ?? "")
		filledAvgPrice = filledDecimal

		status = try values.decode(OrderStatus.self, forKey: .status)
		extendedHours = try values.decode(Bool.self, forKey: .extendedHours)
		legs = try values.decode([Order]?.self, forKey: .legs)
	}

	enum OrderDecodeError: Error {
		case invalidQuantity
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
