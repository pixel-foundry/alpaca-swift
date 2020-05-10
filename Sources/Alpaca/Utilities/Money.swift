import Foundation

/// Money is a precise representation of a currency value.
///
/// For even dollar amounts, you can initialize this type with an integer literal:
/// ```swift
/// let price: Money = 100
/// ```
///
/// For dollars and cents, use the string literal initializer instead:
/// ```swift
/// let price: Money = "100.12"
/// ```
///
/// Swift’s `Decimal` type loses precision when initialized via a float literal and encoding to JSON.
/// See [this discussion](https://forums.swift.org/t/fix-decimal-for-swift-5-2/29893) for more details.
/// Enforcing the use of the string literal initializer ensures complete precision when dealing with money values.
public struct Money: Hashable {

	public let value: Decimal

	init(_ value: Decimal) {
		self.value = value
	}

}

extension Money: ExpressibleByStringLiteral {

	public init(stringLiteral value: String) {
		self.init(Decimal(string: value) ?? 0)
	}

}

extension Money: ExpressibleByIntegerLiteral {

	public init(integerLiteral value: Int) {
		self.init(Decimal(value))
	}

}

extension Money: Codable {

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let string = try container.decode(String.self)
		self.init(stringLiteral: string)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(value.description)
	}

}

extension Money: CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		value.description
	}

	public var debugDescription: String {
		value.description
	}

}

extension Money: AdditiveArithmetic, Comparable, Numeric {

	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let decimal = Decimal(exactly: source) else { return nil }
		self.value = decimal
	}

	public var magnitude: Money {
		Money(abs(value))
	}

	public static func < (lhs: Money, rhs: Money) -> Bool {
		lhs.value < rhs.value
	}

	public static func + (lhs: Money, rhs: Money) -> Money {
		Money(lhs.value + rhs.value)
	}

	public static func - (lhs: Money, rhs: Money) -> Money {
		Money(lhs.value - rhs.value)
	}

	public static func * (lhs: Money, rhs: Money) -> Money {
		Money(lhs.value * rhs.value)
	}

	public static func / (lhs: Money, rhs: Money) -> Money {
		Money(lhs.value / rhs.value)
	}

	public static func *= (lhs: inout Money, rhs: Money) {
		lhs = Money(lhs.value * rhs.value)
	}

	public static func /= (lhs: inout Money, rhs: Money) {
		lhs = Money(lhs.value / rhs.value)
	}

}
