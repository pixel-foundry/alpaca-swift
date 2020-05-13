import Foundation

public struct Asset: Codable, Hashable {

	/// Asset ID.
	public let id: String
	/// Asset class, “us_equity”
	public let `class`: AssetClass
	public let exchange: Exchange
	public let symbol: String
	public let status: AssetStatus
	/// Asset is tradable on Alpaca or not.
	public let tradable: Bool
	/// Asset is marginable or not.
	public let marginable: Bool
	/// Asset is shortable or not.
	public let shortable: Bool
	/// Asset is easy-to-borrow or not (filtering for `easyToBorrow` = True is the
	/// best way to check whether the name is currently available to short at Alpaca).
	public let easyToBorrow: Bool

}

public enum AssetStatus: String, Codable, Hashable {
	case active
	case inactive
}

public enum AssetClass: String, Codable, Hashable {
	case usEquity
}
