import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/utils/methods.dart';
import 'package:http/http.dart' as http;

import 'package:mintness/models/domain/user.dart';

import '../style.dart';

class ProfileProvider extends ChangeNotifier {
  File   _selectedImageFile;
  String _imageUrl;
  List<PlatformFile> _paths;
  List<File> _images;
  List<int> _imageByteList = [];
  String _avatarUrl;
  String _fullName;
  String _phone;
  String _email;
  List<Map<String,dynamic>> _userStatuses=[null];
  Map<String,dynamic> _selectedStatus;

  String _dob;
  String _statusUntil;
  String _position;
  String _lastSeen;
  int _userId;
  int _userRoleId;

  String get avatarUrl => _avatarUrl;

  String get fullName => _fullName;

  String get phone => _phone;

  String get email => _email;

  String get dob => _dob;

  String get position => _position;

  String get status_until => _statusUntil;

  int get userId => _userId;

  int get userRoleId => _userRoleId;

  String get imageUrl => _imageUrl;

  List<PlatformFile> get paths => _paths;

  List<File> get images => _images;

  List<int> get imageByteList => _imageByteList;

  String get statusUntil => _statusUntil;

  String get lastSeen => _lastSeen;

  set selectedStatus(Map<String, dynamic> value) {
    _selectedStatus = value;
    notifyListeners();

  }

  Map<String, dynamic> get selectedStatus => _selectedStatus;

  List<Map<String, dynamic>> get userStatuses => _userStatuses;

  File   get selectedImageFile => _selectedImageFile;

  set selectedImageFile(File file) {
    _selectedImageFile = file;
    notifyListeners();
  }

  set imageUrl(String value) {
    _imageUrl = value;
  }

  set paths(List<PlatformFile> value) {
    _paths = value;
  }

  set images(List<File> value) {
    _images = value;
  }

  Future<void> uploadAvatar(File file) async {
    if (file  == null) return;
    try {
      final isSuccessful = await Api().uploadAvatar(file);
      toast('${isSuccessful ? 'User information has been updated.' : 'Error'}',
          type: isSuccessful ? ToastTypes.success : ToastTypes.error);
      if (isSuccessful) await _loadProfile();
    } catch (error, stackTrace) {
      print('ProfileProvider _uploadAvatar ERROR');
    } finally {}
    notifyListeners();
  }

  //
  // Future<void> setAvatarViaGallery() async {
  //   final chosenImage = await chooseImage(camera: false);
  //   if (chosenImage != null) await _uploadAvatar(chosenImage);
  // }
  //
  // Future<void> setAvatarViaCamera() async {
  //   final chosenImage = await chooseImage(camera: true);
  //   if (chosenImage != null) await _uploadAvatar(chosenImage);
  // }

  Future<void> deleteAvatar() async {
    try {
      final isSuccessful = await Api().deleteAvatar();
      if (isSuccessful) await _loadProfile();
    } catch (error, stackTrace) {
      print('ProfileProvider deleteAvatar ERROR');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadProfile() async {
    final response = await Api().loadProfile();
    _avatarUrl = response?.profile?.user?.avatar;
    _fullName = response?.profile?.user?.name;
    _phone = response?.profile?.user?.phone;
    _email = response?.profile?.user?.email;
    _userStatuses = response?.profile?.statusList?.map((status) => status.toJson())?.toList();
    _selectedStatus =_userStatuses.firstWhere((element) => element['id']==response?.profile?.user?.status?.toJson()['id']);
    _dob = response?.profile?.user?.dob;
    _userId = response?.profile?.user?.id;
    _userRoleId = response?.profile?.user?.roleId;
    _position = response?.profile?.user?.position;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> params) async {
    final response = await Api().updateProfile(_userId, params);
    init();
  }

  Future<void> updateProfileStatus(int status_id) async {
    final response = await Api().updateProfileStatus(status_id);
  }




  Future<void> init() async {
    await _loadProfile();
    _storeUserData();
    notifyListeners();
  }

  _storeUserData() async {
    User user = User();
    user.name = _fullName;
    user.position = _position;
    user.avatarUrl = _avatarUrl;
    LocalStorage().storeUserData(_email, user);
  }

  Future<DateTime> openDatePicker(
      BuildContext context, DateTime initialDate) async {
    DateTime temp;
    temp = await showPickerDate(context, initialDate);
    return temp;
  }

  Future<DateTime> showPickerDate(context, DateTime initialDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate:   DateTime.now().subtract(Duration(days: 20000)),
      lastDate: DateTime.now().add(const Duration(days: 500)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: AppColor.primary,
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );
    return picked;
  }

}
