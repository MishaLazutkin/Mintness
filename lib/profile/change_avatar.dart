import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mintness/home/home_page.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/utils/methods.dart';
import 'package:mintness/widgets/back_button.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'dart:io';

import 'package:mintness/widgets/other_widgets.dart';
import 'package:provider/provider.dart';

import '../style.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({Key key}) : super(key: key);

  @override
  _ChangeAvatarPageState createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage>
    with FullscreenLoaderMixin<ChangeAvatarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: emptyAppBar(),
        body: _body(),
      ),
      if (showLoader) const FullscreenLoader(),
    ]);
  }

  Widget _body() {
    return Container(
      color: Colors.white,
      child: Consumer<ProfileProvider>(
          builder: (_, ProfileProvider profileProvider, __) {
        return Column(
          children: [
            ClipPath(
              child: Stack(
                children: [
                  Container(
                      color: Colors.white,
                      child: FittedBox(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.3,
                            child: profileProvider.avatarUrl == null
                                ? Center(
                                    child: SvgPicture.asset(
                                        'lib/assets/icons/profile_2.svg'),
                                  )
                                : Image.network(
                                    '${profileProvider.avatarUrl}',
                                    fit: BoxFit.cover,
                                  )),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        AppBackButton(
                            arrowColor: AppColor.primary,
                            backgroundColor: Colors.white),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                ],
              ),
              clipper: LogoClipPath(),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Change Profile Photo',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      await getImageFromGallery(profileProvider);
                      runWithLoader(() async {
                        await profileProvider.uploadAvatar(
                          profileProvider.selectedImageFile,
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.photo_size_select_actual_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await getImageFromCamera(profileProvider);
                      runWithLoader(() async {
                        await profileProvider.uploadAvatar(
                          profileProvider.selectedImageFile,
                        );
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: ()=>
                        runWithLoader( () async {
                          await profileProvider.deleteAvatar();
                        }, ),

                    child: (profileProvider.avatarUrl == null)
                        ? Container()
                        : Row(
                            children: [
                              Icon(CupertinoIcons.delete),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Delete Photo',
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  //
  // void _openFileExplorer() async {
  //   try {
  //     FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: false);
  //     if(result!=null){
  //       _paths = result.files;
  //       //files = result.paths.map((path) => File(path)).toList();
  //     }
  //
  //   } on PlatformException catch (e) {
  //     print("Unsupported operation" + e.toString());
  //   } catch (ex) {
  //     print(ex);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _fileName =
  //     _paths != null ? _paths.map((e) => e.name).toString() : '...';
  //   });
  // }

  Future getImageFromCamera(ProfileProvider profileProvider) async {
    var image;
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    // var status = await Permission.camera.status;
    // print('status $status');
    // print('status.isGranted ${status.isGranted}');
    // // image = await ImagePicker().getImage(source: ImageSource.camera);
    // if (status.isGranted ) {
    //    image = await ImagePicker().getImage(source: ImageSource.camera);
    // }  else if(status.isDenied||status.isPermanentlyDenied) {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) =>
    //           CupertinoAlertDialog(
    //             title: Text('Camera Permission'),
    //             content: Text(
    //                 'This app needs camera access to take pictures for upload user profile photo'),
    //             actions: <Widget>[
    //               CupertinoDialogAction(
    //                 child: Text('Deny'),
    //                 onPressed: () => Navigator.of(context).pop(),
    //               ),
    //               CupertinoDialogAction(
    //                 child: Text('Settings'),
    //                 onPressed: () => openAppSettings(),
    //               ),
    //             ],
    //           ));
    // }

    if (image != null) {
      profileProvider.selectedImageFile = File(image.path);
    } else {}
  }

  Future getImageFromGallery(ProfileProvider profileProvider) async {
    XFile image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      double size = await File(image.path).length() / 1024 / 1024;
      print('size $size');
      if (size >= 15) {
        toast('The size of file you are uploading must be under 15 MB.',
            type: ToastTypes.error);
        return;
      }
      profileProvider.selectedImageFile = File(image.path);
    } else {}
  }
}
