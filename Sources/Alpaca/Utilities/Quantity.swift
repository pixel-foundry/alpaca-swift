import Foundation

/// Quantity is a type wrapper for integers that interfaces more cleanly with Alpaca’s API.
///
/// Alpaca sometimes returns strings and sometimes numbers for quantity values.
/// This type properly decodes from JSON in either case.
public struct Quantity: Hashable {

	public var value: Int

	init(_ value: Int) {
		self.value = value
	}

}

extension Quantity: ExpressibleByIntegerLiteral {

	public init(integerLiteral value: Int) {
		self.init(value)
	}

}

extension Quantity: Codable {

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if let string = try? container.decode(String.self), let integer = Int(string) {
			self.init(integer)
		} else {
			let integer = try container.decode(Int.self)
			self.init(integer)
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(value.description)
	}

}

extension Quantity: CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		value.description
	}

	public var debugDescription: String {
		value.description
	}

}

extension Quantity: AdditiveArithmetic, Comparable, Numeric {

	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Int(exactly: source) else { return nil }
		self.value = value
	}

	public var magnitude: Quantity {
		Quantity(abs(value))
	}

	public static func < (lhs: Quantity, rhs: Quantity) -> Bool {
		lhs.value < rhs.value
	}

	public static func + (lhs: Quantity, rhs: Quantity) -> Quantity {
		Quantity(lhs.value + rhs.value)
	}

	public static func - (lhs: Quantity, rhs: Quantity) -> Quantity {
		Quantity(lhs.value - rhs.value)
	}

	public static func * (lhs: Quantity, rhs: Quantity) -> Quantity {
		Quantity(lhs.value * rhs.value)
	}

	public static func / (lhs: Quantity, rhs: Quantity) -> Quantity {
		Quantity(lhs.value / rhs.value)
	}

	public static func *= (lhs: inout Quantity, rhs: Quantity) {
		lhs = Quantity(lhs.value * rhs.value)
	}

	public static func /= (lhs: inout Quantity, rhs: Quantity) {
		lhs = Quantity(lhs.value / rhs.value)
	}

	public static func % (lhs: inout Quantity, rhs: Quantity) -> Quantity {
		Quantity(lhs.value % rhs.value)
	}

}
