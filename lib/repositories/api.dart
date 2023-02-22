import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meta/meta.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mintness/auth/auth_page_email.dart';
import 'package:mintness/models/api_responses/chat_user_response.dart';
import 'package:mintness/models/api_responses/conversation_messages_response.dart';
import 'package:mintness/models/api_responses/conversations_response.dart';
import 'package:mintness/models/api_responses/create_subtask_response.dart';
import 'package:mintness/models/api_responses/create_task_response.dart';
import 'package:mintness/models/api_responses/delete_project_response.dart';
import 'package:mintness/models/api_responses/file_response.dart';
import 'package:mintness/models/api_responses/files_response.dart';
import 'package:mintness/models/api_responses/priorities_response.dart';
import 'package:mintness/models/api_responses/project_statuses_response.dart';
import 'package:mintness/models/api_responses/project_timeline_response.dart';
import 'package:mintness/models/api_responses/projects_type_response.dart';
import 'package:mintness/models/api_responses/refresh_response.dart';
import 'package:http/http.dart' as http;
import 'package:mintness/models/api_responses/add_time_response.dart';
import 'package:mintness/models/api_responses/comments_response.dart';
import 'package:mintness/models/api_responses/login_response.dart';
import 'package:mintness/models/api_responses/profile_response.dart';
import 'package:mintness/models/api_responses/sended_comment_response.dart';
import 'package:mintness/models/api_responses/subtask_response.dart';
import 'package:mintness/models/api_responses/tasks_statuses_response.dart';
import 'package:mintness/models/api_responses/project_response.dart';
import 'package:mintness/models/api_responses/project_timesheets_response.dart';
import 'package:mintness/models/api_responses/projects_response.dart';
import 'package:mintness/models/api_responses/recent_tasks_response.dart';
import 'package:mintness/models/api_responses/start_timer_response.dart';
import 'package:mintness/models/api_responses/stop_timer_response.dart';
import 'package:mintness/models/api_responses/task_lists_response.dart';
import 'package:mintness/models/api_responses/task_timesheets_response.dart';
import 'package:mintness/models/api_responses/tasks_by_project_id_response.dart';
import 'package:mintness/models/api_responses/tasks_of_project_response.dart';
import 'package:mintness/models/api_responses/tasks_response.dart';
import 'package:mintness/models/api_responses/send_comment_response.dart';
import 'package:mintness/models/api_responses/task_response.dart';
import 'package:mintness/models/api_responses/taskslists_response.dart';
import 'package:mintness/models/api_responses/timesheet_response.dart';
import 'package:mintness/models/api_responses/timesheets_response.dart';
import 'package:mintness/models/api_responses/update_project_response.dart';
import 'package:mintness/models/api_responses/update_task_response.dart';
import 'package:mintness/models/api_responses/users_of_project_response.dart';
import 'package:mintness/models/api_responses/users_response.dart';
import 'package:mintness/models/domain/photo.dart';
import 'package:mintness/services/flushbar_service.dart';
import 'package:mintness/services/internet_connection_service.dart';
import 'package:mintness/repositories/httpClient.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/methods.dart';
import '../app.dart';
import 'local_storage.dart';

class Api {
  static final _singleton = Api._internal();

  factory Api() => _singleton;

  Api._internal();

  static const scheme = 'https';
  static const login_path = '/login';


  static const PPUA_DOMAIN = 'api.office.iowise.pp.ua';
  static const IMAGES_DOMAIN = 'office.iowise.pp.ua';

  final _client_dio = DioClient();


  void _checkConnectivity(String errorMessage) {
    if (InternetConnectionService().isOffline) {
      FlushbarService().showError('Internet connection is lost.');
    } else {
      FlushbarService().showError(errorMessage);
    }
  }

  void _handleHttpError({String method, Uri route, error}) {
    try {
      if (error != null) {
        print('ERROR: $method $route\n${error}');
        _checkConnectivity(error);
      }
    } catch (exception, stackTrace) {
      log('HTTP ERROR HANDLING ERROR: $exception');
      log('HTTP ERROR HANDLING ERROR: ${stackTrace}');
    }
  }

