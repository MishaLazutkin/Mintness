import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mintness/models/domain/projects.dart';
import 'package:mintness/models/domain/task.dart' as TaskClass;
import 'package:mintness/models/domain/tasks_of_project.dart';
import 'package:mintness/repositories/api.dart';

class ProjectsProvider extends ChangeNotifier {
  List<Map<String,dynamic>> _projects;
  List<Map<String,dynamic>> _tasksOfProject;
  bool _showLoader = false;
  Map<String,dynamic> _selectedProject;
  Map<String,dynamic> _selectedTask;
  TaskClass.TaskClass _selectedFullDataTask;

  String _description;


  Future<void> init() async {
    _showLoader = true;
    await loadProjects();
    _showLoader = false;
    loadTasksOfProject(_selectedProject['id']);
    notifyListeners();
  }

  Future<void>  loadProjects() async {
    _showLoader = true;
    final response = await Api().loadProjects();
    _showLoader = false;
    _projects = response?.projects?.projects?.map((project) => {'id':project.id,'name':project.name});
    _projects.insert(0,  {'name': 'Select project', 'id': -1} );
    _selectedProject = projects[0];
    notifyListeners();
  }


  Future<void> loadTask(int task_id) async {
    final response = await Api().loadTask(task_id);
    _selectedFullDataTask = response?.task;
  }

  Future<void>  loadTasksOfProject(int project_id) async {
    final response = await Api().loadTasksOfProject(project_id);
    _tasksOfProject = response?.tasks?.tasks.map((task) =>
    {'id':task.id,'name':task.title,'description':task.description}).toList();
    _tasksOfProject.insert(0, {'id': -1, 'name': 'Select Task'});
    _selectedTask = _tasksOfProject.first;
    notifyListeners();
  }


  void reset() {
    _projects = null;
    _tasksOfProject = null;
    _selectedProject = null;
    _selectedTask = null;
    // notifyListeners();
  }
  String get description => _description;

  set description(String value) {
    _description = value;
  }


  TaskClass.TaskClass get selectedFullDataTask => _selectedFullDataTask;

  Map<String,dynamic> get selectedTask => _selectedTask;

  set selectedTask(Map<String,dynamic> value) {
    _selectedTask = value;
    loadTask(_selectedTask['id']); //fetch full data of task
  }

  List<Map<String,dynamic>> get tasks => _tasksOfProject;

  set tasks(List<Map<String,dynamic>> value) {
    _tasksOfProject = value;
  }

  Map<String,dynamic> get selectedProject => _selectedProject;

  set setSelectedProject(Map<String,dynamic> value) {
    _selectedProject = value;
    loadTasksOfProject(value['id']);
  }

  List<Map<String,dynamic>> get projects => _projects;

  bool get showLoader => _showLoader;

  bool get isInited => _projects != null;


}
