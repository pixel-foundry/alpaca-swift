import Foundation
#if canImport(FoundationNetworking)
	import FoundationNetworking
#endif

final class AlpacaNetworking {

	private let mode: Alpaca.Mode

	private lazy var endpoint: URL = {
		switch mode {
		case .paper:
			return URL(string: "https://paper-api.alpaca.markets")!
		case .live:
			return URL(string: "https://api.alpaca.markets")!
		}
	}()

	private let configuration: URLSessionConfiguration

	private lazy var session: URLSession = {
		URLSession(configuration: configuration)
	}()

	init(configuration: URLSessionConfiguration = .default, mode: Alpaca.Mode) {
		self.configuration = configuration
		self.mode = mode
	}

}
