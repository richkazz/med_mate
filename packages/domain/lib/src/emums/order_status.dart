/// Represents the status of an order.
enum OrderStatusEnum {
  /// The product is on its way.
  productIsOnItsWay,

  /// The product was delivered.
  productWasDelivered,

  /// Investigating customer complaint.
  investigatingCustomerComplaint,

  /// Retrieving product.
  retrievingProduct,

  /// The product was retrieved.
  productWasRetrieved,

  /// Considering merchant appeal.
  consideringMerchantAppeal,

  /// Transaction reversed.
  transactionReversed,

  /// Transaction completed.
  transactionCompleted,

  ///
  none,
}

/// Extension methods for the [OrderStatusEnum] enum.
extension OrderStatusEnumExtension on OrderStatusEnum {
  ///
  bool get isProductIsOnItsWay => this == OrderStatusEnum.productIsOnItsWay;

  ///
  bool get isProductWasDelivered => this == OrderStatusEnum.productWasDelivered;

  ///
  bool get isInvestigatingCustomerComplaint =>
      this == OrderStatusEnum.investigatingCustomerComplaint;

  ///
  bool get isRetrievingProduct => this == OrderStatusEnum.retrievingProduct;

  ///
  bool get isProductWasRetrieved => this == OrderStatusEnum.productWasRetrieved;

  ///
  bool get isConsideringMerchantAppeal =>
      this == OrderStatusEnum.consideringMerchantAppeal;

  ///
  bool get isTransactionReversed => this == OrderStatusEnum.transactionReversed;

  ///
  bool get isTransactionCompleted =>
      this == OrderStatusEnum.transactionCompleted;

  /// Converts the enum value to an integer representation.
  int toInt() {
    return index + 1;
  }

  ///
  static const displayNames = {
    OrderStatusEnum.productIsOnItsWay: 'Product Is on Its Way',
    OrderStatusEnum.productWasDelivered: 'Product Was Delivered',
    OrderStatusEnum.investigatingCustomerComplaint:
        'Investigating Customer Complaint',
    OrderStatusEnum.retrievingProduct: 'Retrieving Product',
    OrderStatusEnum.productWasRetrieved: 'Product Was Retrieved',
    OrderStatusEnum.consideringMerchantAppeal: 'Considering Merchant Appeal',
    OrderStatusEnum.transactionReversed: 'Transaction Reversed',
    OrderStatusEnum.transactionCompleted: 'Transaction Completed',
  };

  ///
  String get displayName => displayNames[this] ?? 'Unknown';

  /// Creates an [OrderStatusEnum] from the given integer value.
  static OrderStatusEnum fromInt(int value) {
    return OrderStatusEnum.values[value - 1];
  }
}
