import Foundation

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
