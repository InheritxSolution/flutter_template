import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();

    // Check if at least one connection type is available
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map((event) => event.first);
}
