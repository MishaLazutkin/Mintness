import 'package:flutter/material.dart';
import 'package:mintness/models/domain/photo.dart';
import 'package:mintness/models/domain/recent_tasks.dart';
import 'package:mintness/models/domain/task.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/repositories/local_storage.dart';
import 'package:mintness/utils/choose_image.dart';

class RecentTaskProvider extends ChangeNotifier {
  RecentTasks _recentTasks;

  RecentTasks get recentTasks => _recentTasks;


  bool get isInited => _recentTasks != null;

  Future<void> init(int userId) async {
    await loadRecentTasks(userId );
    notifyListeners();
  }

  loadRecentTasks(int userId ) async {
    final response = await Api().loadRecentTasks(userId);
    _recentTasks = response?.recentTasks;
  }

  void reset() {
    _recentTasks = null;
  }
}
