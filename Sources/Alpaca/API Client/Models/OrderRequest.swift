import Foundation

public struct OrderRequest: Codable, Hashable {

	public init(
		symbol: String,
		qty: Int,
		side: OrderSide,
		type: OrderType,
		timeInForce: TimeInForce,
		limitPrice: Decimal? = nil,
		stopPrice: Decimal? = nil,
		extendedHours: Bool = false,
		clientOrderID: String? = nil,
		orderClass: OrderClass? = nil,
		takeProfit: TakeProfit? = nil,
		stopLoss: StopLoss? = nil
	) {
		self.symbol = symbol
		self.qty = qty
		self.side = side
		self.type = type
		self.timeInForce = timeInForce
		self.limitPrice = limitPrice
		self.stopPrice = stopPrice
		self.extendedHours = extendedHours
		self.clientOrderID = clientOrderID
		self.orderClass = orderClass
		self.takeProfit = takeProfit
		self.stopLoss = stopLoss
	}

	/// Symbol or asset ID to identify the asset to trade.
	public var symbol: String

	/// Number of shares to trade.
	public var qty: Int

	public var side: OrderSide

	public var type: OrderType

	public var timeInForce: TimeInForce

	/// Required if type is `limit` or `stopLimit`
	public var limitPrice: Decimal?

	/// Required if type is `stop` or `stopLimit`
	public var stopPrice: Decimal?

	/// If true, order will be eligible to execute in premarket/afterhours.
	///
	/// Only works with type `limit` and time in force `day`.
	public var extendedHours = false

	/// A unique identifier for the order. Automatically generated if not sent. 48 characters or less.
	public var clientOrderID: String?

	public var orderClass: OrderClass?

	public var takeProfit: TakeProfit?

	public var stopLoss: StopLoss?

}

/// Additional parameters for take-profit leg of advanced orders.
public struct TakeProfit: Codable, Hashable {

	/// Required for bracket orders.
	public var limitPrice: Decimal

	public init(limitPrice: Decimal) {
		self.limitPrice = limitPrice
	}

}

/// Additional parameters for stop-loss leg of advanced orders.
public struct StopLoss: Codable, Hashable {

	/// Required for bracket orders.
	public var stopPrice: Decimal
	/// The stop-loss order becomes a stop-limit order if specified.
	public var limitPrice: Decimal?

	public init(stopPrice: Decimal, limitPrice: Decimal? = nil) {
		self.stopPrice = stopPrice
		self.limitPrice = limitPrice
	}

}
