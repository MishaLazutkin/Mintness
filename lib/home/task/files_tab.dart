import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/project_provider.dart';
import 'package:mintness/providers/task_provider.dart';
import 'package:mintness/style.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/accept_decline_dialog.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class FilesTab extends StatefulWidget {
  const FilesTab({Key key, this.idTask}) : super(key: key);
  final idTask;

  @override
  _FilesTabState createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab>
    with FullscreenLoaderMixin<FilesTab> {
  List<_TaskInfo> _tasks;
  List<_ItemHolder> _items = [];
  ReceivePort _port = ReceivePort();
  String _localPath;
  bool _permissionReady;
  bool debug = true;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  void _initProvider() async {
    await runWithLoader(() {
      context.read<TaskProvider>().init(widget.idTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundPageBody,
      key:scaffoldMessengerKey,
      body: Stack(children: [
        Consumer<TaskProvider>(builder: (_, TaskProvider taskProvider, __) {
         return Consumer<ProjectProvider>(builder: (_, ProjectProvider projectProvider, __) {
            return Container(
              child: _buildFilesContent(taskProvider,  projectProvider),
            );
          });
        }),
        if (showLoader) const FullscreenLoader(),
      ]),
    );
  }

  @override
  void initState() {
    Future.microtask(_initProvider);
    super.initState();
    _permissionReady = false;
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Widget _buildFilesContent(TaskProvider taskProvider,ProjectProvider projectProvider) {
    _prepare(taskProvider.files);
    return Container(child: _buildDownloadList(taskProvider,   projectProvider));
  }

  Future<Null> _prepare(List<dynamic> afiles) async {
    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(afiles
        .map((file) => _TaskInfo(name: file['name'], link: file['link'])));

    for (int i = count; i < afiles.length; i++) {
      _items.add(_ItemHolder(
        id: afiles[i]['id'],
        mimeType: afiles[i]['mime_type'],
        name: afiles[i]['name'],
        friendly_size: afiles[i]['friendly_size'],
        task: _tasks[i],
      ));

      count++;
    }

    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    _createLocalPath();

  }

  _createLocalPath() async {
    _permissionReady = await _checkPermission();

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String> _findLocalPath() async {
    var directory;
    if (Platform.isAndroid)
      directory = await (getExternalStorageDirectory() as FutureOr<Directory>);
    else
      directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Widget _buildDownloadList(TaskProvider taskProvider,ProjectProvider projectProvider) => Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: taskProvider?.files?.length,
          itemBuilder: (context, index) {
            if (_items.isEmpty)
              return Container();
            else
              return // _items[index]== null?  _buildListSection(_items[index].name):
                  InkWell(
                child: DownloadItem(
                  taskProvider: taskProvider,
                    projectProvider:   projectProvider,
                  data: _items[index],
                  index: index,
                  onItemClick: (task) {
                    _openDownloadedFile(task).then((success) {
                      if (!success) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Cannot open this file.'),
                          ),
                        );
                      }
                    });
                  },
                  onAtionClick: (task) {
                    if (task.status == DownloadTaskStatus.undefined) {
                      _requestDownload(task);
                    } else if (task.status == DownloadTaskStatus.running) {
                      _pauseDownload(task);
                    } else if (task.status == DownloadTaskStatus.paused) {
                      _resumeDownload(task);
                    } else if (task.status == DownloadTaskStatus.failed) {
                      _retryDownload(task);
                    }
                  },
                ),
              );
          }));

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    if (task != null) {

      return FlutterDownloader.open(taskId: task.taskId);
    } else {
      return Future.value(false);
    }
  }

  Widget _buildListSection(String title) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18.0),
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: const Text('Loading...'),
    //   ),
    // );
    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);

    setState(() {});
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }
}

class DownloadItem extends StatefulWidget {
  final _ItemHolder data;
  final int index;
  final TaskProvider taskProvider;
  final ProjectProvider projectProvider;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;