  Future<bool> _refreshToken(Response response) async {
    try {
      final errorMessage = response.data['error'];

      if (errorMessage == 'Unauthenticated.') {

        {
          final RefreshResponse refreshResponse = await refreshToken();
          if (refreshResponse?.accessToken == null) {
            NavigationService().pushAndRemoveUntil(
                App.globalKey.currentState.context,
                const AuthPageEmail(),
                (_) => false);
            return false;
          } else {
            LocalStorage().saveRefreshToken(refreshResponse?.refreshToken);
            LocalStorage().saveAccessToken(refreshResponse?.accessToken);
          }
          return !refreshResponse?.hasError;
        }
      } else
        return false;
    } catch (exception, stackTrace) {
      print('AUTH TOKEN EXPIRATION _refreshResponse ERROR: $exception');
      return false;
    }
  }

  Future<T> _parsedResponse<T>(
    Response response, {
    Function onSuccess,
    Function onError,
  }) async {
    if (response == null) return null;
    // if (response.statusCode < 300) {
    //   _processCounters(response);
    // }
    switch (response.statusCode) {
      case 200:
        return onSuccess == null ? null : onSuccess(response);
      case 400:
        return onError == null ? null : onError(response);
      default:
        return null;
    }
  }

  Future<Response> _get(
    String path, {
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  }) async {
    if (queryParameters != null) {
      queryParameters.removeWhere((k, v) => v == null);
      queryParameters.forEach((k, v) {
        if (v is! String) queryParameters[k] = v.toString();
      });
      if (queryParameters.isEmpty) {
        queryParameters = null;
      }
    }
    final route = Uri(
      scheme: scheme,
      host: PPUA_DOMAIN,
      path: '$path',
      queryParameters: queryParameters,
    );
    try {
      var response;
      response = await _client_dio.callDio(
          Rest.GET, '$scheme://$PPUA_DOMAIN/$path',
          data: queryParameters);

      if (response.statusCode == 401) {
        final bool isRefreshed = await _refreshToken(response);

        if (isRefreshed) {
          response = await _client_dio.callDio(
              Rest.GET, '$scheme://$PPUA_DOMAIN/$path',
              data: queryParameters);
          //   log('second call response statusCode on $scheme://$PPUA_DOMAIN/$path : ${response?.statusCode}');
        }
      }
      return response;
    } catch (error) {
      _handleHttpError(method: 'GET', route: route, error: error);
      return null;
    }
  }

  Future<Response> _post(
    String path, {
    Map<String, dynamic> queryParameters,
    String rawBody,
    Map<String, String> headers,
  }) async {
    if (queryParameters != null) {
      queryParameters.removeWhere((k, v) => v == null);
      queryParameters.forEach((k, v) {
        if (v is! String) queryParameters[k] = v.toString();
      });
      if (queryParameters.isEmpty) {
        queryParameters = null;
      }
    }
    final route = Uri(scheme: scheme, host: PPUA_DOMAIN, path: '$path');
    try {

      Response response = await _client_dio.callDio(
          Rest.POST, '$scheme://$PPUA_DOMAIN/$path',
          data: queryParameters);
      if (response.statusCode == 401) {
        final bool isRefreshed = await _refreshToken(response);
        if (isRefreshed)
          response = await _client_dio.callDio(
              Rest.POST, '$scheme://$PPUA_DOMAIN/$path',
              data: queryParameters);
      }
      return response;
    } catch (error) {
      _handleHttpError(method: 'POST', route: route, error: error);
      return null;
    }
  }

  Future<Response> _put(
    String path, {
    Map<String, dynamic> body,
    String rawBody,
    Map<String, String> headers,
  }) async {
    if (body != null) {
      body.removeWhere((k, v) => v == null);
      body.forEach((k, v) {
        if (v is! String) body[k] = v.toString();
      });
      if (body.isEmpty) {
        body = null;
      }
    }

    final route = Uri(scheme: scheme, host: PPUA_DOMAIN, path: '$path');
    try {
      var response;
      response = await _client_dio.callDio(
          Rest.PUT, '$scheme://$PPUA_DOMAIN/$path',
          data: body ?? rawBody);


      if (response.statusCode == 401) {
        final bool isRefreshed = await _refreshToken(response);
        if (isRefreshed)
          response = await _client_dio.callDio(
              Rest.PUT, '$scheme://$PPUA_DOMAIN/$path',
              data: body ?? rawBody);
      }
      return response;
    } catch (error) {
      _handleHttpError(method: 'PUT', route: route, error: error);
      return null;
    }
  }

