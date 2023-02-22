import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:mintness/home/project/project_page.dart';
import 'package:mintness/profile/profile_page.dart';
import 'package:mintness/providers/home_provider.dart';
import 'package:mintness/providers/profile_provider.dart';
import 'package:mintness/providers/time_tracker_provider.dart';
import 'package:mintness/services/navigation_service.dart';
import 'package:mintness/utils/constants.dart';
import 'package:mintness/widgets/buble_tabbar.dart';
import 'package:mintness/widgets/custom_bottom_bar.dart';
import 'package:mintness/widgets/fullscreen_loader.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mintness/widgets/other_widgets.dart';
import 'package:mintness/widgets/status.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../style.dart';

@immutable
class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with
        FullscreenLoaderMixin<HomePage>,
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  List<bool> _isCheckedProjects;
  List<bool> _isCheckedDueDate;
  List<bool> _isCheckedPriority;

  @override
  bool get wantKeepAlive => true;

  HomeProvider _homeProvider;
  FocusNode _searchProjectsFocusNone = FocusNode();
  FocusNode _searchDueDateFocusNone = FocusNode();
  FocusNode _searchPriorityFocusNone = FocusNode();
  Widget _projectsSearchBar = Container();
  Widget _dueDateSearchBar = Container();
  Widget _prioritySearchBar = Container();
  Icon _customProjectsIcon = const Icon(Icons.search);
  Icon _customDueDateIcon = const Icon(Icons.search);
  Icon _customPriorityIcon = const Icon(Icons.search);
  TextEditingController _projectsController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TabController _tabController;
  int _currentTabIndex = 0;

  void _navigateToProfilePage() {
    NavigationService().push(context, Direction.fromRight, const ProfilePage());
  }

  void _initProvider() async {
    _homeProvider = context.read<HomeProvider>();
    await Future.wait([context.read<TimeTrackerProvider>().init()]);
    _isCheckedProjects =
        List<bool>.filled(_homeProvider.projectsStatuses.length, false);
    _isCheckedDueDate =
        List<bool>.filled(_homeProvider.projectsStatuses.length, false);
    _isCheckedPriority =
        List<bool>.filled(_homeProvider.projectsStatuses.length, false);
  }

  @override
  void initState() {
    super.initState();
    _initTabController();
    Future.microtask(_initProvider);
  }

  Future<void> _initTabController() {
    _tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          _currentTabIndex = _tabController.index;
          switch (_tabController.index) {
            case 0:
              resetSearchPanel(0);
              break;
            case 1:
              resetSearchPanel(1);
              break;
            case 2:
              resetSearchPanel(2);
              break;
          }
        });
      });
  }

  Future<void> resetSearchPanel(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _homeProvider.searchedTextDueDate = '';
        _homeProvider.searchedTextPriority = '';
        _homeProvider.searchData('', 1);
        _homeProvider.searchData('', 2);
        _dueDateController.clear();
        _priorityController.clear();

        _searchDueDateFocusNone.unfocus();
        _searchPriorityFocusNone.unfocus();
        _customDueDateIcon = const Icon(Icons.search);
        _customPriorityIcon = const Icon(Icons.search);
        _dueDateSearchBar = Container();
        _prioritySearchBar = Container();

        _homeProvider.duedateStatusesFilterIds = [];
        _homeProvider.priorityStatusesFilterIds = [];

        _isCheckedDueDate =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);
        _isCheckedPriority =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);
        setState(() {});
        break;
      case 1:
        _homeProvider.searchedTextProjects = '';
        _homeProvider.searchedTextPriority = '';
        _homeProvider.searchData('', 0);
        _homeProvider.searchData('', 2);
        _projectsController.clear();
        _priorityController.clear();

        _searchProjectsFocusNone.unfocus();
        _searchPriorityFocusNone.unfocus();
        _customProjectsIcon = const Icon(Icons.search);
        _customPriorityIcon = const Icon(Icons.search);
        _projectsSearchBar = Container();
        _prioritySearchBar = Container();

        _homeProvider.projectStatusesFilterIds = [];
        _homeProvider.priorityStatusesFilterIds = [];
        _isCheckedProjects =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);
        _isCheckedPriority =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);

        setState(() {});
        break;
      case 2:
        _homeProvider.searchedTextProjects = '';
        _homeProvider.searchedTextDueDate = '';
        _homeProvider.searchData('', 0);
        _homeProvider.searchData('', 1);
        _projectsController.clear();
        _dueDateController.clear();

        _searchProjectsFocusNone.unfocus();
        _searchDueDateFocusNone.unfocus();
        _customProjectsIcon = const Icon(Icons.search);
        _customDueDateIcon = const Icon(Icons.search);
        _projectsSearchBar = Container();
        _dueDateSearchBar = Container();

        _homeProvider.projectStatusesFilterIds = [];
        _homeProvider.duedateStatusesFilterIds = [];
        _isCheckedProjects =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);
        _isCheckedDueDate =
            List<bool>.filled(_homeProvider.projectsStatuses.length, false);
        setState(() {});
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<HomeProvider>(
          builder: (_, HomeProvider provider, __) {
            return Consumer<ProfileProvider>(
                builder: (_, ProfileProvider profileProvider, __) {
              return Consumer<TimeTrackerProvider>(
                  builder: (_, TimeTrackerProvider timeTrackerProvider, __) {
                return DefaultTabController(
                    length: 3,
                    child: Builder(builder: (BuildContext context) {
                      return Scaffold(
                        backgroundColor:
                            timeTrackerProvider.timerData?.headerColor,
                        body: Column(
                          children: [
                            Column(
                              children: [
                                _header(profileProvider, timeTrackerProvider),
                                _bodyTop(timeTrackerProvider),
                                _tabs(),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _projectsTab(provider, context),
                                  _dueDateTab(provider, context),
                                  _priorityTab(provider, context),
                                ],
                              ),
                            ),
                          ],
                        ),
                        bottomNavigationBar: const CustomBottomBar(0),
                      );
                    }));
              });
            });
          },
        ),
        if (showLoader) const FullscreenLoader(),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      height: 44,
      child: AppBar(
        primary: false,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: AppColor.backgroundPageBody,
        bottom: BubbleTabBar(
          controller: _tabController,
          isScrollable: false,
          labelStyle: AppTextStyle.tabSelectedTitle,
          unselectedLabelStyle: AppTextStyle.tabUnselectedTitle,
          headerWidget: Container(),
          indicator: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6)),
          tabs: [
            _individualTab('Projects'),
            _individualTab('Due Date'),
            _individualTab('Priority')
          ],
        ),
      ),
    );
  }

  Widget _bodyTop(TimeTrackerProvider timeTrackerProvider) {
    return Container(
      color: timeTrackerProvider.timerData?.headerColor,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [AppConstants.boxShadowHeader],
          color: AppColor.backgroundPageBody,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        height: 20,
      ),
    );
  }

  Widget _projectsTab(HomeProvider provider, BuildContext context) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            _searchProjectsPanel(provider, context),
            _projectsContent(provider)
          ],
        ),
      ),
    );
  }

  Widget _dueDateTab(HomeProvider provider, BuildContext context) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 5.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            _searchDueDatePanel(provider, context),
            _dueDateContent(provider)
          ],
        ),
      ),
    );
  }

  Widget _priorityTab(HomeProvider provider, BuildContext context) {
    return Container(
      color: AppColor.backgroundPageBody,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 5.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            _searchPriorityPanel(provider, context),
            _priorityContent(provider)
          ],
        ),
      ),
    );
  }

  Widget _searchProjectsPanel(HomeProvider homeProvider, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(flex: 1, child: _projectsPopupStatusesMenu(homeProvider)),
          const SizedBox(
            width: 10,
          ),
          Flexible(flex: 5, child: _projectsSearchBar),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_customProjectsIcon.icon == Icons.search) {
                    _searchProjectsFocusNone.requestFocus();
                    _customProjectsIcon = const Icon(Icons.clear);
                    _projectsSearchBar = TextField(
                      controller: _projectsController,
                      onChanged: (value) {
                        homeProvider.searchData(value, _currentTabIndex);
                        homeProvider.searchedTextProjects = value;
                      },
                      focusNode: _searchProjectsFocusNone,
                      decoration: const InputDecoration(
                        hintText: 'search...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    );
                  } else {
                    _searchProjectsFocusNone.unfocus();
                    _customProjectsIcon = const Icon(Icons.search);
                    _projectsSearchBar = Container();
                    _projectsController.clear();
                    homeProvider.searchData('', _currentTabIndex);
                  }
                });
              },
              icon: _customProjectsIcon,
            ),
          )
        ],
      ),
    );
  }

  Widget _searchDueDatePanel(HomeProvider provider, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Row(
        children: [
          Flexible(flex: 1, child: _duedatePopupStatusesMenu(provider)),
          const SizedBox(
            width: 10,
          ),
          Flexible(flex: 5, child: _dueDateSearchBar),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_customDueDateIcon.icon == Icons.search) {
                    _searchDueDateFocusNone.requestFocus();
                    _customDueDateIcon = const Icon(Icons.clear);
                    _dueDateSearchBar = TextField(
                      controller: _dueDateController,
                      onChanged: (value) {
                        provider.searchData(value, _currentTabIndex);
                      },
                      focusNode: _searchDueDateFocusNone,
                      decoration: const InputDecoration(
                        hintText: 'search...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    );
                  } else {
                    _searchDueDateFocusNone.unfocus();
                    _customDueDateIcon = const Icon(Icons.search);
                    provider.searchData('', _currentTabIndex);
                    _dueDateController.clear();
                    _dueDateSearchBar = Container();
                  }
                });
              },
              icon: _customDueDateIcon,
            ),
          )
        ],
      ),
    );
  }

  Widget _searchPriorityPanel(HomeProvider provider, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Row(
        children: [
          Flexible(flex: 1, child: _priorityPopupStatusesMenu(provider)),
          const SizedBox(
            width: 10,
          ),
          Flexible(flex: 5, child: _prioritySearchBar),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_customPriorityIcon.icon == Icons.search) {
                    _searchPriorityFocusNone.requestFocus();
                    _customPriorityIcon = const Icon(Icons.clear);
                    _prioritySearchBar = TextField(
                      controller: _priorityController,
                      onChanged: (value) {
                        provider.searchData(value, _currentTabIndex);
                      },
                      focusNode: _searchPriorityFocusNone,
                      decoration: const InputDecoration(
                        hintText: 'search...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    );
                    //  restoreSearchedPanels(provider,_currentTabIndex);
                  } else {
                    _searchPriorityFocusNone.unfocus();
                    _customPriorityIcon = const Icon(Icons.search);
                    _prioritySearchBar = Container();
                    provider.searchData('', _currentTabIndex);
                    _priorityController.clear();
                  }
                });
              },
              icon: _customPriorityIcon,
            ),
          )
        ],
      ),
    );
  }

  Widget _projectsContent(HomeProvider provider) {
    Map<String, List<Map<String, dynamic>>> groupedMap = {};
    List<Map<String, dynamic>> groupedMapToList = [];

    List<Map<String, dynamic>> resultList = [];

    groupedMap = groupBy(
        provider.listProjects, (project) => '${project['type'].trim()}');

    groupedMap.forEach(
        (key, value) => groupedMapToList.add({'key': key, 'value': value}));
    final distinctTypes = Set();

    provider.listProjects.forEach((element) {
      distinctTypes.add(element['type']);
    });

    for (String type in distinctTypes) {
      resultList.add(groupedMapToList.firstWhere(
          (element) => element.values.first == type,
          orElse: () => null));
    }

    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: resultList.length,
            itemBuilder: (context, resultListIndex) {
              return Column(
                children: [
                  if (resultListIndex > 0)
                    const SizedBox(
                      height: 24,
                    ),
                  Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${resultList[resultListIndex]['key']}',
                            style: AppTextStyle.homePageBodyItem,
                          ),
                          const Divider(
                            thickness: 1,
                          )
                        ],
                      )),
                  ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: resultList[resultListIndex]['value'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: InkWell(
                            onTap: () async {
                              NavigationService().push(
                                  context,
                                  Direction.fromRight,
                                  ProjectPage(
                                      project_id: resultList[resultListIndex]
                                          ['value'][index]['id']));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 7.0),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${resultList[resultListIndex]['value'][index]['name']}',
                                      style: AppTextStyle.homePageCardTitle,
                                    ),
                                    const SizedBox(
                                      height: 17.5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${resultList[resultListIndex]['value'][index]['deadline']['percentage']}%',
                                          //
                                          style:
                                              AppTextStyle.homePageCardPercent,
                                        ),
                                        LinearPercentIndicator(
                                          width: 116.0,
                                          lineHeight: 7.0,
                                          // percent: element['deadline']['percentage'] /
                                          //     100.toDouble(),
                                          linearStrokeCap:
                                              LinearStrokeCap.roundAll,
                                          backgroundColor: AppColor
                                              .backgroundPercentIndicator,
                                          progressColor:
                                              AppColor.percentIndicator,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 19.5,
                                    ),
                                    Row(
                                      children: [
                                        StatusWidget(
                                            text: resultList[resultListIndex]
                                                    ['value'][index]['status']
                                                ['name'],
                                            color: resultList[resultListIndex]
                                                    ['value'][index]['status']
                                                ['color']),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        priorityImage(
                                            imageUrl:
                                                resultList[resultListIndex]
                                                        ['value'][index]
                                                    ['priority']['icon']),
                                        const Spacer(),
                                        Text(
                                          '${DateFormat('MM.dd.yyyy').format(DateFormat().add_yMd().parse(resultList[resultListIndex]['value'][index]['end_date'])) ?? ''}',
                                          style: AppTextStyle.cardDate,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              );
            }));
  }

  Widget _dueDateContent(HomeProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: GroupedListView<dynamic, String>(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            elements: provider.listDueDate,
            groupBy: (element) => element['end_date'],
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (item1, item2) =>
                item1['end_date'].compareTo(item2['end_date']),
            order: GroupedListOrder.ASC,
            groupSeparatorBuilder: (String value) => Padding(
                  padding:
                      const EdgeInsets.only(left: 2.0, right: 2.0, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateFormat('MM.dd.yyyy').format(DateFormat().add_yMd().parse(value))}',
                        style: AppTextStyle.homePageBodyItem,
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                ),
            itemBuilder: (c, element) {
              return Card(
                elevation: 4.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: InkWell(
                  onTap: () async {
                    NavigationService().push(context, Direction.fromRight,
                        ProjectPage(project_id: element['id']));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 7.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${element['name']}',
                            style: AppTextStyle.homePageCardTitle,
                          ),
                          const SizedBox(
                            height: 17.5,
                          ),
                          Row(
                            children: [
                              Text(
                                '${element['deadline']['percentage']}%',
                                style: AppTextStyle.homePageCardPercent,
                              ),
                              LinearPercentIndicator(
                                width: 116.0,
                                lineHeight: 7.0,
                                percent: element['deadline']['percentage'] /
                                    100.toDouble(),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor:
                                    AppColor.backgroundPercentIndicator,
                                progressColor: AppColor.percentIndicator,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 19.5,
                          ),
                          Row(
                            children: [
                              StatusWidget(
                                  text: element['status']['name'],
                                  color: element['status']['color']),
                              const SizedBox(
                                width: 10,
                              ),
                              priorityImage(
                                  imageUrl: element['priority']['icon']),
                              const Spacer(),
                              Text(
                                '${DateFormat('MM.dd.yyyy').format(DateFormat().add_yMd().parse(element['end_date'])) ?? ''}',
                                style: AppTextStyle.cardDate,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _priorityContent(HomeProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: GroupedListView<dynamic, String>(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            elements: provider.listPriority,
            groupBy: (element) => element['priority']['name'],
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (item1, item2) =>
                item1['end_date'].compareTo(item2['end_date']),
            order: GroupedListOrder.ASC,
            groupSeparatorBuilder: (String value) => Padding(
                  padding:
                      const EdgeInsets.only(left: 2.0, right: 2.0, top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$value',
                        style: AppTextStyle.homePageBodyItem,
                      ),
                      const Divider(
                        thickness: 1,
                      )
                    ],
                  ),
                ),
            itemBuilder: (c, element) {
              return Card(
                elevation: 4.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: InkWell(
                  onTap: () async {
                    NavigationService().push(context, Direction.fromRight,
                        ProjectPage(project_id: element['id']));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 7.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${element['name']}',
                            style: AppTextStyle.homePageCardTitle,
                          ),
                          const SizedBox(
                            height: 17.5,
                          ),
                          Row(
                            children: [
                              Text(
                                '${element['deadline']['percentage']}%',
                                style: AppTextStyle.homePageCardPercent,
                              ),
                              LinearPercentIndicator(
                                width: 116.0,
                                lineHeight: 7.0,
                                percent: element['deadline']['percentage'] /
                                    100.toDouble(),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor:
                                    AppColor.backgroundPercentIndicator,
                                progressColor: AppColor.percentIndicator,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 19.5,
                          ),
                          Row(
                            children: [
                              StatusWidget(
                                  text: element['status']['name'],
                                  color: element['status']['color']),
                              const SizedBox(
                                width: 10,
                              ),
                              priorityImage(
                                  imageUrl: element['priority']['icon']),
                              const Spacer(),
                              Text(
                                '${DateFormat('MM.dd.yyyy').format(DateFormat().add_yMd().parse(element['end_date'])) ?? ''}',
                                style: AppTextStyle.cardDate,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _individualTab(String title) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        height: 20,
        // decoration: BoxDecoration(
        //     border: Border(
        //         right: BorderSide(
        //             color: HexColor('#ACB4BE'), width: 1, style: BorderStyle.solid))),
        child: Text(
          title,
        ),
      ),
    );
  }

  Widget _header(ProfileProvider profileProvider,
      TimeTrackerProvider timeTrackerProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                timeTrackerProvider.currentTimer != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/icons/timer.svg',
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${timeTrackerProvider.timerData?.currentSession}',
                            style: timeTrackerProvider.timerData.textStyle,
                          ),
                        ],
                      )
                    : Text(
                        'Projects',
                        style: AppTextStyle.pageTitle,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    avatar(profileProvider.avatarUrl, _navigateToProfilePage,
                        profileProvider.fullName),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectsPopupStatusesMenu(HomeProvider homeProvider) =>
      PopupMenuButton<int>(
        child: Container(
          height: 40,
          width: 40,
          child: SvgPicture.asset(
            'lib/assets/icons/menu.svg',
            width: 40,
            height: 40,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return homeProvider.projectsStatuses
              .map((status) => PopupMenuItem<int>(
                  value: status['id'],
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      decoration: (_isCheckedProjects[status['id'] - 1])
                          ? BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16))
                          : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GFCheckbox(
                            value: _isCheckedProjects[status['id'] - 1],
                            type: GFCheckboxType.circle,
                            size: GFSize.SMALL,
                            activeBgColor: Colors.grey.withOpacity(0.2),
                            onChanged: (bool x) {
                              setState(() {
                                _isCheckedProjects[status['id'] - 1] = x;
                                if (_isCheckedProjects[status['id'] - 1]) {
                                  homeProvider.projectStatusesFilterIds
                                      .add(status['id']);
                                  homeProvider.searchData(
                                    homeProvider.searchedTextProjects,
                                    _currentTabIndex,
                                  );
                                } else {
                                  homeProvider.projectStatusesFilterIds
                                      .remove(status['id']);
                                  homeProvider.searchData(
                                      homeProvider.searchedTextProjects,
                                      _currentTabIndex);
                                }
                              });
                            },
                            activeIcon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${status['name']}'),
                        ],
                      ),
                    );
                  })))
              .toList();
        },
        onSelected: (value) {
          print('x = $value');
        },
      );

  Widget _duedatePopupStatusesMenu(HomeProvider homeProvider) =>
      PopupMenuButton<int>(
        child: Container(
          height: 40,
          width: 40,
          child: SvgPicture.asset(
            'lib/assets/icons/menu.svg',
            width: 40,
            height: 40,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return homeProvider.projectsStatuses
              .map((status) => PopupMenuItem<int>(
                  value: status['id'],
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      decoration: (_isCheckedDueDate[status['id'] - 1])
                          ? BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16))
                          : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GFCheckbox(
                            value: _isCheckedDueDate[status['id'] - 1],
                            type: GFCheckboxType.circle,
                            size: GFSize.SMALL,
                            activeBgColor: Colors.grey.withOpacity(0.2),
                            onChanged: (bool x) {
                              setState(() {
                                _isCheckedDueDate[status['id'] - 1] = x;
                                if (_isCheckedDueDate[status['id'] - 1]) {
                                  homeProvider.duedateStatusesFilterIds
                                      .add(status['id']);
                                  homeProvider.searchData(
                                    homeProvider.searchedTextDueDate,
                                    _currentTabIndex,
                                  );
                                } else {
                                  homeProvider.duedateStatusesFilterIds
                                      .remove(status['id']);
                                  homeProvider.searchData(
                                      homeProvider.searchedTextDueDate,
                                      _currentTabIndex);
                                }
                              });
                            },
                            activeIcon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${status['name']}'),
                        ],
                      ),
                    );
                  })))
              .toList();
        },
        onSelected: (value) {
          print('x = $value');
        },
      );

  Widget _priorityPopupStatusesMenu(HomeProvider homeProvider) =>
      PopupMenuButton<int>(
        child: Container(
          height: 40,
          width: 40,
          child: SvgPicture.asset(
            'lib/assets/icons/menu.svg',
            width: 40,
            height: 40,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        itemBuilder: (context) {
          return homeProvider.projectsStatuses
              .map((status) => PopupMenuItem<int>(
                  value: status['id'],
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      decoration: (_isCheckedPriority[status['id'] - 1])
                          ? BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16))
                          : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GFCheckbox(
                            value: _isCheckedPriority[status['id'] - 1],
                            type: GFCheckboxType.circle,
                            size: GFSize.SMALL,
                            activeBgColor: Colors.grey.withOpacity(0.2),
                            onChanged: (bool x) {
                              setState(() {
                                _isCheckedPriority[status['id'] - 1] = x;
                                if (_isCheckedPriority[status['id'] - 1]) {
                                  homeProvider.priorityStatusesFilterIds
                                      .add(status['id']);
                                  homeProvider.searchData(
                                    homeProvider.searchedTextPriority,
                                    _currentTabIndex,
                                  );
                                } else {
                                  homeProvider.priorityStatusesFilterIds
                                      .remove(status['id']);
                                  homeProvider.searchData(
                                      homeProvider.searchedTextPriority,
                                      _currentTabIndex);
                                }
                              });
                            },
                            activeIcon: const Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${status['name']}'),
                        ],
                      ),
                    );
                  })))
              .toList();
        },
        onSelected: (value) {
          print('x = $value');
        },
      );
}
