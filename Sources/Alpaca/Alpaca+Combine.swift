#if canImport(Combine)
import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Alpaca {

	var account: AnyPublisher<Account, Error> {
		var cancel: Cancel?
		return Future<Account, Error> { completion in
			cancel = self.account(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	var orders: AnyPublisher<[Order], Error> {
		var cancel: Cancel?
		return Future<[Order], Error> { completion in
			cancel = self.orders(completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	func order(_ id: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.order(id: id, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

}

#endif