  Future<Response> _delete(
    String path, {
    Map body,
    String rawBody,
    Map<String, String> headers,
  }) async {
    if (body != null) {
      body.removeWhere((k, v) => v == null);
      body.forEach((k, v) {
        if (v is! String) body[k] = v.toString();
      });
      if (body.isEmpty) {
        body = null;
      }
    }
    final route = Uri(scheme: scheme, host: PPUA_DOMAIN, path: '$path');
    try {
      var response;
      response = await _client_dio
          .callDio(Rest.DELETE, '$scheme://$PPUA_DOMAIN/$path', data: body);

      if (response.statusCode == 401) {
        final bool isRefreshed = await _refreshToken(response);
        if (isRefreshed)
          response = await _client_dio
              .callDio(Rest.DELETE, '$scheme://$PPUA_DOMAIN/$path', data: body);
      }
      return response;
    } catch (error) {
      _handleHttpError(method: 'PUT', route: route, error: error);
      return null;
    }
  }

  Future<RefreshResponse> refreshToken() async {
    try {
      final response = await _client_dio.callDio(
          Rest.POST, '$scheme://$PPUA_DOMAIN/refresh_token', data: {
        'expires_in': 6000,
        'refresh_token': LocalStorage().refreshToken
      });
      if (response.statusCode == 200) {
        dynamic decoded = response.data as Map<String, dynamic>;
        return RefreshResponse.fromMap(decoded);
      } else
        return null;
    } catch (exception, stackTrace) {

      return null;
    }
  }

  Future<LoginResponse> login(
      {@required String email,
      @required String password,
      bool staySignedIn,
      BuildContext context}) async {
    try {
      final response = await Dio().post('$scheme://$PPUA_DOMAIN/login', data: {
        'email': email.toString(),
        'password': password.toString(),
        'remember': staySignedIn
      });
      // print('login response $response');

      return LoginResponse.fromMap(response.data);
    }
    // on DioError catch (e) {
    //
    // print(e.response.statusCode);
    //
    // print('e.message ${e.message}');
    // return const LoginResponse.error();
    // }
    catch (exception, stackTrace) {

      return const LoginResponse.error();
    } finally {
      //_login_client.close();
    }
  }

  //
  // Future<ForgetPasswordResponse> requestCode({@required String email}) async {
  //   final response = await _post('sms-code-verify', body: {'email': email});
  //   return _parsedResponse<ForgetPasswordResponse>(
  //     response,
  //     onSuccess: (r) => ForgetPasswordResponse.fromResponse(r),
  //   );
  // }

  Future<ProfileResponse> loadProfile() async {
    final response = await _get(
      'api/users/profile',
    );
    return _parsedResponse<ProfileResponse>(
      response,
      onSuccess: (r) => ProfileResponse.fromResponse(r),
      onError: (r) => ProfileResponse.fromResponse(r),
    );
  }

  Future<UsersResponse> loadUsers() async {
    final response = await _get(
      'api/users',
    );
    return _parsedResponse<UsersResponse>(
      response,
      onSuccess: (r) => UsersResponse.fromResponse(r),
      onError: (r) => UsersResponse.fromResponse(r),
    );
  }

  Future<ChatUserResponse> loadChatUser(int userId) async {
    final response = await _get(
      'api/users/${userId}/',
    );

    return _parsedResponse<ChatUserResponse>(
      response,
      onSuccess: (r) => ChatUserResponse.fromResponse(r),
      onError: (r) => ChatUserResponse.fromResponse(r),
    );
  }

  Future<ProjectResponse> loadProjectById({@required int project_id}) async {
    final response = await _get('api/projects/$project_id');
    return _parsedResponse<ProjectResponse>(
      response,
      onSuccess: (r) => ProjectResponse.fromResponse(r),
      onError: (r) => ProjectResponse.fromResponse(r),
    );
  }