  DownloadItem(
      {this.data,
      this.onItemClick,
      this.onAtionClick,
      this.taskProvider,
      this.index, this.  projectProvider});

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: InkWell(
        onTap: widget.data.task.status == DownloadTaskStatus.complete
            ? () {
                widget.onItemClick(widget.data.task);
              }
            : null,
        child: Stack(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Container(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            setMymeType(widget.data.mimeType),
                            SizedBox(
                              width: 10,
                            ),
                            widget.taskProvider.editedFilesIds.contains(widget
                                    .taskProvider
                                    ?.task
                                    ?.task
                                    ?.files[widget.index]['id'])
                                ? _fileTextfield(
                                    widget.taskProvider, widget.index)
                                : Expanded(
                                    child: Text(
                                        '${widget.taskProvider?.task?.task?.files[widget.index]['name']}'))
                          ],
                        ),
                      ),
                      widget.taskProvider.editedFilesIds.contains(widget
                              .taskProvider
                              ?.task
                              ?.task
                              ?.files[widget.index]['id'])
                          ? _editFileNameButtons(
                              widget.taskProvider, widget.index)
                          : _popupFileMenu(
                              widget.taskProvider,
                              widget.  projectProvider,
                              widget.taskProvider?.task?.task
                                  ?.files[widget.index])
                    ],
                  ),
                ),
              ),
            ),
            widget.data.task.status == DownloadTaskStatus.running ||
                    widget.data.task.status == DownloadTaskStatus.paused
                ? Positioned(
                    left: 20.0,
                    right: 20.0,
                    bottom: 5.0,
                    child: LinearProgressIndicator(
                      color: Colors.green,
                      backgroundColor: Colors.white,
                      value: widget.data.task.progress / 100,
                    ),
                  )
                : Container()
          ].where((child) => child != null).toList(),
        ),
      ),
    );
  }

  _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
  }

  Widget _buildActionForTask(
      _TaskInfo task, int file_id, BuildContext context) {
    if (task.status == DownloadTaskStatus.undefined) {
      return InkWell(
        onTap: () {
          widget.onAtionClick(task);
          Navigator.of(context).pop( );
        },
        child: Row(
          children: [
            Icon(
              Icons.file_download,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Download"),
          ],
        ),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          widget.onAtionClick(task);
        },
        child: Row(
          children: [
            Icon(
              Icons.pause,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Downloading"),
          ],
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          widget.onAtionClick(task);
        },
        child: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: AppColor.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Resume"),
          ],
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            child: Icon(
              Icons.check_box,
              color: AppColor.backgroundTimerOnHeader,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text("Download"),
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              widget.onAtionClick(task);
            },
            child: Icon(
              Icons.refresh,
              color: Colors.green,
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  Widget _fileTextfield(TaskProvider taskProvider, int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Align(
                  child: TextField(
            controller: taskProvider.filesListController[index],
            decoration: InputDecoration(
              fillColor: AppColor.textFieldFill,
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              counterText: '',
              focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _editFileNameButtons(TaskProvider taskProvider, int index) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: () => setState(() {
                  taskProvider.editedFilesIds
                      .remove(taskProvider?.files[index]['id']);
                }),
            child: Icon(Icons.clear, color: AppColor.error)),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () => setState(() async {
            await taskProvider.renameFile(taskProvider?.files[index]['id'],
                taskProvider.filesListController[index].text);
            taskProvider.editedFilesIds
                .remove(taskProvider?.files[index]['id']);
          }),
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _popupFileMenu(TaskProvider taskProvider,ProjectProvider projectProvider, dynamic file) {
    return Consumer<ProfileProvider>(
        builder: (_, ProfileProvider profileProvider, __)
    {
      return PopupMenuButton<int>(
        child: Container(
          height: 35,
          width: 35,
          child: SvgPicture.asset(
            'lib/assets/icons/more.svg',
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  Container(
                    height: 10,
                    child: Icon(
                      Icons.copy,
                      color: AppColor.primary,
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Copy Link"),
                ],
              ),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            PopupMenuItem(
              value: 2,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    child: Icon(
                      Icons.edit,
                      color: AppColor.primary,
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Rename"),
                ],
              ),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            PopupMenuItem(
              //value: 3,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      children: [
                        _buildActionForTask(
                            widget.data.task, widget.data.id, context),

                      ],
                    );
                  }),
            ),
            PopupMenuDivider(
              height: 10,
            ),
            if (isCurrentUserIsManager(
                profileProvider.userId, projectProvider)&&
                isCurrentUserIsAdmin(profileProvider.userRoleId)) PopupMenuItem(
              value: 4,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    child: Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Delete"),
                ],
              ),
            ),
          ];
          return null;
        },
        onSelected: (value) {
          if (value == 1)
            _copyLink(file['link']);
          else if (value == 2) {
            setState(() {
              taskProvider.editedFilesIds.add(file['id']);
            });
          } else if (value == 3) {} else if (value == 4) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AcceptDeclineAlertDialog(
                      () {
                    taskProvider.deleteFile(file['id']);
                    Navigator.pop(context);
                  },
                  "Delete File",
                  "Are you sure you want to delete this file? This action is irreversible.",
                );
              },
            );
          }
        },
      );
    });
  }
}

enum subtaskType { closed, opened }

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final int id;
  final String thumbnailLink;
  final String friendly_size;
  final String name;
  final String mimeType;
  final String date;
  final _TaskInfo task;

  _ItemHolder(
      {this.id,
      this.mimeType,
      this.name,
      this.task,
      this.thumbnailLink,
      this.friendly_size,
      this.date});
}
