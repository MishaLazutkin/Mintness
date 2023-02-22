import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mintness/models/domain/project_timeline.dart';
import 'package:mintness/models/domain/tasks_by_project_id.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/utils/methods.dart';

class ProjectProvider extends ChangeNotifier {
  int _projectId;
  String projectName;
  DateTime _to;

  List<Task> _tasksByProjectId =[];
  List<Map<String, dynamic>> _timeSheets = [];
  List<Map<String, dynamic>> _priorities = [];
  List<Map<String, dynamic>> _files = [];
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _selectedUsers = [];
  Map<String, dynamic> _projectStatus = {};
  Map<String, dynamic> _projectPriority = {};
  List<Timeline> _listTimeline = [];
  List<int> _editedFilesIds=[];
  List<TextEditingController> _listFilesController=[];

  List<Map<String, dynamic>> _listTaskList=[];

  List<Map<String, dynamic>> _listProjectsStatuses;

  Future<void> init(int projectId) async {
    await loadProject(projectId);
    notifyListeners();
  }

  bool isInited() {
    return (_tasksByProjectId.isNotEmpty) &&
        (_listTimeline.isNotEmpty) &&
        (_listTaskList.isNotEmpty)

    ;
  }

  Future<void> loadProject(int projectId) async {
    final projectResponse = await Api().loadProjectById(project_id: projectId);
    final tasksResponse = await Api().loadTasksByProjectId(projectId);
    _tasksByProjectId = tasksResponse?.tasksByProjectId?.tasks;
    _to = projectResponse?.project?.endDate;
    projectId = projectResponse?.project?.id;
    projectName = projectResponse?.project?.name;
    _projectId = projectResponse?.project?.id;
    _projectStatus = {
      'color': projectResponse?.project?.status?.color,
      'name': projectResponse?.project?.status?.name
    };
    _projectPriority = {
      'id': projectResponse?.project?.priority?.id,
      'name': projectResponse?.project?.priority?.name,
      'icon': projectResponse?.project?.priority?.icon,
    };
    _selectedUsers = projectResponse?.project?.users
        ?.map((user) => user.toJson())
        ?.toList();

    loadTimesheets(projectId);
    loadTaskListsOfProject(projectId);
    loadProjectsStatuses();
    loadPriorities();
    loadUsers( );
    loadFiles(projectId );
    await loadTimeline(projectId);
  }

  Future<void> loadTimesheets(int projectId) async {
    final response = await Api().loadProjectTimesheets(projectId);
    List<dynamic> list = response?.projectTimesheets?.timesheets ?? [];
    for (var v in list) {
      _timeSheets.add({
        'id':v.id,
        'taskname':
            _tasksByProjectId.firstWhere((task) => task.id == v.taskId,
                orElse: () => null )?.title??'Task name',
        'formattedduration': v.formattedDuration,
        'duration': v.duration,
        'description': v.description,
        'from': v.start,
        'to': v.end,
        'date': v.date,
        'userId': v.userId,
      });
    }
  }

  Future<void> loadTimeline(int projectId) async {
    final response = await Api().loadProjectTimeline(projectId);
    _listTimeline = response?.timeline?.timeline??[];
    notifyListeners();
  }

  Future<void> loadPriorities() async {
    final response = await Api().loadPriorities();
    _priorities = response?.priorities?.priorities?.map((priority) =>
    {'id':priority.id,'name': priority.name,'icon':priority.icon})?.toList();
    notifyListeners();
  }

  Future<void> loadFiles(int projectId) async {
    final response = await Api().loadFiles({'relation_type':'projects','relation_id':projectId});
    _files = response?.files?.files?.map((file) => file.toJson())?.toList();
    _listFilesController=_files.map((file) => TextEditingController(text: file['name'])).toList();
    notifyListeners();
  }

 Future<Map<String,dynamic>>  getFile(int fileId) async {
    final response = await Api().getFile(fileId );
    Map<String,dynamic> file =  response.file.toJson() ;
    notifyListeners();
    return file ;
  }

  Future<void> renameFile(int fileId,String newName) async {
    await Api().renameFile(fileId,newName);
    this.init(_projectId);
  }

