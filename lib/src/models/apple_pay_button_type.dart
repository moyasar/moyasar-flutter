/// The types of button supported on Apple Pay.
///
/// See the [PKPaymentButtonType](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype)
/// class in the Apple Pay documentation to learn more.
enum ApplePayButtonType {
  plain,
  buy,
  setUp,
  inStore,
  donate,
  checkout,
  book,
  subscribe,
  reload,
  addMoney,
  topUp,
  order,
  rent,
  support,
  contribute,
  tip,
}

/// The button styles supported on Apple Pay.
///
/// See the [PKPaymentButtonStyle](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle)
/// class in the Apple Pay documentation to learn more.
enum ApplePayButtonStyle {
  white,
  whiteOutline,
  black,
  automatic,
}
