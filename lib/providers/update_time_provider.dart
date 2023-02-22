import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mintness/models/api_responses/timesheet_response.dart';
import 'package:mintness/repositories/api.dart';
import 'dart:async';

class UpdateTimeProvider extends ChangeNotifier {
  List<Map<String,dynamic>> _projects;
  List<String> _listShortcuts = ['+15m', '+30m', '+45m', '+1h', '+2h'];
  List<Map<String,dynamic>> _tasksOfProject;

  Map<String,dynamic> _selectedProject;
  Map<String,dynamic> _selectedTask;
  String _selectedStartTime;
  String _selectedShortcut;
  String _selectedEndTime;
  DateTime _selectedDate = DateTime.now();
  String _description;
  int _timesheetId;
  TimesheetResponse _timesheetResponse;

  bool get isInited => _projects != null;

  Future<void> init(int timesheetId) async {
    await loadTimesheet(timesheetId);
    await  loadProjects() ;
    loadTasksOfProject(_selectedProject['id']);
    notifyListeners();
  }

  Future<bool> loadTimesheet(int timesheetId)async{
    _timesheetResponse=  await Api().loadTimesheet(timesheetId);
    _description = _timesheetResponse?.timesheet?.timesheet?.description;
    _selectedStartTime = _timesheetResponse?.timesheet?.timesheet?.start;
    _selectedEndTime = _timesheetResponse?.timesheet?.timesheet?.end ;
   _timesheetId = _timesheetResponse?.timesheet?.timesheet?.id;
    _selectedDate =  DateTime.now();
  }

  Future<void> loadProjects() async {
    final response = await Api().loadProjects();
    _projects = response?.projects?.projects?.map((project) => project.toJson())?.toList();
    _selectedProject  = _projects.firstWhere((element) => element['id']==_timesheetResponse?.timesheet?.timesheet?.projectId,orElse: ()=>null) ;
    notifyListeners();
  }

  Future<void> loadTasksOfProject(int projectId) async {
    final response = await Api().loadTasksOfProject(projectId);
    _tasksOfProject = response?.tasks?.tasks?.map((task) => task.toJson())?.toList();
    _selectedTask  = _tasksOfProject.firstWhere((element) => element['id']==_timesheetResponse?.timesheet?.timesheet?.taskId,orElse: ()=>_tasksOfProject.first);
    notifyListeners();
  }

 bool validate(){
   if((_description==null)||(_description.isEmpty)){
      return false;
    } else return true;


  }



 Future<bool> updateTime() async {
  bool success =   await Api().updateTime(
      timeSheetId: _timesheetId,
      project_id: _selectedProject['id'],
      task_id: _selectedTask['id'],
      start: selectedStartDateTime,
      end: selectedEndDateTime,
      description: _description,
    );
   if(success) reset();
    return success;
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
      loadTasksOfProject(value['id']);
  }

  void reset() {
    _selectedProject = null;
    _selectedTask = null;
    _projects = [];
    _selectedDate = null;
    _selectedStartTime = null;
    _selectedEndTime = null;
    _description = null;
  }

  set selectedTask(Map<String,dynamic> value) {
    _selectedTask = value;
    notifyListeners();
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
    if (_selectedStartTime != null)  // 12/29/2021 5:44 AM
      return DateFormat('MM/dd/yyyy').format(_selectedDate) +
          ' ' +
          selectedStartTime ;
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
    else
      return null;
  }

  String get selectedEndTime {
    if (_selectedEndTime != null)
      return DateFormat.jm()
          .format(DateFormat("hh:mm").parse(_selectedEndTime));
    else
      return null;
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

  set listShortcuts(List<String> value) {
    _listShortcuts = value;
  }
}
