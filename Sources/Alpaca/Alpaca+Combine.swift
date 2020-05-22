#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Alpaca {

	/// The account API serves important information related to an account, including account status,
	/// funds available for trade, funds available for withdrawal,
	/// and various flags relevant to an account’s ability to trade.
	var account: AnyPublisher<Account, Error> {
		var cancel: Cancel?
		return Future<Account, Error> { completion in
			cancel = self.account(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Retrieves a list of orders for the account, filtered by the supplied query parameters.
	func orders(queryParameters: Order.QueryParameters? = nil) -> AnyPublisher<[Order], Error> {
		var cancel: Cancel?
		return Future<[Order], Error> { completion in
			cancel = self.orders(queryParameters: queryParameters, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Retrieves a single order for the given order ID.
	func order(id: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.order(id: id, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Retrieves a single order for the given client order ID.
	func order(clientID: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.order(clientID: clientID, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Places a new order for the given account.
	///
	/// An order request may be rejected if the account is not authorized for trading,
	/// or if the tradable balance is insufficient to fill the order.
	func place(order: OrderRequest) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.place(order: order, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Replaces a single order with updated parameters.
	/// Each parameter overrides the corresponding attribute of the existing order.
	///
	/// A success return code from a replaced order does NOT guarantee the existing open order has been replaced.
	/// If the existing open order is filled before the replacing (new) order reaches the execution venue,
	/// the replacing (new) order is rejected, and these events are sent in the trade_updates stream channel.
	/// While an order is being replaced, buying power is reduced by the larger of the two orders that have been placed
	/// (the old order being replaced, and the newly placed order to replace it).
	/// If you are replacing a buy entry order with a higher limit price than the original order,
	/// the buying power is calculated based on the newly placed order.
	/// If you are replacing it with a lower limit price, the buying power is calculated based on the old order.
	func replace(order id: String, with order: OrderRequest) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.replace(order: id, with: order, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Attempts to cancel an open order.
	///
	/// If the order is no longer cancelable (example: status=`orderFilled`),
	/// the server will respond with status 422, and reject the request.
	func cancelOrder(id: String) -> AnyPublisher<String, Error> {
		var cancel: Cancel?
		return Future<String, Error> { completion in
			cancel = self.cancelOrder(id: id, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Attempts to cancel all open orders.
	///
	/// A response will be provided for each order that is attempted to be cancelled.
	/// If an order is no longer cancelable, the server will respond with status 500 and reject the request.
	var cancelAllOrders: AnyPublisher<[OrderCancellation], Error> {
		var cancel: Cancel?
		return Future<[OrderCancellation], Error> { completion in
			cancel = self.cancelAllOrders(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Retrieves a list of the account’s open positions.
	var positions: AnyPublisher<[Position], Error> {
		var cancel: Cancel?
		return Future<[Position], Error> { completion in
			cancel = self.positions(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Retrieves the account’s open position for the given `symbol`.
	func position(symbol: String) -> AnyPublisher<Position, Error> {
		var cancel: Cancel?
		return Future<Position, Error> { completion in
			cancel = self.position(symbol: symbol, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Closes (liquidates) all of the account’s open long and short positions.
	/// A response will be provided for each order that is attempted to be cancelled.
	/// If an order is no longer cancelable, the server will respond with status 500 and reject the request.
	var closeAllPositions: AnyPublisher<[PositionLiquidation], Error> {
		var cancel: Cancel?
		return Future<[PositionLiquidation], Error> { completion in
			cancel = self.closeAllPositions(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Closes (liquidates) the account’s open position for the given `symbol`. Works for both long and short positions.
	func closePosition(symbol: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.closePosition(symbol: symbol, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// The assets API serves as the master list of assets available for trade and data consumption from Alpaca.
	///
	/// Assets are sorted by asset class, exchange and symbol.
	/// Some assets are only available for data consumption via Polygon, and are not tradable with Alpaca.
	/// These assets will be marked with the flag `tradable`=`false`.
	func assets(
		queryParameters: Asset.QueryParameters? = nil
	) -> AnyPublisher<[Asset], Error> {
		var cancel: Cancel?
		return Future<[Asset], Error> { completion in
			cancel = self.assets(queryParameters: queryParameters, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// Get an asset for the given symbol (or asset ID).
	func asset(
		symbol: String
	) -> AnyPublisher<Asset, Error> {
		var cancel: Cancel?
		return Future<Asset, Error> { completion in
			cancel = self.asset(symbol: symbol, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// The calendar API serves the full list of market days from 1970 to 2029.
	/// It can also be queried by specifying a start and/or end time to narrow down the results.
	func calendar(
		queryParameters: Calendar.QueryParameters? = nil
	) -> AnyPublisher<[Calendar], Error> {
		var cancel: Cancel?
		return Future<[Calendar], Error> { completion in
			cancel = self.calendar(queryParameters: queryParameters, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	/// The clock API serves the current market timestamp, whether or not the market is currently open,
	/// as well as the times of the next market open and close.
	var clock: AnyPublisher<Clock, Error> {
		var cancel: Cancel?
		return Future<Clock, Error> { completion in
			cancel = self.clock(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

}

#endif
