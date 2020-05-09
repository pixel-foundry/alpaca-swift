import Foundation

public struct AlpacaError: Error, Codable, Hashable {
	public let code: Int
	public let message: String
}
