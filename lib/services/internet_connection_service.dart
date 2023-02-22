import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectionService {

  static final _singleton = InternetConnectionService._internal();

  factory InternetConnectionService() => _singleton;

  InternetConnectionService._internal();

  bool _isOnline = false;
  final _onConnectedListeners = <Function>[];
  final _onDisconnectedListeners = <Function>[];

  bool get isOnline => _isOnline;

  bool get isOffline => !_isOnline;

  bool _resultIsOnline(ConnectivityResult result) =>
      result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;

  bool _resultIsOffline(ConnectivityResult result) => result == ConnectivityResult.none;

  void _onConnectivityChanged(ConnectivityResult result) {
    if (_resultIsOnline(result)) {
      if (!_isOnline) {
        _isOnline = true;
        _callListeners(_onConnectedListeners);
      }
    } else if (_resultIsOffline(result)) {
      if (_isOnline) {
        _isOnline = false;
        _callListeners(_onDisconnectedListeners);
      }
    }
  }

  void _callListeners(List<Function> listeners) {
    for (final listener in listeners) {
      try {
        if (listener != null) listener();
      } catch (exception, stackTrace) {
        print('InternetConnectionService ERROR: $exception');
        print(stackTrace);
      }
    }
  }

  void addOnConnectedListener(Function listener) {
    if (listener != null) _onConnectedListeners.add(listener);
  }

  void addOnDisconnectedListener(Function listener) {
    if (listener != null) _onDisconnectedListeners.add(listener);
  }

  void removeOnConnectedListener(Function listener) {
    if (listener != null) _onConnectedListeners.remove(listener);
  }

  void removeOnDisconnectedListener(Function listener) {
    if (listener != null) _onDisconnectedListeners.remove(listener);
  }

  Future<void> init({
    Function onConnectedListener,
    Function onDisconnectedListener,
  }) async {
    Connectivity()
      .onConnectivityChanged
      .listen(_onConnectivityChanged);

    _isOnline = _resultIsOnline(await Connectivity().checkConnectivity());

    addOnConnectedListener(onConnectedListener);
    addOnDisconnectedListener(onDisconnectedListener);
  }
}
