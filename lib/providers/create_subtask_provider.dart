import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/utils/constants.dart';
import 'dart:async';


class CreateSubtaskProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _subtasksStatuses=AppConstants.subtasksStatuses;
  Map<String, dynamic> _selectedSubtaskStatus;

  List<Map<String, dynamic>> _priorities = [];
  Map<String, dynamic> _selectedSubtaskPriority;
  List<Map<String, dynamic>> _taskUsers=[];
  List<Map<String, dynamic>> _selectedUsers=[];
  String _subtaskName;
  int _taskId;

  Future<void> init(int taskId ) async {
    _taskId = taskId;
    _selectedSubtaskStatus = _subtasksStatuses.first;
    await Future.wait(
        [   loadPriorities(),loadUsers(_taskId)]);
    notifyListeners();
  }

  bool get isInited =>_priorities.isNotEmpty ;


  Future<void> loadUsers(int task_id) async {
    final response = await Api().loadTask(task_id);
    _taskUsers = response?.task?.task?.users
        ?.map(
            (user) => user.toJson())
        ?.toList();

    notifyListeners();
  }

  Future<void> loadPriorities() async {
    final response = await Api().loadPriorities();
    _priorities = response?.priorities?.priorities
        ?.map((priority) =>
            {'id': priority.id, 'name': priority.name, 'icon': priority.icon})
        ?.toList();

    _selectedSubtaskPriority = _priorities?.first;
    notifyListeners();
  }
bool validate(){
    return ((_taskId!=null)&&(_subtaskName!=null)&&(_selectedSubtaskPriority!=null)
        &&(_selectedUsers.isNotEmpty));
}
  Future<void> createSubtask(BuildContext context) async {
    if(!validate()) return;
    Map<String, dynamic> params = {};

    params['task_id'] = _taskId;
    params['title'] = _subtaskName;
    params['priority_id'] = _selectedSubtaskPriority['id'];
    params['complete_status'] = _selectedSubtaskStatus['id'];
    List<dynamic> users = _selectedUsers.map(
            (user) => user['id']).toList();
    for(int i=0;i<users.length;i++){
      params.addAll({'users[$i]':users[i]});
    }
    final response = await Api().createSubtask(params);

    reset();
    Navigator.pop(context);
  }


  Future<void> reset(){
    _selectedUsers=[];
    _subtaskName=null;
  }

  List<Map<String, dynamic>> get users => _taskUsers;

  Map<String, dynamic> get selectedSubtaskStatus => _selectedSubtaskStatus;

  Map<String, dynamic> get selectedSubtaskPriority => _selectedSubtaskPriority;

  List<Map<String, dynamic>> get priorities => _priorities;


  String get subtaskName => _subtaskName;

  List<Map<String, dynamic>> get selectedUsers => _selectedUsers;

  set users(List<Map<String, dynamic>> value) {
    _taskUsers = value;
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


  set selectedUsers(List<Map<String, dynamic>> value) {
    _selectedUsers = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get taskUsers => _taskUsers;

  List<Map<String, dynamic>> get subtasksStatuses => _subtasksStatuses;
}
