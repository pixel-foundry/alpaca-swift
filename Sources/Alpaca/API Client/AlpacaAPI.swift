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

	private static var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .formatted(.rfc3339)
		return decoder
	}()

	func cancellableDataTask<T: Codable>(
		for request: URLRequest,
		_ completion: @escaping (Result<T, Error>) -> Void
	) -> Cancel {
		let task = session.dataTask(with: request) { (data, response, error) in
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
					completion(.failure(error))
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

	public enum Path: String {

		case account

		func request(endpoint: URL, version: Alpaca.Version) -> URLRequest {
			var request = URLRequest(url: endpoint.appendingPathComponent(path(version)))
			request.httpMethod = method
			return request
		}

		func path(_ version: Alpaca.Version) -> String {
			"\(version.rawValue)/\(rawValue)"
		}

		var method: String {
			switch self {
			default: return "GET"
			}
		}

	}

}
