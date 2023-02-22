import 'package:flutter/material.dart';
import 'package:mintness/models/domain/tasks.dart';
import 'package:mintness/repositories/api.dart';

class HomeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _projectsStatuses = [];
  List<Map<String, dynamic>> _projects = [];
  List<Map<String, dynamic>> _users = [];


  List<Map<String, dynamic>> _listProjects = [];
  List<Map<String, dynamic>> _listDueDate = [];
  List<Map<String, dynamic>> _listPriority = [];
  List<int> _projectStatusesFilterIds = [];
  List<int> _duedateStatusesFilterIds = [];
  List<int> _priorityStatusesFilterIds = [];
  String _searchedTextProjects = '';
  String _searchedTextDueDate = '';
  String _searchedTextPriority = '';

  List<Map<String, dynamic>> get listProjects => _listProjects;

  List<Map<String, dynamic>> get projectsStatuses => _projectsStatuses;

  List<Map<String, dynamic>> get projects => _projects;

  List<Map<String, dynamic>> get users => _users;

  Future<void> init() async {
    await Future.wait(<Future<void>>[_loadProjects(), _loadProjectsStatuses(),_loadUsers()]);
    notifyListeners();
  }

 Future<void> _loadProjects() async {
    final projects = await Api().loadProjects();
    _projects = projects?.projects?.projects
        ?.map((project) => project.toJson())
        ?.toList();
    _listProjects =List.from( _projects);
    _listDueDate = List.from( _projects);
    _listPriority = List.from( _projects);
    notifyListeners();
  }


  Future<void> _loadUsers() async {
    final users = await Api().loadUsers();
    _users = users?.users
        ?.map((user) => user.toJson())
        ?.toList();
    notifyListeners();
  }

  Future<void> _loadProjectsStatuses() async {
    final statuses = await Api().loadProjectsStatuses();
    _projectsStatuses = statuses?.projectStatuses?.statuses
        ?.map((status) => status.toJson())
        ?.toList();
    notifyListeners();
  }

  Future<void> searchData(String searchText, int _currentTabIndex ) {
    if (_currentTabIndex == 0)
      searchProjectsData(searchText );
   else if (_currentTabIndex == 1)
      searchDueDatesData(searchText );
    else if (_currentTabIndex == 2)
      searchPriorityData(searchText );
  }

  Future<void> searchProjectsData(String searchString, {int statusId}) {
    _listProjects =List.from( _projects);
    List<Map<String, dynamic>> resultList = [];
    _listProjects.map((project) {
      if (project['name'].toLowerCase().contains(searchString.toLowerCase()))
        resultList.add(project);
      List<Map<String, dynamic>> tempList = [];
      if (_projectStatusesFilterIds.isNotEmpty ) {
        for (int i = 0; i < _projectStatusesFilterIds.length; i++) {
          tempList.addAll(resultList
              .where((element) => element['status']['id'] == _projectStatusesFilterIds[i]));
        }

        _listProjects =List.from( tempList);


      } else
      _listProjects =List.from( resultList);
    }).toList();
    _listDueDate = List.from( _projects);
    _listPriority = List.from( _projects);
    notifyListeners();
  }

  Future<void> searchDueDatesData(String searchString, {int statusId}) {
    _listDueDate =List.from( _projects);

    List<Map<String, dynamic>> resultList = [];
    _listDueDate.map((project) {
      if (project['name'].toLowerCase().contains(searchString.toLowerCase()))
        resultList.add(project);
      List<Map<String, dynamic>> tempList = [];
      if (_duedateStatusesFilterIds.isNotEmpty ) {
        for (int i = 0; i < _duedateStatusesFilterIds.length; i++) {
          tempList.addAll(resultList
              .where((element) => element['status']['id'] == _duedateStatusesFilterIds[i]));
        }
        _listDueDate =List.from( tempList);
      } else
      _listDueDate =List.from( resultList);
    }).toList();


    _listProjects =List.from( _projects);
    _listPriority = List.from( _projects);
    notifyListeners();
  }

  Future<void> searchPriorityData(String searchString, {int statusId}) {
    _listPriority =List.from( _projects);
    List<Map<String, dynamic>> resultList = [];
    _listPriority.map((project) {
      if (project['name'].toLowerCase().contains(searchString.toLowerCase()))
        resultList.add(project);
      List<Map<String, dynamic>> tempList = [];
      if (_priorityStatusesFilterIds.isNotEmpty ) {
        for (int i = 0; i < _priorityStatusesFilterIds.length; i++) {
          tempList.addAll(resultList
              .where((element) => element['status']['id'] == _priorityStatusesFilterIds[i]));
        }
        _listPriority =List.from( tempList);
      } else
      _listPriority =List.from( resultList);

    }).toList();
    _listProjects = List.from(_projects);
    _listDueDate = List.from(_projects);
    notifyListeners();
  }

  void reset() {
    _projectsStatuses = [];
    _projects = [];
    _listProjects = [];
    _listDueDate = [];
    _listPriority = [];
    _searchedTextProjects = '';
    _searchedTextDueDate = '';
    _searchedTextPriority = '';
  }

  DateTime stringToDate(String text) {
    return DateTime.parse(text.split('/')[2] +
        '-' +
        text.split('/')[0] +
        '-' +
        text.split('/')[1]);
  }

  List<Map<String, dynamic>> get listDueDate => _listDueDate;

  List<Map<String, dynamic>> get listPriority => _listPriority;

  String get searchedTextDueDate => _searchedTextDueDate;

  set searchedTextDueDate(String value) {
    _searchedTextDueDate = value;
  }


  set listProjects(List<Map<String, dynamic>> value) {
    _listProjects = List.from(value);
  }

  String get searchedTextPriority => _searchedTextPriority;

  set searchedTextPriority(String value) {
    _searchedTextPriority = value;
  }

  String get searchedTextProjects => _searchedTextProjects;

  set searchedTextProjects(String value) {
    _searchedTextProjects = value;
  }

  List<int> get priorityStatusesFilterIds => _priorityStatusesFilterIds;

  set priorityStatusesFilterIds(List<int> value) {
    _priorityStatusesFilterIds = value;
  }

  List<int> get duedateStatusesFilterIds => _duedateStatusesFilterIds;

  set duedateStatusesFilterIds(List<int> value) {
    _duedateStatusesFilterIds = value;
  }

  List<int> get projectStatusesFilterIds => _projectStatusesFilterIds;

  set projectStatusesFilterIds(List<int> value) {
    _projectStatusesFilterIds = value;
  }
}

class ProjectTabModel {
  String projectName;
  List<Task> tasks;

  ProjectTabModel(this.projectName, this.tasks);
}

class TaskModel {
  String dueDate;
  List<Task> tasks;

  TaskModel(this.dueDate, this.tasks);

  @override
  String toString() {
    return 'DueDateTask{dueDate: $dueDate, tasks: $tasks}';
  }
}
