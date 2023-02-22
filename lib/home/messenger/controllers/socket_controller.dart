import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mintness/home/messenger/models/events.dart';
import 'package:mintness/home/messenger/models/subscription_models.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';

String kLocalhost = 'https://office.iowise.pp.ua:3007/socket.io/?token=${LocalStorage()
    .accessToken}';

String enumToString(_enum) {
  return _enum
      .toString()
      .split(".")
      .last;
}

class NotConnected implements Exception {}

class NotSubscribed implements Exception {}


/// Outgoing Events
Map<String, dynamic> OUTEvent =
{'connect': 'connect',
  'disconnect': 'disconnect',
  'connect_error': 'connect_error',
  'server_stats': 'server_stats',
  'session': 'session',
  'online_users': 'online-users',
  'user_connected': 'user_connected',
  'user_disconnected': 'user-disconnected',
// new-conversation
// conversation-updated
// conversation-members-updated
// delete-conversation
// delete-conversation-for-user
// conversation-update-unread-count
// new-message
// read-messages
// updated-message
// message-deleted
// conversation:read-message (to-server), payload: { last_read_id, user_id}
};


typedef DynamicCallback = void Function(dynamic data);

class SocketController {
  ///Get a provider instatnce of the class
  ///
  ///if you want to call this method in `initState` method, remember to call after the first frame.
  ///
  ///example:
  ///```
  /// WidgetsBinding.instance?.addPostFrameCallback((_) {
  ///     SocketController.get(context)
  ///       ..init()
  ///       ..connect();
  /// });
  ///```
  static SocketController get(BuildContext context) =>
      context.read<SocketController>();

  Socket _socket;
  Subscription _subscription;

  StreamController<List<ChatEvent>> _newMessagesController;
  List<ChatEvent> _events;

  Subscription get subscription => _subscription;

  bool get connected => _socket.connected;

  bool get disConnected => !connected;

  Stream<List<ChatEvent>> get watchEvents =>
      _newMessagesController?.stream.asBroadcastStream();


  void init({String url}) {
    _socket ??= io(
      url ??
          'wss://office.iowise.pp.ua:3007/socket.io/?EIO=4&token=${LocalStorage()
              .accessToken}',
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _newMessagesController ??= StreamController<List<ChatEvent>>.broadcast();
    _events = [];
  }

  void _initListeners() {
    _connectedAssetion();
    final _socket = this._socket;

    // 'session': 'session',
    // 'online_users': 'online-users',
    // 'user_connected': 'user_connected',
    // 'user_disconnected': 'user-disconnected',
    // new-conversation
    // conversation-updated
    // conversation-members-updated
    // delete-conversation
    // delete-conversation-for-user
    // conversation-update-unread-count
    // new-message
    // read-messages
    // updated-message
    // message-deleted
    //conversation:read-message (to-server), payload: { last_read_id, user_id}


    _socket.on('connect', (data) {
      final _user = ChatUser.fromMap(data, chatUserEvent: ChatUserEvent.joined);
      _newUserEvent(_user);
    });

    _socket.on('disconnect', (data) {
      print('disconnected: ${data}');
    });

    _socket.on('connect_error', (response) {
     print('connect_error: ${response}');
    });

    _socket.on('server_stats', (_) {
    });

    _socket.on('online_users', (_) {
    });
  }

  Socket connect({DynamicCallback onConnectionError, VoidCallback connected}) {
    assert(_socket != null, "Did you forget to call `init()` first?");

    final _socketS = _socket.connect();

    _socket.onConnect((_) {
      _initListeners();
      connected?.call();
      log("Connected to Socket");
    });

    _socket.onConnectError((data) => onConnectionError?.call(data));
    _socket.onConnecting((data) => print("conecting socket..."));
    _socket.onConnectTimeout((data) => print(data.toString()));
    _socket.onError((data) => print(data.toString()));
    return _socketS;
  }

  ///Disconnects the device from the socket.
  ///
  /// @Params:
  /// - `disconnected`: socket disconection success callback method.
  Socket disconnect({VoidCallback disconnected}) {
    final _socketS = _socket.disconnect();
    _socket.onDisconnect((_) {
      disconnected?.call();
      log("Disconnected");
    });
    return _socketS;
  }

  void subscribe(Subscription subscription, {VoidCallback onSubscribe}) {
    _connectedAssetion();
    final _socket = this._socket;
    _socket.emit(
      enumToString('OUTEvent.keys'),
      subscription.toMap(),
    );
    this._subscription = subscription;
    onSubscribe?.call();
    log("Subscribed to ${subscription.conversationName}");
  }

  void unsubscribe({VoidCallback onUnsubscribe}) {
    return;
    _connectedAssetion();
    if (_subscription == null) return;

    final _socket = this._socket;

    _socket..emit(
      enumToString('OUTEvent.stopTyping'),
      _subscription.conversationName,
    )..emit(
      enumToString('OUTEvent.unsubscribe'),
      _subscription.toMap(),
    );

    final _roomename = _subscription.conversationName;

    onUnsubscribe?.call();
    _subscription = null;
    _events?.clear();
    log("UnSubscribed from $_roomename");
  }

  ///Sends a message to the users in the same conversation.
  void sendMessage(Message message) {
    _connectedAssetion();
    if (_subscription == null) throw NotSubscribed();

    final _socket = this._socket;

    final _message = message.copyWith(
      userName: subscription.userName,
      conversationName: subscription.conversationName,
    );

    _socket
    //   ..emit(
    //     enumToString(OUTEvent.stopTyping),
    //     _subscription.conversationName,
    //   )
      ..emit(
        enumToString('OUTEvent.newMessage'),
        _message.toMap(),
      );

    _addNewMessage(_message);
  }

  ///Sends to the room that the current user is typing.
  void typing() {
    _connectedAssetion();
    if (_subscription == null) throw NotSubscribed();
    final _socket = this._socket;
    _socket.emit(enumToString('OUTEvent.typing'), _subscription.conversationName);
  }

  //Informs the room members that tha current user has stopped typing.
  void stopTyping() {
    _connectedAssetion();
    if (_subscription == null) throw NotSubscribed();
    final _socket = this._socket;
    _socket.emit(
        enumToString('OUTEvent.stopTyping'), _subscription.conversationName);
  }

  ///Disposes all the objects which have been initialized and resests the whole controller.
  void dispose() {
    _socket?.dispose();
    _newMessagesController?.close();
    _events?.clear();
    unsubscribe();

    _socket = null;
    _subscription = null;
    _newMessagesController = null;
    _events = null;
  }

  void _connectedAssetion() {
    assert(this._socket != null, "Did you forget to call `init()` first?");
    if (disConnected) throw NotConnected();
  }

  void _addNewMessage(Message message) => _addEvent(message);

  void _newUserEvent(ChatUser user) => _addEvent(user);

  void _addTypingEvent(UserTyping event) {
    _events.removeWhere((e) => e is UserTyping);
    _events = <ChatEvent>[event, ..._events];
    _newMessagesController?.sink.add(_events);
  }


  void _addEvent(event) {
    _events = <ChatEvent>[event, ..._events];
    _newMessagesController?.sink.add(_events);
  }

  String get _localhost {
    final _uri = Uri.parse(kLocalhost);

    // if (Platform.isIOS)
    return kLocalhost;

    //Android local url
    //return '${_uri.scheme}://10.0.2.2:${_uri.port}';
  }
}
