/// Represents the status of an invoice.
enum InvoiceStatus {
  /// The invoice is pending.
  pending,

  /// The invoice has been withdrawn.
  withdrawn,

  /// The invoice has been withdrawn.
  processingPayment,

  /// The invoice has been paid.
  paymentVerified,

  ///Payment failed
  paymentFailed
}

/// Extension methods for the [InvoiceStatus] enum.
extension InvoiceStatusExtension on InvoiceStatus {
  /// Returns the integer value associated with the invoice status.
  int get value => index + 1;

  /// Returns the [InvoiceStatus] enum value corresponding to the given integer
  ///  value.
  static InvoiceStatus fromValue(int value) {
    switch (value) {
      case 1:
        return InvoiceStatus.pending;
      case 2:
        return InvoiceStatus.withdrawn;
      case 3:
        return InvoiceStatus.processingPayment;
      case 4:
        return InvoiceStatus.paymentVerified;
      case 5:
        return InvoiceStatus.paymentFailed;
      default:
        throw ArgumentError('Invalid InvoiceStatus value: $value');
    }
  }
  /// Returns the [InvoiceStatus] enum value corresponding to the given name
  ///  value.
  String get name {
    switch (this) {
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.withdrawn:
        return 'Withdrawn';
      case InvoiceStatus.processingPayment:
        return 'Processing Payment';
      case InvoiceStatus.paymentVerified:
        return 'Payment Verified';
      case InvoiceStatus.paymentFailed:
        return 'Payment Failed';
    }
  }
}
