import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class AlpacaAPI {

	init(
		configuration: URLSessionConfiguration,
		mode: Alpaca.Mode,
		version: Alpaca.Version,
		key: Alpaca.Key
	) {
		self.configuration = configuration
		self.mode = mode
		self.version = version
		self.key = key
	}

	let configuration: URLSessionConfiguration
	let mode: Alpaca.Mode
	let version: Alpaca.Version
	let key: Alpaca.Key

	lazy var endpoint: URL = {
		switch mode {
		case .paper:
			return URL(string: "https://paper-api.alpaca.markets")!
		case .live:
			return URL(string: "https://api.alpaca.markets")!
		}
	}()

	static var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .formatted(.rfc3339)
		return decoder
	}()

	static var encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		encoder.dateEncodingStrategy = .formatted(.rfc3339)
		return encoder
	}()

	func cancellableDataTask<T: Codable>(
		for request: URLRequest,
		_ completion: @escaping (Result<T, Error>) -> Void
	) -> Cancel {
		let task = session.dataTask(with: request) { (data, _, error) in
			if let error = error {
				completion(.failure(error))
			} else if let data = data {
				do {
					let value = try AlpacaAPI.decoder.decode(T.self, from: data)
					completion(.success(value))
				} catch {
					if let alpacaError = try? AlpacaAPI.decoder.decode(AlpacaError.self, from: data) {
						completion(.failure(alpacaError)); return
					}
					if "" is T, let string = String(data: data, encoding: .utf8) {
						completion(.success(string as! T))
					} else {
						completion(.failure(error))
					}
				}
			}
		}
		task.resume()
		return Cancel { [weak task] in
			task?.cancel()
		}
	}

	lazy var session: URLSession = {
		URLSession(configuration: configuration)
	}()

	public enum Path {
		// Account
		case account
		// Orders
		case orders(String?)
		case ordersByClientID(String)
		case placeOrder(OrderRequest)
		case replaceOrder((id: String, order: OrderRequest))
		case cancelOrder(String)
		case cancelAllOrders
		// Positions
		case positions, closePositions
		case position(String), closePosition(String)

		func request(endpoint: URL, version: Alpaca.Version) -> URLRequest {
			var request = URLRequest(url: endpoint.appendingPathComponent(path(version)))
			request.httpMethod = method
			encodeBody(to: &request)
			return request
		}

		func encodeBody(to request: inout URLRequest) {
			switch self {
			case .placeOrder(let order):
				request.httpBody = try? AlpacaAPI.encoder.encode(order)
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			case .replaceOrder((_, let replacementOrder)):
				request.httpBody = try? AlpacaAPI.encoder.encode(replacementOrder)
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			default: return
			}
		}

		func path(_ version: Alpaca.Version) -> String {
			"\(version.rawValue)/\(value)"
		}

		var method: String {
			switch self {
			case .placeOrder: return "POST"
			case .replaceOrder: return "PATCH"
			case .cancelOrder, .cancelAllOrders,
					 .closePosition, .closePositions:
				return "DELETE"
			default: return "GET"
			}
		}

		var value: String {
			switch self {
			case .account: return "account"
			case .orders(let orderID):
				if let id = orderID { return "orders/\(id)" }
				return "orders"
			case .ordersByClientID(let clientID):
				return "orders:\(clientID)"
			case .placeOrder, .cancelAllOrders: return "orders"
			case .replaceOrder((let orderID, _)),
				 .cancelOrder(let orderID):
				return "orders/\(orderID)"
			case .positions, .closePositions: return "positions"
			case .position(let symbol), .closePosition(let symbol):
				return "positions/\(symbol)"
			}
		}

	}

}
