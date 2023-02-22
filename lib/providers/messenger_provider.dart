import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintness/home/messenger/controllers/socket_controller.dart';
import 'package:http/http.dart' as http;
import 'package:mintness/models/api_responses/conversation_messages_response.dart';
import 'package:mintness/models/domain/photo.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/utils/choose_image.dart';
import 'package:mintness/utils/methods.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http_parser/http_parser.dart';

class MessengerProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _comments;
  List<Map<String, dynamic>> _conversations;
  List<Map<String, dynamic>> _selectedUsers = [];
  List<Map<String, dynamic>> _users = [];
  List<Photo> _chosenCommentImages = <Photo>[];
  WebSocketChannel _channel;
  SocketController _socketController;
  int conversationId;
  bool connected;
  List<File> _chosenCommentFiles = [];
  int _limit = 3;
  Map<String, dynamic> _userInfo;
  String _searchedText = '';
  int _editedMessageId;
  String _messageFromController;
  String _editedMessageContent;
  bool _isEditMessage = false;
  bool _isReply = false;
  int _repliedMessageId;
  String _repliedMessage;
  String _repliedUserName;


  //---- Create Channel ----
  String _title;
  String _description;
  bool _type = false;

//----
  List<Map<String, dynamic>> get selectedUsers => _selectedUsers;

  Future<void> init() async {
    Future.wait([loadConversations(), loadUsers()]);
    notifyListeners();
  }

  void initIOSocketClient() {
    WebSocket.connect('wss://ws.ifelse.io/').then((ws) {
      print('ws ${ws.toString()}');
      var channel = IOWebSocketChannel(ws);
      channel.sink.add("hello");
    });
  }

  void connectToSocketIOServer() {
    try {
      Socket socket = io(
          'wss://office.iowise.pp.ua:3007/socket.io/?token=${LocalStorage().accessToken}',
          <String, dynamic>{
            'transports': ['websocket'],
            'autoConnect': false,
          });
      socket.connect();
      socket.on('connect', (_) => print('connect: ${socket.id}'));
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('connect_error', (_) => print('connect_error: ${_}'));
    } catch (e) {
      print(e.toString());
    }
  }

  void initSocketClient() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(
            'wss://office.iowise.pp.ua:3007/socket.io/?EIO=4&token=${LocalStorage().accessToken}'),
      );
    } on Exception catch (e) {
      print("Error on connecting to websocket: $e");
    } catch (error) {
      print("Error on connecting to websocket: $error");
    }

    _channel.stream.listen((msg) async {
      print('msg: $msg');
    });
  }


  void closeSocket() {
    _channel.sink.close();
  }

  Future<void> loadComments(int conversId,
      {int offset, String direction}) async {
    conversationId = conversId;
    final ConversationMessagesResponse conversationMessagesResponse =
        await Api().getConversationMessages(conversationId, offset, direction);
    _comments = conversationMessagesResponse.conversationMessages.messages
        .map((e) => e.toJson())
        .toList();
    notifyListeners();
  }

  Future<bool> deleteComment(int commentId) async {
    final bool response = await Api().deleteMessengerComment(commentId);
    loadComments(conversationId);
  }

  Future<void> loadConversations() async {
    final response = await Api().loadConversations();
    _conversations = response?.conversations?.conversations
        ?.map((conversation) => conversation.toJson())
        ?.toList();
    notifyListeners();
  }

  Future<void> loadUsers() async {
    final response = await Api().loadUsers();
    _users = response?.users?.map((user) => user.toJson())?.toList();
    notifyListeners();
  }

  Future<bool> createConversation() async {
    bool success = await Api().createConversation(
        name: title,
        description: description,
        type: (type == false) ? 'public' : 'private',
        users: selectedUsers.map((e) => e['id']).toList());
    return success;
  }

  Future<dynamic> replyComment(
      {int conversationId, String content, int messageId}) async {
    dynamic success = await Api().replyComment(
        conversationId: conversationId,
        content: content,
        messageId:  messageId
    );
    resetFormData();
    return success;
  }

  Future<String> sendComment(
      {List<File> files, int conversationId, String message}) async {
    var request = http.MultipartRequest(
        'POST',
        Uri(
            scheme: Api.scheme,
            host: Api.PPUA_DOMAIN,
            path: 'api/chat/messages'));
    String authorization = LocalStorage().accessToken;
    Map<String, String> headers = {
      "Authorization": "Bearer $authorization",
      "Content-type": "multipart/form-data"
    };
    Map<String, String> params = {
      "conversation_id": '$conversationId',
      "content": message
    };
    for (File file in files) {
      request.files.add(
        http.MultipartFile(
          'files[]',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split("/").last,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    request.fields.addAll(params);
    request.headers.addAll(headers);
    http.Response response =
        await http.Response.fromStream(await request.send());
    resetFormData();
    await loadComments(conversationId);
    notifyListeners();
    return response.body;
  }



  Future<String> updateComment(
      {List<File> files, int messageId, String message,int pinned}) async {
    var request = http.MultipartRequest(
        'POST',
        Uri(
            scheme: Api.scheme,
            host: Api.PPUA_DOMAIN,
            path: 'api/chat/messages/$messageId/update'));
    String authorization = LocalStorage().accessToken;
    Map<String, String> headers = {
      "Authorization": "Bearer $authorization",
      "Content-type": "multipart/form-data"
    };
    Map<String, String> params = {
      "pinned": "$pinned",
      "content": message
    };
    for (File file in files) {
      request.files.add(
        http.MultipartFile(
          'files[]',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split("/").last,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    request.fields.addAll(params);
    request.headers.addAll(headers);
    http.Response response =
        await http.Response.fromStream(await request.send());
    print('response.body ${response.body}');
    resetFormData();
    await loadComments(conversationId);
    notifyListeners();
    return response.body;
  }


  Future<void> chooseCommentImages(BuildContext context) async {
    if (limit < 1) return;
    try {
      final images = await chooseImages(limit: limit, quality: 80);
      if ((images ?? []).isNotEmpty) {
        _chosenCommentImages.addAll(images);
      }
    } catch (exception, stackTrace) {
      print(exception);
    }
    notifyListeners();
  }

  Future<void> chooseCommentFiles() async {
    if (limit < 1) return;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      result.files.removeRange(limit, result.files.length);
      if (result != null) {
        for (int i = 0; i < result.files.length; i++) {
          double size = result.files[i].size / 1024 / 1024;
          if (size >= 15) {
            toast('The size of file you are uploading must be under 15 MB.',
                type: ToastTypes.error);
            return;
          }
        }
        _chosenCommentFiles = result.paths.map((path) => File(path)).toList();
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
  }

  bool isEmptyComment(String commentText) {
    return _chosenCommentFiles.isEmpty &&
        _chosenCommentImages.isEmpty &&
        commentText.isEmpty;
  }

  void resetProvider() {
    _comments = null;
    notifyListeners();
  }

  void resetFormData() {
    _chosenCommentFiles = [];
    _chosenCommentImages = [];
    _messageFromController=null;
    _editedMessageContent=null;
    _repliedMessage=null;
    _repliedMessageId=null;
    _isEditMessage=false;
    _isReply=false;
    notifyListeners();
  }

  get chosenCommentImages => _chosenCommentImages;

  List<File> get chosenCommentFiles => _chosenCommentFiles;

  int get limit {
    var newLimit =
        _limit - _chosenCommentFiles.length - _chosenCommentImages.length;
    if (newLimit <= 0)
      return 0;
    else
      return newLimit;
  }

  Future<void> loadUserInfo(int userId) async {
    final response = await Api().loadChatUser(userId);
    _userInfo = response.chatUser.user.toJson();
  }

  Map<String, dynamic> get userInfo => _userInfo;

  List<Map<String, dynamic>> get conversations {
    if (_searchedText == '') return _conversations;
    return _conversations
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(_searchedText.toLowerCase()))
        .toList();
  }

  set searchedText(String value) {
    _searchedText = value;
    notifyListeners();
  }

  List get comments => _comments;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  set selectedUsers(List<Map<String, dynamic>> value) {
    _selectedUsers = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get users => _users;

  bool get type => _type;

  set type(bool value) {
    _type = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  SocketController get socketController => _socketController;

  set socketController(SocketController value) {
    _socketController = value;
  }

  int get editedMessageId => _editedMessageId;

  set editedMessageId(int value) {
    _editedMessageId = value;
    notifyListeners();
  }

  bool get isEditMessage => _isEditMessage;

  set isEditMessage(bool value) {
    _isEditMessage = value;
    _isReply = false;
    notifyListeners();
  }

  bool get isReply {
    return _isReply;
  }

  set isReply(bool value) {
    _isReply = value;
    _isEditMessage = false;
    notifyListeners();
  }

  String get messageFromController => _messageFromController;
  set messageFromController(String value) {
    _messageFromController = value;
  }

  String get editedMessageContent => _editedMessageContent;
  set editedMessageContent(String value) {
    _editedMessageContent = value;
  }

  int get repliedMessageId => _repliedMessageId;

  set repliedMessageId(int value) {
    _repliedMessageId = value;
    notifyListeners();
  }

  String get repliedUserName => _repliedUserName;
  set repliedUserName(String value) {
    _repliedUserName = value;
    notifyListeners();
  }

  String get repliedMessage => _repliedMessage;
  set repliedMessage(String value) {
    _repliedMessage = value;
    notifyListeners();
  }
}
