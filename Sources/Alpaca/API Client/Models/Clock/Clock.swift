import Foundation

public struct Clock: Codable, Hashable {

	public var timestamp: Date
	public var isOpen: Bool
	public var nextOpen: Date
	public var nextClose: Date

}
