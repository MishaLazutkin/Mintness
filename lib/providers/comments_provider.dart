import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintness/models/api_responses/sended_comment_response.dart';
import 'package:mintness/models/domain/photo.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/utils/choose_image.dart';
import 'package:mintness/utils/methods.dart';

class CommentsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _comments;

  List<Photo> _chosenCommentImages = <Photo>[];
  List<File> _chosenCommentFiles = [];
  int _limit = 3;

  List get comments => _comments;

  bool get isInited => _comments != null;

  Future<void> init(int task_id) async {
    await loadComments(task_id);
    notifyListeners();
  }

  Future<void> loadComments(int task_id) async {
    final response = await Api().loadComments(task_id: task_id);
    _comments =
        response?.comments?.comments?.map((note) => note.toJson())?.toList();
    notifyListeners();
  }

  Future<void> sendComment({String commentText, int taskId}) async {
    SendedCommentResponse response = await Api().sendComment(
      text: commentText,
      task_id: taskId,
    );

    if (response?.sendedComment?.status == 'success') {
      if (_chosenCommentImages.isNotEmpty && _chosenCommentFiles.isNotEmpty) {
        await Future.wait([
          Api().attachPhotos(_chosenCommentImages, 'task_comments',
              response.sendedComment.comment.id),
          Api().attachFiles(_chosenCommentFiles, 'task_comments',
              response.sendedComment.comment.id)
        ]).then((List<dynamic> resultList) {
          _chosenCommentImages = <Photo>[];
          _chosenCommentFiles = <File>[];
        });
      } else if (_chosenCommentImages.isNotEmpty) {
        await Api().attachPhotos(_chosenCommentImages, 'task_comments',
            response.sendedComment.comment.id);
        _chosenCommentImages = <Photo>[];
      } else if (_chosenCommentFiles.isNotEmpty) {
        await Api().attachFiles(_chosenCommentFiles, 'task_comments',
            response.sendedComment.comment.id);
        _chosenCommentFiles = <File>[];
      }
    }
  }

  Future<void> chooseCommentImages( ) async {
    if(limit<1) return;
    try {

      final images = await chooseImages(limit: limit, quality: 80);

      if ((images ?? []).isNotEmpty) {
        _chosenCommentImages.addAll(images);
      }
    } catch (exception, stackTrace) {
      print(exception);
    }
    notifyListeners();
  }

  Future<void> chooseCommentFiles() async {
    if(limit<1) return;
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      if(limit < result.files.length) {
        result.files.removeRange(0, result.files.length-limit);
      }
      if (result != null) {
        for (int i = 0; i < result.files.length; i++) {
          double size = result.files[i].size / 1024 / 1024;
          if (size >= 15) {
            toast('The size of file you are uploading must be under 15 MB.',
                type: ToastTypes.error);
            return;
          }
        }
        _chosenCommentFiles =[..._chosenCommentFiles, ...result.paths.map((path) => File(path)).toList()]  ;

      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
  }


  bool isEmptyComment(String commentText){
    return _chosenCommentFiles.isEmpty&&_chosenCommentImages.isEmpty&&commentText.isEmpty;
  }

  void reset() {
    _comments = null;
    _chosenCommentFiles = [];
    _chosenCommentImages = [];
    notifyListeners();
  }

  get chosenCommentImages => _chosenCommentImages;

  List<File> get chosenCommentFiles => _chosenCommentFiles;

  int get limit {
    var newLimit =
        _limit - _chosenCommentFiles.length - _chosenCommentImages.length;
    if (newLimit <= 0)
      return 0;
    else
      return newLimit;
  }
}
