import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mintness/models/domain/projects.dart' as Projects;
import 'package:mintness/models/domain/task.dart' as TaskClass;
import 'package:mintness/repositories/api.dart';
import 'package:mintness/utils/methods.dart';
import 'dart:async';

class AddTimeProvider extends ChangeNotifier {
  final List<String> _listShortcuts = ['+15m', '+30m', '+45m', '+1h', '+2h'];
  List<Map<String,dynamic>> _tasksOfProject;
  List<Map<String,dynamic>> _projects;

  Map<String,dynamic> _selectedProject;
  Map<String,dynamic> _selectedTask;
  String _selectedStartTime;
  String _selectedShortcut;
  String _selectedEndTime;
  DateTime _selectedDate ;
  String _description;
  bool get isInited => _projects != null;

  Future<void> init() async {
    await loadProjects();
    notifyListeners();
  }

 bool validate(){
   if((_selectedStartTime==null)||(_selectedEndTime==null)||
        (_selectedProject['id'] ==-1)||(_selectedTask['id']==-1)||
        (_selectedDate==null)||(_description==null)||(_description.isEmpty)){

      return false;
    }

   double _doubleStartTime =
       double.parse( selectedStartTime.split(':')[0]) +
           double.parse( selectedStartTime.split(':')[1].split(' ')[0]) / 60;

   double _doubleEndTime =  double.parse(selectedEndTime.split(':')[0]) +
       double.parse(selectedEndTime.split(':')[1].split(' ')[0]) / 60;

   if((_doubleEndTime - _doubleStartTime)<=0) {
     return false;
   }else return true;

  }

  loadProjects() async {
    final response = await Api().loadProjects();
    _projects = response?.projects?.projects?.map((project) => project.toJson())?.toList();
    _selectedProject  = _projects.first;
    loadTasksOfProject(_selectedProject['id']);
    notifyListeners();
  }

  loadTasksOfProject(int project_id) async {
    final response = await Api().loadTasksOfProject(project_id);
    _tasksOfProject = response?.tasks?.tasks?.map((task) =>
    task.toJson())?.toList();
    _selectedTask = _tasksOfProject.first;
    _selectedDate = DateTime.now();
    notifyListeners();
  }


  addTime( ) async {

    final response = await Api().addTime(

      project_id: _selectedProject['id'],
      task_id: _selectedTask['id'],
      start: selectedStartDateTime,
      end: selectedEndDateTime,
      description: _description,
    );
    toast(response?.addTime?.message??'Error', type: getType(response?.addTime?.status??null));
    notifyListeners();
  }

  List<Map<String,dynamic>> get tasks => _tasksOfProject;

  set tasks(List<Map<String,dynamic>> value) {
    _tasksOfProject = value;
    notifyListeners();
  }

  List<Map<String,dynamic>> get projects => _projects;


  Map<String, dynamic> get selectedProject => _selectedProject;

  set setSelectedProject(Map<String,dynamic> value) {
    _selectedProject = value;
    loadTasksOfProject(_selectedProject['id']);
    notifyListeners();
  }

  void reset() {
    _selectedProject = null;
    _selectedTask = null;
    _projects = [];
    _selectedDate = null;
    _selectedStartTime = null;
    _selectedEndTime = null;
    _description = null;
    notifyListeners();
  }

  set selectedTask(Map<String,dynamic> value) {
    _selectedTask = value;
    validate();
  }

  Map<String,dynamic> get selectedTask => _selectedTask;

  String get description => _description;

  set description(String value) {
    _description = value;
    validate();
    notifyListeners();
  }

  DateTime get selectedDate => _selectedDate;

  String get formattedSelectedDate {
    if (_selectedDate != null)
      return DateFormat('yMMMMd').format(_selectedDate);
  }

  String get selectedStartDateTime {
    if (_selectedStartTime != null)
      return DateFormat('MM/dd/yyyy').format(_selectedDate) +
          ' ' +
          selectedStartTime ; // 12/29/2021 5:44 AM
    else
      return null;
  }

  String get selectedEndDateTime {
    if (_selectedEndTime != null)
      return DateFormat('MM/dd/yyyy').format(_selectedDate) +
          ' ' +
          selectedEndTime ;
    return null;
  }

  String get selectedStartTime {
    if (_selectedStartTime != null)
      return DateFormat.jm()
          .format(DateFormat("hh:mm").parse(_selectedStartTime));
    else {
      selectedStartTime = '${DateTime.now().hour}' + ":" +'${DateTime.now().minute}';
      return DateFormat.jm().format(DateTime.now());
    }
  }

  String get selectedEndTime {
    if (_selectedEndTime != null)
      return DateFormat.jm()
          .format(DateFormat("hh:mm").parse(_selectedEndTime));
    else {
      return DateFormat.jm().format(DateTime.now());

    }
  }

  set selectedProject(Map<String,dynamic> value) {
    _selectedProject = value;
    validate();
    notifyListeners();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    validate();
    notifyListeners();
  }

  set selectedStartTime(String value) {
    _selectedStartTime = value;
    validate();
    notifyListeners();
  }

  set selectedEndTime(String value) {
    _selectedEndTime = value;
    validate();
    notifyListeners();
  }

  List<Map<String,dynamic>> get tasksOfProject => _tasksOfProject;

  set tasksOfProject(List<Map<String,dynamic>> value) {
    _tasksOfProject = value;
    notifyListeners();
  }

  String get selectedShortcut => _selectedShortcut;

  set selectedShortcut(String value) {

    DateTime currentStartDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        int.parse(_selectedStartTime.split(':')[0]),
        int.parse(_selectedStartTime.split(':')[1]));
    //substract previous shortcut
    if(_selectedShortcut!=null) {
      if(currentStartDateTime.subtract(_duration(_selectedShortcut)).isAfter(currentStartDateTime)) {
        currentStartDateTime =
            currentStartDateTime.subtract(_duration(_selectedShortcut));
      }
    }


    _selectedShortcut = value;
    currentStartDateTime= currentStartDateTime.add(
      _duration(_selectedShortcut)
    );

    selectedDate = currentStartDateTime;

    selectedEndTime = '${currentStartDateTime.hour}' + ":" +'${currentStartDateTime.minute}';

    notifyListeners();
  }

  Duration _duration(String _selectedShortcut){
    if(_selectedShortcut=="+15m")
   return Duration(hours: 0, minutes: 15);
    if(_selectedShortcut=="+30m")
   return Duration(hours: 0, minutes: 30);
     if(_selectedShortcut=="+45m")
   return Duration(hours: 0, minutes: 45);
     if(_selectedShortcut=="+1h")
   return Duration(hours: 1, minutes: 0);
     if(_selectedShortcut=="+2h")
   return Duration(hours: 2, minutes: 0);
  }

  List<String> get listShortcuts => _listShortcuts;

}
