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


public enum OrderSide: String, Codable, Hashable {
	case buy
	case sell
}

public enum OrderType: String, Codable, Hashable {
	case market
	case limit
	case stop
	case stopLimit
}


public enum TimeInForce: String, Codable, Hashable {
	/// A day order is eligible for execution only on the day it is live.
	///
	/// By default, the order is only valid during Regular Trading Hours (9:30am - 4:00pm ET).
	/// If unfilled after the closing auction, it is automatically canceled. If submitted after the close,
	/// it is queued and submitted the following trading day.
	/// However, if marked as eligible for extended hours, the order can also execute during supported extended hours.
	case day
	/// The order is good until canceled.
	///
	/// Non-marketable GTC limit orders are subject to price adjustments to offset corporate actions affecting the issue.
	/// We do not currently support Do Not Reduce(DNR) orders to opt out of such price adjustments.
	case gtc
	/// Use this TIF with a market/limit order type to submit “market on open” (MOO) and “limit on open” (LOO) orders.
	///
	/// This order is eligible to execute only in the market opening auction.
	/// Any unfilled orders after the open will be cancelled. OPG orders submitted after 9:28am but before 7:00pm ET
	/// will be rejected. OPG orders submitted after 7:00pm will be queued and routed to the following day’s
	/// opening auction. On open/on close orders are routed to the primary exchange.
	/// Such orders do not necessarily execute exactly at 9:30am / 4:00pm ET but execute per the exchange’s auction rules.
	case opg
	/// Use this TIF with a market/limit order type to submit “market on close” (MOC) and “limit on close” (LOC) orders.
	///
	/// This order is eligible to execute only in the market closing auction.
	/// Any unfilled orders after the close will be cancelled. CLS orders submitted after 3:50pm but before 7:00pm ET
	/// will be rejected. CLS orders submitted after 7:00pm will be queued and routed to the following day’s
	/// closing auction.
	case cls
	///  An Immediate Or Cancel (IOC) order requires all or part of the order to be executed immediately.
	///  Any unfilled portion of the order is canceled.
	case ioc
	/// A Fill or Kill (FOK) order is only executed if the entire order quantity can be filled,
	/// otherwise the order is canceled.
	case fok
}

/// See [Alpaca’s docs](https://alpaca.markets/docs/trading-on-alpaca/orders/#bracket-orders) for more details.
public enum OrderClass: String, Codable, Hashable {
	case simple
	case bracket
	case oco
	case oto
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
