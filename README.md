# Alpaca Trade API for Swift

https://alpaca.markets/docs/

`Alpaca` is a type-safe Swift client for the Alpaca trade API.

Currently a work in progress. The currently implemented methods and types are documented [on the Wiki](https://github.com/pixel-foundry/alpaca-swift/wiki).

## Usage

`Alpaca` defaults to `paper` trading mode.

```swift
let alpaca = Alpaca(key: Alpaca.Key(key: "[YOUR-API-KEY]", secret: "[YOUR-API-SECRET]"))
```

### Placing an order

`Alpaca` is primarily a closure-based API, and provides a `Result` type for API responses:

```swift
let order = OrderRequest(
    symbol: "AAPL",
    qty: 1,
    side: .buy,
    type: .limit,
    timeInForce: .day,
    limitPrice: 320,
    extendedHours: false
)

alpaca.place(order: order) { result in
    switch result {
    case .success(let placedOrder):
        print(placedOrder)
    case .failure(let error):
        print(error)
    }
}
```

### Placing an order using the Combine interface

`Alpaca` also offers a [Combine](https://developer.apple.com/documentation/combine) interface:

```swift
var bag = Set<AnyCancellable>()

alpaca.place(order: order).sink(
    receiveCompletion: { _ in },
    receiveValue: { placedOrder in
        print(placedOrder)
    }
).store(in: &bag)
```
