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

	func order(id: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.order(id: id, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	func order(clientID: String) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.order(clientID: clientID, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	func place(order: OrderRequest) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.place(order: order, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	func replace(order id: String, with order: OrderRequest) -> AnyPublisher<Order, Error> {
		var cancel: Cancel?
		return Future<Order, Error> { completion in
			cancel = self.replace(order: id, with: order, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

	func cancelOrder(id: String) -> AnyPublisher<String, Error> {
		var cancel: Cancel?
		return Future<String, Error> { completion in
			cancel = self.cancelOrder(id: id, completion)
		}.handleEvents(receiveCancel: {
			cancel?.cancel()
		}).eraseToAnyPublisher()
	}

}

#endif
