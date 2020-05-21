import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Swift API client for Alpaca’s trade API.
/// Contribute on [GitHub](https://github.com/pixel-foundry/alpaca-swift).
public final class Alpaca {

	public init(
		sessionConfiguration: URLSessionConfiguration = .default,
		mode: Mode = .paper,
		version: Version = .v2,
		key: Key
	) {
		api = AlpacaAPI(configuration: sessionConfiguration, mode: mode, version: version, key: key)
	}

	private let api: AlpacaAPI

	public enum Version: String {
		case v2
	}

	public enum Mode {
		/// Live trade with real money.
		case live
		/// Paper trade in a real-time simulation environment where you can test your code.
		case paper
	}

	/// The account API serves important information related to an account, including account status,
	/// funds available for trade, funds available for withdrawal,
	/// and various flags relevant to an account’s ability to trade.
	@discardableResult
	public func account(_ completion: @escaping (Result<Account, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.account
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Retrieves a list of orders for the account, filtered by the supplied query parameters.
	@discardableResult
	public func orders(
		queryParameters: Order.QueryParameters? = nil,
		_ completion: @escaping (Result<[Order], Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.orders(nil)
			.request(endpoint: api.endpoint, version: api.version)
			.addQueryParameters(queryParameters)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Retrieves a single order for the given order ID.
	@discardableResult
	public func order(id: String, _ completion: @escaping (Result<Order, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.orders(id)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Retrieves a single order for the given client order ID.
	@discardableResult
	public func order(clientID: String, _ completion: @escaping (Result<Order, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.ordersByClientID(clientID)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Places a new order for the given account.
	///
	/// An order request may be rejected if the account is not authorized for trading,
	/// or if the tradable balance is insufficient to fill the order.
	@discardableResult
	public func place(order: OrderRequest, _ completion: @escaping (Result<Order, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.placeOrder(order)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
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
	@discardableResult
	public func replace(
		order id: String,
		with order: OrderRequest,
		_ completion: @escaping (Result<Order, Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.replaceOrder((id: id, order: order))
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Attempts to cancel an open order.
	///
	/// If the order is no longer cancelable (example: status=`orderFilled`),
	/// the server will respond with status 422, and reject the request.
	@discardableResult
	public func cancelOrder(id: String, _ completion: @escaping (Result<String, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.cancelOrder(id)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Attempts to cancel all open orders.
	///
	/// A response will be provided for each order that is attempted to be cancelled.
	/// If an order is no longer cancelable, the server will respond with status 500 and reject the request.
	@discardableResult
	public func cancelAllOrders(_ completion: @escaping (Result<[OrderCancellation], Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.cancelAllOrders
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Retrieves a list of the account’s open positions.
	@discardableResult
	public func positions(
		_ completion: @escaping (Result<[Position], Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.positions
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Retrieves the account’s open position for the given `symbol`.
	@discardableResult
	public func position(
		symbol: String,
		_ completion: @escaping (Result<Position, Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.position(symbol)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Closes (liquidates) all of the account’s open long and short positions.
	/// A response will be provided for each order that is attempted to be cancelled.
	/// If an order is no longer cancelable, the server will respond with status 500 and reject the request.
	@discardableResult
	public func closeAllPositions(
		_ completion: @escaping (Result<[PositionLiquidation], Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.closePositions
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Closes (liquidates) the account’s open position for the given `symbol`. Works for both long and short positions.
	@discardableResult
	public func closePosition(
		symbol: String,
		_ completion: @escaping (Result<Order, Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.closePosition(symbol)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// The assets API serves as the master list of assets available for trade and data consumption from Alpaca.
	///
	/// Assets are sorted by asset class, exchange and symbol.
	/// Some assets are only available for data consumption via Polygon, and are not tradable with Alpaca.
	/// These assets will be marked with the flag `tradable`=`false`.
	@discardableResult
	public func assets(
		queryParameters: Asset.QueryParameters? = nil,
		_ completion: @escaping (Result<[Asset], Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.assets
			.request(endpoint: api.endpoint, version: api.version)
			.addQueryParameters(queryParameters)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// Get an asset for the given symbol (or asset ID).
	@discardableResult
	public func asset(
		symbol: String,
		_ completion: @escaping (Result<Asset, Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.asset(symbol: symbol)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	/// The calendar API serves the full list of market days from 1970 to 2029.
	/// It can also be queried by specifying a start and/or end time to narrow down the results.
	@discardableResult
	public func calendar(
		queryParameters: Calendar.QueryParameters? = nil,
		_ completion: @escaping (Result<[Calendar], Error>) -> Void
	) -> Cancel {
		let request = AlpacaAPI.Path.calendar
			.request(endpoint: api.endpoint, version: api.version)
			.addQueryParameters(queryParameters)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

}
