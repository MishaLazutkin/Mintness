import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class BubbleTabBar extends PreferredSize {
  /// tab collection
  final List<CustomHeightTab> _tabs = new List();

  /// Indicator length type
  final TabBarIndicatorSize indicatorSize;

  /// tabBar background color
  final Color backgroundColor;

  final Widget headerWidget;

  /// TabBar height without icon
  final double kTabHeight;

  /// The height of the icon tabBar
  final double kTextAndIconTabHeight;

  /// Select indicator height
  final double indicatorWeight;

  /// indicator color
  final Color indicatorColor;

  /// Whether multiple tabs can be scrolled
  final bool isScrollable;

  /// tab controller
  final TabController controller;

  /// indicator margin
  final EdgeInsetsGeometry indicatorPadding;

  /// indicator style
  final Decoration indicator;

  /// Label color
  final Color labelColor;

  /// Label font style
  final TextStyle labelStyle;

  /// Label margin
  final EdgeInsetsGeometry labelPadding;

  /// Label style is not selected
  final Color unselectedLabelColor;

  /// The label font style is not selected
  final TextStyle unselectedLabelStyle;

  final DragStartBehavior dragStartBehavior;

  /// Click tab to trigger function
  final ValueChanged<int> onTap;

  /// Add Tab to TabBar
  void addTab(text, [Icon icon, Widget child]) {
    // Add the custom tab that is actually used
    _tabs.add(CustomHeightTab(
      text: text,
      icon: icon,
      child: child,
      kTabHeight: this.kTabHeight,
      kTextAndIconTabHeight: this.kTextAndIconTabHeight,
    ));
  }

  BubbleTabBar({
    Key key,
    @required List<Tab> tabs,
    this.headerWidget,
    this.backgroundColor = Colors.white,
    this.kTabHeight = 30,
    this.kTextAndIconTabHeight = 46,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = const EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 3)
        ,
    this.indicator,
    this.indicatorSize,
    this.labelColor = Colors.black,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
  })  : assert(tabs != null),
        assert(isScrollable != null),
        assert(dragStartBehavior != null),
        assert(indicator != null ||
            (indicatorWeight != null && indicatorWeight > 0.0)),
        assert(indicator != null || (indicatorPadding != null)) {
    // All ordinary Tabs are converted to custom Tabs, and one more layer of conversion is to unify the high degree of decoupling and prevent the direct input of LogisticsTab from the custom height conflict
    for (Tab item in tabs) {
      addTab(item.text, item.icon, item.child);
    }
  }

  @override
  Widget build(BuildContext context) {
    // In order to add a background color, another layer is packed, the height must be uniform
    return Container(
      //Set the background color of the tab here
      child: Padding(
        padding: const EdgeInsets.only(bottom:5.0),
        child: Column(
          children: [
            headerWidget,

            Container(
              decoration:  ShapeDecoration(
                  color: AppColor.backgroundPageHeader,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),),
              ),
              width: MediaQuery.of(context).size.width - 34,

              child: CustomHeightTabBar(
                  isScrollable: this.isScrollable,
                  indicatorColor: this.indicatorColor,
                  indicatorWeight: this.indicatorWeight,
                  indicator: this.indicator,
                  indicatorSize: this.indicatorSize,
                  indicatorPadding: this.indicatorPadding,
                  controller: this.controller,
                  labelStyle: this.labelStyle,
                  labelColor: this.labelColor,
                  labelPadding: this.labelPadding,
                  unselectedLabelColor: this.unselectedLabelColor,
                  unselectedLabelStyle: this.unselectedLabelStyle,
                  dragStartBehavior: this.dragStartBehavior,
                  onTap: this.onTap,
                  kTabHeight: this.kTabHeight,
                  kTextAndIconTabHeight: this.kTextAndIconTabHeight,
                  tabs: this._tabs),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    for (Widget item in _tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null) {
          return Size.fromHeight(kTextAndIconTabHeight + indicatorWeight);
        }
      }
    }
    // tab height plus indicator height
    return Size.fromHeight(kTabHeight + indicatorWeight);
  }
}

class CustomHeightTabBar extends TabBar {
  final double kTabHeight;
  final double kTextAndIconTabHeight;

  CustomHeightTabBar(
      {indicatorSize,
      indicatorColor,
      controller,
      isScrollable,
      indicatorPadding,
      indicator,
      double indicatorWeight = 2,
      tabs,
      labelStyle,
      labelColor = Colors.black,
      labelPadding,
      unselectedLabelColor,
      unselectedLabelStyle,
      onTap,
      dragStartBehavior,
      this.kTabHeight = 23,
      this.kTextAndIconTabHeight = 46})
      : super(
          indicatorColor: indicatorColor,
          controller: controller,
          isScrollable: isScrollable,
          indicatorPadding: indicatorPadding,
          indicatorSize: indicatorSize,
          indicator: indicator,
          indicatorWeight: indicatorWeight,
          tabs: tabs,
          labelStyle: labelStyle,
          labelColor: labelColor,
          labelPadding: labelPadding,
          unselectedLabelColor: unselectedLabelColor,
          unselectedLabelStyle: unselectedLabelStyle,
          onTap: onTap,
          dragStartBehavior: dragStartBehavior,
        );

  // Override the method to obtain the defined height
  @override
  Size get preferredSize {
    for (Widget item in tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null) {
          return Size.fromHeight(kTextAndIconTabHeight + indicatorWeight);
        }
      }
    }
    return Size.fromHeight(kTabHeight + indicatorWeight);
  }
}

class CustomHeightTab extends Tab {
  final double kTabHeight;
  final double kTextAndIconTabHeight;
  final String text;
  final Icon icon;
  final Widget child;

  CustomHeightTab(
      {Key key,
      this.text,
      this.icon,
      this.child,
      this.kTabHeight = 23,
      this.kTextAndIconTabHeight = 23})
      : super(text: text, icon: icon, child: child);

  Widget _buildLabelText() {
    return child ?? Text(text, softWrap: false, overflow: TextOverflow.fade);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double height;
    Widget label;
    if (icon == null) {
      height = kTabHeight;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      height = kTabHeight;
      label = icon;
    } else {
      height = kTextAndIconTabHeight;
      label = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: icon,
            margin: const EdgeInsets.only(bottom: 10.0),
          ),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }
}
