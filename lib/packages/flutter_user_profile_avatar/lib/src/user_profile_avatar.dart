import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mintness/packages/flutter_user_profile_avatar/lib/src/ui_toolkit/activity_Indicator.dart';
import '../user_profile_avatar.dart';
import 'extensions/string_utils.dart';
import 'ui_toolkit/conditional_child.dart';

class UserProfileAvatar extends StatefulWidget {
  final Key  _key;
  final String  _avatarUrl;
  final String  _initials;
  final Function  _onAvatarTap;
  final AvatarBorderData  _avatarBorderData;
  final Color  _avatarSplashColor;
  final double _radius;
  final double _fontSize;

  UserProfileAvatar(
      {Key  key,
        String avatarUrl,
        String initials,
      Function  onAvatarTap,
      AvatarBorderData  avatarBorderData,
      Color  avatarSplashColor,
      double radius = 15.0,
      double fontSize = 15.0,
      int  notificationCount,
      TextStyle  notificationBubbleTextStyle,
      bool isActivityIndicatorSmall = true,
      Color  activityIndicatorAndroidColor, })
      : _key = key,
        _avatarUrl = avatarUrl,
        _initials = initials,
        _onAvatarTap = onAvatarTap,
        _avatarBorderData = avatarBorderData,
        _avatarSplashColor = avatarSplashColor,
        _radius = radius,
        _fontSize = fontSize;

  @override
  _UserProfileAvatarState createState() => _UserProfileAvatarState();
}

class _UserProfileAvatarState extends State<UserProfileAvatar>
    with SingleTickerProviderStateMixin {
  final _inkwellCustomBorder = CircleBorder();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainContainerSize = widget._radius  ;
    final notificationBubbleSize = 10.0;

    return InkWell(
      onTap: () => widget._onAvatarTap?.call(),
      customBorder: _inkwellCustomBorder,
      splashColor: widget._avatarSplashColor,
      child: Container(
        height: mainContainerSize,
        width: mainContainerSize,
        child: Stack(
          children: [
             Center(
              child: ConditionalChild(
                condition: isNullOrEmpty(widget._avatarUrl),
                thenBuilder: () => Container(
                  height: widget._radius  ,
                  width: widget._radius  ,
                  child: Center(
                      child: Text(
                          widget._initials.contains(' ')?
                          '${widget._initials.split(' ')[0][0].toUpperCase()}${widget._initials.split(' ')[1][0].toUpperCase()}':
                          '${widget._initials.split(' ')[0][0].toUpperCase()}',
                        style:
                        TextStyle(color: Colors.white, fontSize: widget._fontSize),
                      )),
                  decoration: BoxDecoration(
                      color: widget._avatarSplashColor,
                      shape: BoxShape.circle,
                      ),
                ),
                elseBuilder: () => CachedNetworkImage(
                  key: widget._key,
                  imageUrl: widget._avatarUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    height: widget._radius  ,
                    width: widget._radius  ,
                    constraints: BoxConstraints(
                      minWidth: mainContainerSize,
                      minHeight: mainContainerSize,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      color: Colors.black26,
                      shape: BoxShape.circle,

                    ),
                  ),
                  placeholder: (_, __) => ActivityIndicator(
                    isSmall: false,

                  ),
                  errorWidget: (_, __, ___) => Icon(
                    Icons.error,
                    color: Colors.grey,
                    size: mainContainerSize > 300
                        ? 300
                        : mainContainerSize < 30
                            ? 30
                            : mainContainerSize,
                  ),
                ),
              ),
            ),
             // Align(
             //    alignment: Alignment.bottomRight,
             //    child: Container(
             //      margin:widget._radius<=30? EdgeInsets.only(right: 0,bottom: 0):EdgeInsets.only(right: 10,bottom: 10),
             //      height: notificationBubbleSize,
             //      width: notificationBubbleSize,
             //      constraints: BoxConstraints(
             //        minWidth: notificationBubbleSize,
             //        minHeight: notificationBubbleSize,
             //      ),
             //      decoration: BoxDecoration(
             //        color: Colors.green,
             //        shape: BoxShape.circle,
             //      ),
             //
             //    ),
             //  ),

          ],
        ),
      ),
    );
  }

}
