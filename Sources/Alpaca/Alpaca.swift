import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(Combine)
import Combine
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

	@discardableResult
	public func account(_ completion: @escaping (Result<Account, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.account
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	@discardableResult
	public func orders(_ completion: @escaping (Result<[Order], Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.orders(nil)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	@discardableResult
	public func order(id: String, _ completion: @escaping (Result<Order, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.orders(id)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	@discardableResult
	public func order(clientID: String, _ completion: @escaping (Result<Order, Error>) -> Void) -> Cancel {
		let request = AlpacaAPI.Path.ordersByClientID(clientID)
			.request(endpoint: api.endpoint, version: api.version)
			.authenticate(with: api.key)
		return api.cancellableDataTask(for: request, completion)
	}

	#if canImport(Combine)
	@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	var account: AnyPublisher<Account, Error> {
		var cancel: Cancel?
		return Future<Account, Error> { completion in
			cancel = self.account(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}
	#endif
	
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

}
