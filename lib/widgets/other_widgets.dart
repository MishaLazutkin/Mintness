import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mintness/packages/flutter_user_profile_avatar/lib/user_profile_avatar.dart';
import 'package:mintness/repositories/api.dart';
import '../packages/flutter_user_profile_avatar/lib/user_profile_avatar.dart';
import '../style.dart';

Widget logo_title(BuildContext context) {
  return Container(
    height: 44,
    alignment: const Alignment(0, 0),
    child: Row(
      children: [
        SvgPicture.asset(
          'lib/assets/icons/logoMark.svg',
          height: 35,
          width: 19.82,
        ),
        SvgPicture.asset(
          'lib/assets/icons/wordmark.svg',
          height: 22.89,
          width: 107.61,
        )
      ],
    ),
  );
}

Widget emptyAppBar() {
  return PreferredSize(
    child: Container(),
    preferredSize: Size(0.0, 0.0),
  );
}

Widget backButton(BuildContext context, {Function onTapFunc}) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: [
      Container(
        //width: 16,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SvgPicture.asset('lib/assets/icons/arrow_back.svg',
            width: 20, height: 20),
      ),
      InkWell(
          onTap: () {
            if (onTapFunc != null) onTapFunc();
            Navigator.pop(context);
          },
          child: Container(
            width: 30,
            height: 30,
          ))
    ],
  );
}

Widget avatar(String avatarUrl, Function onTapFunc, String initials,
    [double height = 30.0, double width = 30.0, double fontSize = 11]) {
  Color color = initials != null
      ? AppColor.usersPalette.firstWhere((element) => element.containsKey(
          initials[0].toUpperCase()))['${initials[0].toUpperCase()}']
      : Colors.red;
  return GestureDetector(
    onTap: () {
      if (onTapFunc != null) onTapFunc();
    },
    child: Stack(
      children: [
        Center(
          child: UserProfileAvatar(
            avatarUrl: avatarUrl,
            avatarSplashColor: color,
            radius: height,
            initials:initials,
            fontSize: fontSize,
            avatarBorderData: AvatarBorderData(
              borderColor: Colors.black54,
            ),
            onAvatarTap: onTapFunc,
          ),
        ),
        // ClipOval(
        //   child: Container(
        //     height: height,
        //     width: width,
        //     child: avatarUrl == null
        //         ? Center(
        //             child: Container(
        //               height: height,
        //               width: width,
        //               child: Center(
        //                   child: Text(
        //                 '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
        //                 style:
        //                     TextStyle(color: Colors.white, fontSize: fontSize),
        //               )),
        //               decoration: BoxDecoration(
        //                   color: color,
        //                   borderRadius: BorderRadius.all(Radius.circular(18))),
        //             ),
        //           )
        //         : CachedNetworkImage(
        //             imageUrl: avatarUrl,
        //             imageBuilder: (context, imageProvider) {
        //               return Container(
        //                 decoration: BoxDecoration(
        //                   image: DecorationImage(
        //                     image: imageProvider,
        //                     fit: BoxFit.cover,
        //                   ),
        //                 ),
        //               );
        //             },
        //             placeholder: (context, url) {
        //               return Center(
        //                 child: Container(
        //                   height: height,
        //                   width: width,
        //                   child: Center(
        //                       child: Text(
        //                     '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
        //                     style: TextStyle(color: Colors.white, fontSize: 11),
        //                   )),
        //                   decoration: BoxDecoration(
        //                       color: color,
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(18))),
        //                 ),
        //               );
        //             },
        //             errorWidget: (context, url, error) {
        //               return Center(
        //                 child: Container(
        //                   height: 30,
        //                   width: 30,
        //                   child: Center(
        //                       child: Text(
        //                     '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
        //                     style: TextStyle(color: Colors.white, fontSize: 11),
        //                   )),
        //                   decoration: BoxDecoration(
        //                       color: color,
        //                       borderRadius:
        //                           BorderRadius.all(Radius.circular(18))),
        //                 ),
        //               );
        //             },
        //           ),
        //   ),
        // ),

      ],
    ),
  );
}

Widget userAvatar(String avatarUrl, Function onTapFunc, String initials,
    [double height = 35.0, double width = 35.0]) {
  Color color = AppColor.usersPalette.firstWhere(
      (element) => element.containsKey(initials[0]))['${initials[0]}'];
  return GestureDetector(
    onTap: () {
      if (onTapFunc != null) onTapFunc();
    },
    child: ClipOval(
      child: Container(
        height: height,
        width: width,
        child: avatarUrl == null
            ? Center(
                child: Container(
                  height: height,
                  width: width,
                  child: Center(
                      child: Text(
                    '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  )),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(18))),
                ),
              )
            : CachedNetworkImage(
                imageUrl: avatarUrl,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) {
                  return Center(
                    child: Container(
                      height: height,
                      width: width,
                      child: Center(
                          child: Text(
                        '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Center(
                    child: Container(
                      height: height,
                      width: width,
                      child: Center(
                          child: Text(
                        '${initials.split(' ')[0][0].toUpperCase()}${initials.split(' ')[1][0].toUpperCase()}',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      )),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                    ),
                  );
                },
              ),
      ),
    ),
  );
}

class LogoClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.arcToPoint(Offset(size.width / 20, size.height - 20),
        radius: Radius.circular(30));
    path.lineTo(size.width - 20, size.height - 20);
    path.arcToPoint(Offset(size.width, size.height),
        radius: Radius.circular(30));
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget priorityImage({
  String imageUrl,
}) {
  if (imageUrl == null) return Container();
  return ClipOval(
    child: Container(
        height: 20,
        width: 20,
        child: Center(
          child: SvgPicture.network(
              '${Api.scheme}://${Api.IMAGES_DOMAIN}${imageUrl}'),
        )),
  );
}

Widget fileIcon({
  String imageUrl,
}) {
  print('imageUrl ${imageUrl}');
  if (imageUrl == null) return Container();
  return Container(
      height: 20,
      width: 20,
      child: Center(
          child: Image.network(
        imageUrl,
      )));
}

Widget webIcon(String avatarUrl) {
  return ClipOval(
    child: Container(
      height: 40,
      width: 40,
      child: avatarUrl == null
          ? Center(
              child: SvgPicture.asset('lib/assets/icons/priority_green.svg'),
            )
          : CachedNetworkImage(
              imageUrl: avatarUrl,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (context, url) {
                return Center(
                  child: SvgPicture.asset('lib/assets/icons/profile_2.svg'),
                );
              },
              errorWidget: (context, url, error) {
                return Center(
                  child:
                      SvgPicture.asset('lib/assets/icons/priority_green.svg'),
                );
              },
            ),
    ),
  );
}