  Future<ProjectsStatusesResponse> loadProjectsStatuses() async {
    final response = await _get('api/projects/statuses');
    return _parsedResponse<ProjectsStatusesResponse>(
      response,
      onSuccess: (r) => ProjectsStatusesResponse.fromResponse(r),
      onError: (r) => ProjectsStatusesResponse.fromResponse(r),
    );
  }

  Future<TaskTimesheetsResponse> loadTaskTimesheets(int task_id) async {
    final response = await _get('api/tasks/$task_id/timesheets');
    return _parsedResponse<TaskTimesheetsResponse>(
      response,
      onSuccess: (r) => TaskTimesheetsResponse.fromResponse(r),
      onError: (r) => TaskTimesheetsResponse.fromResponse(r),
    );
  }

  Future<CommentsResponse> loadComments({@required int task_id}) async {
    final response =
        await _get('api/comments', queryParameters: {'task_id': task_id});
    return _parsedResponse<CommentsResponse>(
      response,
      onSuccess: (r) => CommentsResponse.fromResponse(r),
      onError: (r) => CommentsResponse.fromResponse(r),
    );
  }

  Future<ConversationsResponse> loadConversations( ) async {
    final response =
        await _get('api/chat/conversations' );
    return _parsedResponse<ConversationsResponse>(
      response,
      onSuccess: (r) => ConversationsResponse.fromResponse(r),
      onError: (r) => ConversationsResponse.fromResponse(r),
    );
  }

  Future<ConversationMessagesResponse> loadConversationMessages(int  conversationId) async {
    final response =
        await _get('api/chat/conversations/$conversationId/messages' );
    return _parsedResponse<ConversationMessagesResponse>(
      response,
      onSuccess: (r) => ConversationMessagesResponse.fromResponse(r),
      onError: (r) => ConversationMessagesResponse.fromResponse(r),
    );
  }

  Future<SendedCommentResponse> createConversationMessage(
      {@required String content, int conversationId}) async {
    final response = await _post('api/chat/messages',
        queryParameters: {'content': content, 'conversation_id': conversationId, 'files[]': conversationId});
    return _parsedResponse<SendedCommentResponse>(
      response,
      onSuccess: (r) => SendedCommentResponse.fromResponse(r),
      onError: (r) => SendedCommentResponse.fromResponse(r),
    );
  }

  Future<dynamic> replyComment(
      { String content, int conversationId, int messageId }) async {
    final response = await _post('api/chat/messages/',
        queryParameters: {'content': content, 'conversation_id': conversationId, 'reply_id': messageId});
    print('response.data ${response.data.toString()}');
    return response.data;
  }

