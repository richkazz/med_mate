import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:domain/domain.dart';

class NetworkInfoImpl {
  NetworkInfoImpl(this.connectionChecker);
  final DataConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<NetworkConnectionStatus> get onStatusChange =>
      DataConnectionChecker().onStatusChange.map((event) {
        switch (event) {
          case DataConnectionStatus.connected:
            return NetworkConnectionStatus.connected;
          case DataConnectionStatus.disconnected:
            return NetworkConnectionStatus.disconnected;
        }
      }).asBroadcastStream();
}
