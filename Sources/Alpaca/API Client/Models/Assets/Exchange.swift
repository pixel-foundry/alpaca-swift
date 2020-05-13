import Foundation

public enum Exchange: String, Codable, Hashable {
	case amex = "AMEX"
	case arca = "ARCA"
	case bats = "BATS"
	case nyse = "NYSE"
	case nasdaq = "NASDAQ"
	case nysearca = "NYSEARCA"
}
