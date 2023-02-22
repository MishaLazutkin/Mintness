import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/utils/constants.dart';
import 'dart:async';
import 'package:mintness/utils/methods.dart';
import 'package:provider/provider.dart';

class UpdateSubtaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _priorities = [];
  Map<String, dynamic> _selectedSubtaskPriority = {};
  Map<String, dynamic> _selectedSubtaskStatus = {};
  List<Map<String, dynamic>> _assignedUsers = [];
  List<Map<String, dynamic>> _taskUsers = [];
  List<Map<String, dynamic>> _subtasksStatuses = AppConstants.subtasksStatuses;
  String _subtaskName;
  int _taskId;
  int _subtaskId;


  Future<void> init({int taskId, int subTaskId }) async {
    _taskId = taskId;
    _subtaskId = subTaskId;
    await Future.wait(
        [ loadPriorities(), loadUsers(_taskId)]);
    await loadSubTask(subTaskId);
    notifyListeners();
  }

  bool get isInited =>
      ((_priorities.isNotEmpty))
          && (_selectedSubtaskStatus.isNotEmpty) &&
          (_selectedSubtaskPriority.isNotEmpty);


  Future<void> loadSubTask(int subTaskId) async {
    final response = await Api().loadSubTask(subTaskId);
    _assignedUsers = response?.subTaskById?.subtask?.users
        ?.map(
            (user) => user.toJson())
        ?.toList();
    _selectedSubtaskStatus = _subtasksStatuses.firstWhere((element) =>
    element['id'] == response?.subTaskById?.subtask?.completeStatus);
    _selectedSubtaskPriority =
        response?.subTaskById?.subtask?.priority?.toJson();
    _subtaskName = response?.subTaskById?.subtask?.title;
    notifyListeners();
  }


  Future<void> loadUsers(int taskId) async {
    final response = await Api().loadTask(taskId);
    _taskUsers = response?.task?.task?.users
        ?.map((user) => user.toJson())?.toList();
    notifyListeners();
  }


  Future<void> loadPriorities() async {
    final response = await Api().loadPriorities();
    _priorities = response?.priorities?.priorities
        ?.map((priority) =>
    {'id': priority.id, 'name': priority.name, 'icon': priority.icon})
        ?.toList();
    notifyListeners();
  }

  bool validate() {
    return ((_subtaskName != null) && (_subtaskName.isNotEmpty)&&(_assignedUsers.isNotEmpty) );

  }

  Future<void> updateSubtask(BuildContext context) async {
    if (!validate()) return;
    Map<String, dynamic> params = {};

    params['title'] = _subtaskName;
    params['priority_id'] = _selectedSubtaskPriority['id'];
    params['complete_status'] = _selectedSubtaskStatus['id'];
    List<dynamic> users = _assignedUsers.map(
            (user) => user['id'].toString()).toList();
    for (int i = 0; i < users.length; i++) {
      params.addAll({'users[$i]': users[i]});
    }

    print('params ${params.toString()}');
    final response = await Api().updateSubTask(_subtaskId, params);
    reset();
  }

  assignUsers(Map<String, dynamic> args,int subtaskId) {
    Map<String, dynamic> params={};
    List<dynamic> users = args['users'].map(
            (user) => user['id'].toString()).toList();
    for (int i = 0; i < users.length; i++) {
      params['users[$i]']=users[i];
    }
    Api().updateSubTask(subtaskId, params);
  }

  reset() {
    _assignedUsers = [];
    _subtaskName = null;
  }

  List<Map<String, dynamic>> get users => _taskUsers;

  Map<String, dynamic> get selectedSubtaskStatus => _selectedSubtaskStatus;

  Map<String, dynamic> get selectedSubtaskPriority => _selectedSubtaskPriority;

  List<Map<String, dynamic>> get priorities => _priorities;


  String get subtaskName => _subtaskName;

  List<Map<String, dynamic>> get assignedUsers => _assignedUsers;

  set assignedUsers(List<Map<String, dynamic>> value) {
    _assignedUsers = value;
    notifyListeners();
  }

  set selectedSubtaskStatus(Map<String, dynamic> value) {
    _selectedSubtaskStatus = value;
    notifyListeners();
  }

  set selectedSubtaskPriority(Map<String, dynamic> value) {
    _selectedSubtaskPriority = value;
    notifyListeners();
  }

  set subtaskName(String value) {
    _subtaskName = value;
    notifyListeners();
  }

  int get subtaskId => _subtaskId;

  int get taskId => _taskId;

  List<Map<String, dynamic>> get subtasksStatuses => _subtasksStatuses;

  List<Map<String, dynamic>> get tasksUsers => _taskUsers;
}
