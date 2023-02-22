import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mintness/models/domain/photo.dart';
import 'package:mintness/services/flushbar_service.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';


Future<List<Photo>> chooseImages({int limit = 3, int quality = 100}) async {
  print('limit = $limit');

  final images = await MultiImagePicker.pickImages(
    maxImages: limit,
    enableCamera: true,
    materialOptions: const MaterialOptions(autoCloseOnSelectionLimit: true),
    cupertinoOptions: const CupertinoOptions(autoCloseOnSelectionLimit: true),
  );
  if ((images ?? []).isNotEmpty) {
    for (int i = 0; i < images.length; i++) {
      final imageMbSize =
          File(await FlutterAbsolutePath.getAbsolutePath(images[i].identifier))
                  .lengthSync() /
              1000000;
      if (imageMbSize >= 15.0) {
        FlushbarService().showError(
          'Uploaded image size can not be more than 15mb.',
        );
        return [];
      }
    }

    return [
      for (final image in images) await _processedImage(image, quality),
    ];
  } else {
    return [];
  }
}

Future<Photo> chooseImage({
  bool camera = false,
  bool forceUseMultiImagePicker = false,
}) async {
  if (forceUseMultiImagePicker) {
    final images = await MultiImagePicker.pickImages(
      maxImages: 1,
      enableCamera: camera,
      materialOptions: const MaterialOptions(autoCloseOnSelectionLimit: true),
      cupertinoOptions: const CupertinoOptions(autoCloseOnSelectionLimit: true),
    );
    if ((images ?? []).isNotEmpty) {
      final imageMbSize = File(await FlutterAbsolutePath.getAbsolutePath(
                  images.first.identifier))
              .lengthSync() /
          1000000;
      if (imageMbSize < 15.0) {
        return Photo(
          bytes: await _processedImageBytesList(
            (await images.first.getByteData()).buffer.asUint8List(),
          ),
          extension: images.first.name.split('.').last,
          name: images.first.name,
          identifier: images.first.identifier,
        );
      } else {
        FlushbarService().showError(
          'Uploaded image size can not be more than 15mb.',
        );
        return null;
      }
    } else {
      return null;
    }
  } else {
    if (Platform.isIOS) {
      final iosVersion = (await DeviceInfoPlugin().iosInfo).systemVersion;
      if (iosVersion.startsWith('14')) {
        final images = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: camera,
          materialOptions:
              const MaterialOptions(autoCloseOnSelectionLimit: true),
          cupertinoOptions:
              const CupertinoOptions(autoCloseOnSelectionLimit: true),
        );
        if ((images ?? []).isNotEmpty) {
          final imageMbSize = File(await FlutterAbsolutePath.getAbsolutePath(
                      images.first.identifier))
                  .lengthSync() /
              1000000;
          if (imageMbSize < 15.0) {
            return Photo(
              bytes: await _processedImageBytesList(
                (await images.first.getByteData()).buffer.asUint8List(),
              ),
              extension: images.first.name.split('.').last,
              name: images.first.name,
              identifier: images.first.identifier,
            );
          } else {
            FlushbarService().showError(
              'Uploaded image size can not be more than 15mb.',
            );
            return null;
          }
        } else {
          return null;
        }
      }
    }
    final imageFile = await ImagePicker().getImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
    );
    if (imageFile != null) {
      final imageMbSize = File(imageFile.path).lengthSync() / 1000000;
      if (imageMbSize < 15.0) {
        return Photo(
          bytes: await _processedImageBytesList(await imageFile.readAsBytes()),
          extension: imageFile.path.split('.').last,
          name: imageFile.path.split('.').reversed.toList()[1],
        );
      } else {
        FlushbarService().showError(
          'Uploaded image size can not be more than 15mb.',
        );
        return null;
      }
    } else {
      return null;
    }
  }
}

Future<List<int>> _processedImageBytesList(List<int> imageBytes) async {
  return FlutterImageCompress.compressWithList(imageBytes);
}

Future<Photo> _processedImage(Asset image, int quality) async {
  if (image.name.split('.').last.toLowerCase() != 'heic') {
    return Photo(
      bytes: await _processedImageBytesList(
        (await image.getByteData(quality: quality)).buffer.asUint8List(),
      ),
      extension: image.name.split('.').last,
      name: image.name,
      identifier: image.identifier,
    );
  } else {
    final heicPath =
        await FlutterAbsolutePath.getAbsolutePath(image.identifier);
    final jpegPath = await HeicToJpg.convert(heicPath);
    return Photo(
      bytes: await _processedImageBytesList(
        await File(jpegPath).readAsBytes(),
      ),
      extension: 'jpeg',
      name: '${image.name}.jpeg',
      identifier: image.identifier,
    );
  }
}
//
// Future<Photo> _processedAssetImage(Asset image, int quality) async {
//   if (image.name.split('.').last.toLowerCase() != 'heic') {
//     return Photo(
//       bytes: await _processedImageBytesList(
//         (await image.getByteData(quality: quality)).buffer.asUint8List(),
//       ),
//       extension: image.name.split('.').last,
//       name: image.name,
//       identifier: image.identifier,
//     );
//   } else {
//     final heicPath =
//         await FlutterAbsolutePath.getAbsolutePath(image.identifier);
//     final jpegPath = await HeicToJpg.convert(heicPath);
//     return Photo(
//       bytes: await _processedImageBytesList(
//         await File(jpegPath).readAsBytes(),
//       ),
//       extension: 'jpeg',
//       name: '${image.name}.jpeg',
//       identifier: image.identifier,
//     );
//   }
// }
//