  Future<void> deleteFile(int fileId) async {
    await Api().deleteFile(fileId);
    this.init(_projectId);
  }

  Future<void> loadUsers() async {
    final response = await Api().loadUsers( );
    _users = response?.users
        ?.map((user) => user.toJson())?.toList();
    notifyListeners();
  }

  Future<void> loadProjectsStatuses() async {
    final response = await Api().loadProjectsStatuses();
    _listProjectsStatuses = response?.projectStatuses?.statuses
        ?.map((status) => {
              "id": status.id,
              "name": status.name,
              "color": status.color,
              "order": status.order
            })
        ?.toList();
    notifyListeners();
  }

  Future<void> updateProject(Map<String, dynamic> params) async {
    await Api().updateProject(_projectId, params);
    await loadProject(_projectId);
    notifyListeners();
  }

  Future<void> deleteProject() async {
    final response = await Api().deleteProject(_projectId);
    toast('${response?.deleteProject?.message??'Error'}',type: getType(response?.deleteProject?.status??null));
    notifyListeners();
  }

  Future<void> loadTaskListsOfProject(int projectId) async {
    final response = await Api().loadTaskListsOfProject(projectId);
    _listTaskList = response?.tasksList?.lists
        ?.map((tasklist) => {
              "id": tasklist.id,
              "project_id": tasklist.projectId,
              "name": "${tasklist.name}",
              "color": "${tasklist.color}"
            })
        ?.toList();
    notifyListeners();
  }

  Future<void> deleteTask(int taskId, int projectId) async {
    final response = await Api().deleteTask(taskId);
    loadProject(projectId);
    notifyListeners();
  }

  Future<void> deleteTimesheet(int timesheetId, int projectId ) async {
    final response = await Api().deleteTimesheet(timesheetId);
    loadProject(projectId);
    notifyListeners();
  }

  Map<String, dynamic> taskList(int tasklist_id) {

    return _listTaskList
        .firstWhere((tasklist) => tasklist['id'] == tasklist_id,orElse: () => null);

  }

  void reset() {
    _timeSheets = [];
    _tasksByProjectId = [];
    _to = null;
    _files = [];
  }



  String get to {
    if (_to != null)
      return DateFormat('MM.dd.yyyy').format(_to);
    else
      return '';
  }

  String timeSheetDateFrom(String value) {
   if(DateTime.now().toString().split(' ')[0] == DateFormat('yyyy-MM-dd').format(DateFormat().add_yMd().parse(value)))
    return 'Today';
     else return DateFormat('yMMMMd').format(DateFormat("yyyy-MM-dd").parse(reformatString(value)));

  }

  List<Task> get tasksByProjectId => _tasksByProjectId;

  set tasksByProjectId(List<Task> value) {
    _tasksByProjectId = value;
  }

  List<Map<String, dynamic>> get timeSheets => _timeSheets;

  set timeSheets(List<Map<String, dynamic>> value) {
    _timeSheets = value;
  }

    List<Map<String, dynamic>> get fileList => _files;



  set fileList(List<Map<String, dynamic>> value) {
    _files = value;
  }

  List<Map<String, dynamic>> get selectedUsers => _selectedUsers;

  set selectedUsers(List<Map<String, dynamic>> value) {
    _selectedUsers = value;
  }

  List<Map<String, dynamic>> get listTaskList => _listTaskList;

  List<Timeline> get listTimeline => _listTimeline;

  List<Map<String, dynamic>> get listProjectsStatuses => _listProjectsStatuses;

  int get projectId => _projectId;

  Map<String, dynamic> get projectPriority => _projectPriority;

  Map<String, dynamic> get projectStatus => _projectStatus;

  List<Map<String, dynamic>> get priorities => _priorities;

  List<Map<String, dynamic>> get users => _users;

  List<int> get editedFilesIds => _editedFilesIds;

  set editedFilesIds(List<int> value) {
    _editedFilesIds = value;
  }

  List<TextEditingController> get listFilesController => _listFilesController;

  set listFilesController(List<TextEditingController> value) {
    _listFilesController = value;
  }
}
