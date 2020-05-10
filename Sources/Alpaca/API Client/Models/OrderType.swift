import Foundation

public enum OrderType: String, Codable, Hashable {
	case market
	case limit
	case stop
	case stopLimit
}

public enum OrderSide: String, Codable, Hashable {
	case buy
	case sell
}
