/// Represents the network connection status.
enum NetworkConnectionStatus {
  /// The device is connected to the network.
  connected,

  /// The device is disconnected from the network.
  disconnected,
}

/// Extension methods for the [NetworkConnectionStatus] enum.
extension NetworkConnectionStatusExtension on NetworkConnectionStatus {
  /// Converts the enum value to a lowercase string representation.
  String toStringValue() {
    return toString().split('.').last.toLowerCase();
  }
}