  Future<bool> createConversation(
      {String name,String description, String type, List<dynamic> users}) async {
    Map<String,dynamic> queryParameters = {};
    for (int i = 0; i < users.length; i++) {
      queryParameters.addAll({'users[$i]': users[i]});
    }
    queryParameters['type'] = type;
    queryParameters['description'] = description;
    queryParameters['name'] = name;

    final response = await _post('api/chat/conversations',
        queryParameters: queryParameters);
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<SendedCommentResponse> sendComment(
      {@required int task_id, String text}) async {
    final response = await _post('api/comments',
        queryParameters: {'task_id': task_id, 'text': text});
    return _parsedResponse<SendedCommentResponse>(
      response,
      onSuccess: (r) => SendedCommentResponse.fromResponse(r),
      onError: (r) => SendedCommentResponse.fromResponse(r),
    );
  }

  Future<bool> sendMessagerComment(
      {@required int conversation_id, String message}) async {
    final response = await _post('api/chat/messages',
        queryParameters: {'conversation_id': conversation_id, 'content': message});
    return response.data['status'] == 'success';
  }

  Future<ConversationMessagesResponse> getConversationMessages(int conversationId,int offset,String direction) async{
    final response = await _get('api/chat/conversations/$conversationId/messages',
        queryParameters: {'direction': direction,'offset':offset});
    return _parsedResponse<ConversationMessagesResponse>(
      response,
      onSuccess: (r) => ConversationMessagesResponse.fromResponse(r),
      onError: (r) => ConversationMessagesResponse.fromResponse(r),
    );
  }

  Future<AddTimeResponse> addTime(
      {int task_id,
      int project_id,
      String description,
      String start,
      String end,
      int user_id}) async {
    final response = await _post('api/timesheets', queryParameters: {
      'project_id': project_id,
      'task_id': task_id,
      'start': start,
      'end': end,
      'description': description,
    });

    return _parsedResponse<AddTimeResponse>(
      response,
      onSuccess: (r) => AddTimeResponse.fromResponse(r),
      onError: (r) => AddTimeResponse.fromResponse(r),
    );
  }

  Future<bool> updateTime({
    int timeSheetId,
    int task_id,
    int project_id,
    int subtask_id,
    String description,
    String start,
    String end,
  }) async {
    final response = await _put('api/timesheets/$timeSheetId', body: {
      'project_id': project_id,
      'task_id': task_id,
      'start': start,
      'end': end,
      'description': description,
    });

    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response?.data['status'] == 'success';
  }

  Future<StartTimerResponse> startTimer(
      {int task_id, int project_id, String description, int subtaskId}) async {
    final response = await _post('api/timers', queryParameters: {
      'project_id': project_id,
      'task_id': task_id,
      'subtask_id': subtaskId,
      'description': description,
    });
    return _parsedResponse<StartTimerResponse>(
      response,
      onSuccess: (r) => StartTimerResponse.fromResponse(r),
      onError: (r) => StartTimerResponse.fromResponse(r),
    );
  }

  Future<StopTimerResponse> stopTimer({int timer_id}) async {
    final response = await _put(
      'api/timers/$timer_id/stop',
    );

    return _parsedResponse<StopTimerResponse>(
      response,
      onSuccess: (r) => StopTimerResponse.fromResponse(r),
      onError: (r) => StopTimerResponse.fromResponse(r),
    );
  }

  Future<TasksResponse> loadTasks() async {
    final response =
        await _get('api/tasks', queryParameters: {'withCompleted': true});
    return _parsedResponse<TasksResponse>(
      response,
      onSuccess: (r) => TasksResponse.fromResponse(r),
      onError: (r) => TasksResponse.fromResponse(r),
    );
  }

  Future<TimesheetResponse> loadTimesheet(int timesheetId) async {
    final response = await _get(
      'api/timesheets/$timesheetId',
    );
    return _parsedResponse<TimesheetResponse>(
      response,
      onSuccess: (r) => TimesheetResponse.fromResponse(r),
      onError: (r) => TimesheetResponse.fromResponse(r),
    );
  }

  Future<bool> getSmsCode(String email) async {
    final response =
        await _post('api/sms-code-verify', queryParameters: {'email': email});
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response?.data['status'] == 'success';
  }

  Future<bool> verifySmsCode(String code) async {
    final response =
        await _post('api/verify-code', queryParameters: {'code': code});
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response?.data['status'] == 'success';
  }

  Future<bool> resetPassword(String code, String password) async {
    final response = await _post('api/reset_password',
        queryParameters: {'code': code, 'password': password});
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response?.data['status'] == 'success';
  }

  Future<ProjectsResponse> loadProjects() async {
    final response =
        await _get('api/projects', queryParameters: {'withUsers': true});
    return _parsedResponse<ProjectsResponse>(
      response,
      onSuccess: (r) => ProjectsResponse.fromResponse(r),
      onError: (r) => ProjectsResponse.fromResponse(r),
    );
  }

  Future<ProjectsTypesResponse> loadProjectsTypes() async {
    final response =
        await _get('api/projects', queryParameters: {'withUsers': true});
    return _parsedResponse<ProjectsTypesResponse>(
      response,
      onSuccess: (r) => ProjectsTypesResponse.fromResponse(r),
      onError: (r) => ProjectsTypesResponse.fromResponse(r),
    );
  }

  Future<TaskListsResponse> loadTaskList(int project_id) async {
    final response = await _get('api/tasks/lists',
        queryParameters: {'project_id': project_id});
    return _parsedResponse<TaskListsResponse>(
      response,
      onSuccess: (r) => TaskListsResponse.fromResponse(r),
      onError: (r) => TaskListsResponse.fromResponse(r),
    );
  }

  Future<TasksOfProjectResponse> loadTasksOfProject(int project_id) async {
    final response =
        await _get('api/tasks', queryParameters: {'project_id': project_id});
    return _parsedResponse<TasksOfProjectResponse>(
      response,
      onSuccess: (r) => TasksOfProjectResponse.fromResponse(r),
      onError: (r) => TasksOfProjectResponse.fromResponse(r),
    );
  }

  Future<TasksByProjectIdResponse> loadTasksByProjectId(int project_id) async {
    final response = await _get('api/tasks',
        queryParameters: {'project_id': project_id, 'completed': true});
    return _parsedResponse<TasksByProjectIdResponse>(
      response,
      onSuccess: (r) => TasksByProjectIdResponse.fromResponse(r),
      onError: (r) => TasksByProjectIdResponse.fromResponse(r),
    );
  }

  Future<bool> deleteTask(int task_id) async {
    final response = await _delete('api/tasks/$task_id');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> deleteMessengerComment(int commentId) async {
    final response = await _delete('api/chat/messages/$commentId/');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> deleteTimesheet(int timesheetId) async {
    final response = await _delete('api/timesheets/$timesheetId');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> deleteSubTask(int subtaskId) async {
    final response = await _delete('api/subtasks/$subtaskId');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> deleteFile(int fileId) async {
    final response = await _delete('api/files/$fileId/');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> renameFile(int fileId, String newName) async {
    final response = await _put('api/files/$fileId', body: {'name': newName});
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<ProjectTimesheetsResponse> loadProjectTimesheets(
      int project_id) async {
    final response = await _get('api/timesheets',
        queryParameters: {'project_id': project_id});
    return _parsedResponse<ProjectTimesheetsResponse>(
      response,
      onSuccess: (r) => ProjectTimesheetsResponse.fromResponse(r),
      onError: (r) => ProjectTimesheetsResponse.fromResponse(r),
    );
  }

  Future<TimesheetsResponse> loadTimesheets(int userId ) async {
    final response = await _get('api/timesheets', queryParameters: {'byDates': true,'users':[userId]}
        );
    return _parsedResponse<TimesheetsResponse>(
      response,
      onSuccess: (r) => TimesheetsResponse.fromResponse(r),
      onError: (r) => TimesheetsResponse.fromResponse(r),
    );
  }

  Future<TasksStatusesResponse> loadTasksProgressStatuses() async {
    final response = await _get('api/tasks/statuses');
    return _parsedResponse<TasksStatusesResponse>(
      response,
      onSuccess: (r) => TasksStatusesResponse.fromResponse(r),
      onError: (r) => TasksStatusesResponse.fromResponse(r),
    );
  }

  Future<ProjectsStatusesResponse> loadProjectsProgressStatuses() async {
    final response = await _get('api/projects/statuses');
    return _parsedResponse<ProjectsStatusesResponse>(
      response,
      onSuccess: (r) => ProjectsStatusesResponse.fromResponse(r),
      onError: (r) => ProjectsStatusesResponse.fromResponse(r),
    );
  }

  Future<UsersByProjectIdResponse> loadUsersOfProject(int project_id) async {
    final response = await _get('api/projects/${project_id}/users/');
    return _parsedResponse<UsersByProjectIdResponse>(
      response,
      onSuccess: (r) => UsersByProjectIdResponse.fromResponse(r),
      onError: (r) => UsersByProjectIdResponse.fromResponse(r),
    );
  }

  Future<UpdateTaskResponse> updateTask(
      int task_id, Map<String, dynamic> params) async {
    final response = await _put('api/tasks/${task_id}', body: params);
    return _parsedResponse<UpdateTaskResponse>(
      response,
      onSuccess: (r) => UpdateTaskResponse.fromResponse(r),
      onError: (r) => UpdateTaskResponse.fromResponse(r),
    );
  }

  Future<bool> updateProfileStatus(int statusId) async {
    final response =
        await _put('api/users/profile_status', body: {'status_id': statusId});
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<bool> updateSubTask(int subtaskId, Map<String, dynamic> params) async {
    final response = await _put('api/subtasks/${subtaskId}', body: params);
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<UpdateTaskResponse> updateProfile(
      int user_id, Map<String, dynamic> params) async {
    final response = await _put('api/users/${user_id}', body: params);
    return _parsedResponse<UpdateTaskResponse>(
      response,
      onSuccess: (r) => UpdateTaskResponse.fromResponse(r),
      onError: (r) => UpdateTaskResponse.fromResponse(r),
    );
  }

  Future<CreateTaskResponse> createTask(Map<String, dynamic> params) async {
    final response = await _post('api/tasks', queryParameters: params);
    return _parsedResponse<CreateTaskResponse>(
      response,
      onSuccess: (r) => CreateTaskResponse.fromResponse(r),
      onError: (r) => CreateTaskResponse.fromResponse(r),
    );
  }

  Future<CreateSubtaskResponse> createSubtask(
      Map<String, dynamic> params) async {
    final response = await _post('api/subtasks', queryParameters: params);
    return _parsedResponse<CreateSubtaskResponse>(
      response,
      onSuccess: (r) => CreateSubtaskResponse.fromResponse(r),
      onError: (r) => CreateSubtaskResponse.fromResponse(r),
    );
  }

  Future<bool> changePassword(Map<String, dynamic> params) async {
    final response =
        await _get('api/users/change_password', queryParameters: params);
    toast(
        response?.data['status'] == 'success'
            ? "User info has been updated"
            : 'Error',
        type: getType(response?.data['status'] ?? null));
    return response?.data['status'] == 'success';
  }

  Future<UpdateProjectResponse> updateProject(
      int projectId, Map<String, dynamic> params) async {
    log('body2 ${params.toString()}');

    final response = await _put('api/projects/${projectId}/', body: params);
    return _parsedResponse<UpdateProjectResponse>(
      response,
      onSuccess: (r) => UpdateProjectResponse.fromResponse(r),
      onError: (r) => UpdateProjectResponse.fromResponse(r),
    );
  }

  Future<DeleteProjectResponse> deleteProject(int project_id) async {
    final response = await _delete('api/projects/${project_id}/');
    return _parsedResponse<DeleteProjectResponse>(
      response,
      onSuccess: (r) => DeleteProjectResponse.fromResponse(r),
      onError: (r) => DeleteProjectResponse.fromResponse(r),
    );
  }

  Future<bool> deleteAvatar() async {
    final response = await _delete('api/users/avatar');
    toast(response?.data['message'] ?? 'Error',
        type: getType(response?.data['status'] ?? null));
    return response.data['status'] == 'success';
  }

  Future<TaskResponse> loadTask(int task_id) async {
    final response = await _get('api/tasks/$task_id');
    return _parsedResponse<TaskResponse>(
      response,
      onSuccess: (r) => TaskResponse.fromResponse(r),
      onError: (r) => TaskResponse.fromResponse(r),
    );
  }

  Future<SubTaskResponse> loadSubTask(int subTaskId) async {
    final response = await _get('api/subtasks/$subTaskId');
    return _parsedResponse<SubTaskResponse>(
      response,
      onSuccess: (r) => SubTaskResponse.fromResponse(r),
      onError: (r) => SubTaskResponse.fromResponse(r),
    );
  }

  Future<PrioritiesResponse> loadPriorities() async {
    final response = await _get('api/priorities');
    return _parsedResponse<PrioritiesResponse>(
      response,
      onSuccess: (r) => PrioritiesResponse.fromResponse(r),
      onError: (r) => PrioritiesResponse.fromResponse(r),
    );
  }

  Future<FilesResponse> loadFiles(Map<String, dynamic> params) async {
    final response = await _get('api/files', queryParameters: params);
    return _parsedResponse<FilesResponse>(
      response,
      onSuccess: (r) => FilesResponse.fromResponse(r),
      onError: (r) => FilesResponse.fromResponse(r),
    );
  }

  Future<FileResponse> getFile(int fileId) async {
    final response = await _get('api/files/$fileId/' );
    return _parsedResponse<FileResponse>(
      response,
      onSuccess: (r) => FileResponse.fromResponse(r),
      onError: (r) => FileResponse.fromResponse(r),
    );
  }

  Future<ProfileResponse> loadCurrentTimer() async {
    final response = await _get(
      'api/users/profile',
    );
    return _parsedResponse<ProfileResponse>(
      response,
      onSuccess: (r) => ProfileResponse.fromResponse(r),
      onError: (r) => ProfileResponse.fromResponse(r),
    );
  }

  Future<RecentTasksResponse> loadRecentTasks(int userId) async {
    final response = await _get('api/tasks',
        queryParameters: {'user_id': userId, 'recent': true});
    return _parsedResponse<RecentTasksResponse>(
      response,
      onSuccess: (r) => RecentTasksResponse.fromResponse(r),
      onError: (r) => RecentTasksResponse.fromResponse(r),
    );
  }

  Future<RecentTasksResponse> loadUserTasks(int userId) async {
    final response = await _get('api/tasks',
        queryParameters: {'user_id': userId, 'recent': false});
    return _parsedResponse<RecentTasksResponse>(
      response,
      onSuccess: (r) => RecentTasksResponse.fromResponse(r),
      onError: (r) => RecentTasksResponse.fromResponse(r),
    );
  }

  Future<ProjectTimelineResponse> loadProjectTimeline(int project_id) async {
    final response = await _get('api/projects/timeline',
        queryParameters: {'project_id': project_id});
    return _parsedResponse<ProjectTimelineResponse>(
      response,
      onSuccess: (r) => ProjectTimelineResponse.fromResponse(r),
      onError: (r) => ProjectTimelineResponse.fromResponse(r),
    );
  }

  Future<TasklistsResponse> loadTaskListsOfProject(int project_id) async {
    final response = await _get('api/tasks/lists',
        queryParameters: {'project_id': project_id});
    return _parsedResponse<TasklistsResponse>(
      response,
      onSuccess: (r) => TasklistsResponse.fromResponse(r),
      onError: (r) => TasklistsResponse.fromResponse(r),
    );
  }

  Future<bool> uploadAvatar(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri(scheme: scheme, host: PPUA_DOMAIN, path: 'api/users/avatar'),
    )..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${LocalStorage().accessToken}',
      });
    List<int> _imageByteList =
        await processedImageBytesList(await file.readAsBytes());
    request.files.add(
      http.MultipartFile.fromBytes(
        'avatar',
        _imageByteList,
        filename: file.path.split("/").last,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.statusCode}");
    print("body: ${response.body}");
    return json.decode(response.body)['status'] == 'success';
  }

  Future<Map<String, dynamic>> attachFiles(
      List<File> files, String relation_type, int relation_id) async {
    var request = http.MultipartRequest(
        'POST', Uri(scheme: scheme, host: PPUA_DOMAIN, path: 'api/files'));
    String authorization = LocalStorage().accessToken;
    Map<String, String> headers = {
      "Authorization": "Bearer $authorization",
      "Content-type": "multipart/form-data"
    };

    Map<String, String> params = {
      "relation_type": "comments",
      "relation_id": "$relation_id"
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
    print("Result: ${response.statusCode}");
    print("body: ${response.body}");
    log("url: ${Uri(scheme: scheme, host: PPUA_DOMAIN, path: 'api/files').toString()}");
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> attachPhotos(
      List<Photo> images, String relation_type, int relation_id) async {
    List<MultipartFile> multipartImageList = [];

    for (int i = 0; i < images.length; i++) {
      MultipartFile multipartFile = MultipartFile.fromBytes(
        images[i].bytes,
        filename: images[i].name,
        contentType: MediaType("image", images[i].formattedExtension),
      );
      multipartImageList.add(multipartFile);
    }

    FormData formData = FormData.fromMap({
      "files[]": multipartImageList,
      "relation_type": "$relation_type",
      "relation_id": "$relation_id"
    });

    try {
      Dio dio = new Dio();
      var response = await dio.post(scheme + '://$PPUA_DOMAIN' + '/api/files',
          options: Options(
            method: 'POST',
            headers: {
              'Content-Type': 'multipart/form-data',
              'Authorization': 'Bearer ${LocalStorage().accessToken}',
            },
          ),
          data: formData);

      print('response.data.toString(), ${response.data.toString()}');
    } on DioError catch (e) {
      print(e);
      print(e);
    }
  }

  Future<List<int>> processedImageBytesList(List<int> imageBytes) async {
    return FlutterImageCompress.compressWithList(imageBytes);
  }
}
