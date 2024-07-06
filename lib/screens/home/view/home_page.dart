import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:e_waste/providers/tab_controller_bloc.dart';
import 'package:e_waste/tabs/bookmark_tab.dart';
import 'package:e_waste/tabs/home_tab.dart';
import 'package:e_waste/tabs/profile_tab.dart';
import 'package:e_waste/tabs/sell_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.locationName = ""}) : super(key: key);
  final String? locationName;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initData();

    // debugPrint(Provider.of<HomePageProvider>(context).categoryModel.toString());
  }

  initData() async {
    var tabProvider = context.read<TabControllerProvider>();
    await tabProvider.controlTab(0);
  }

  List<IconData> iconList = [
    Icons.home,
    Icons.add,
    Icons.favorite,
    Icons.person,
  ];
  List<IconData> svgList = [
    CupertinoIcons.home,
    // CupertinoIcons.bag,
    Icons.sell,
    CupertinoIcons.heart,
    CupertinoIcons.settings
    // AppConstant.nav1,
    // AppConstant.nav2,
    // AppConstant.nav3,
    // AppConstant.nav4,
  ];
  List<String> titleList = [
    'Home',
    'Sell',
    'Favourite',
    'Settings',
  ];

  _onBackPressed() async {
    if (context.read<TabControllerProvider>().currentIndex != 0) {
      context.read<TabControllerProvider>().controlTab(0);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  void dispose() {
    context.read<TabControllerProvider>().pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),

          controller: context.read<TabControllerProvider>().pageController,
          // onPageChanged: (index) {
          //   context.read<TabControllerProvider>().controlTab(index);
          //   context.read<TabControllerProvider>().pageController;
          // },
          children: const [
            HomeTab(),
            // SearchTab(),
            // BuyTab(),
            SellTab(),
            // ProfileTab(),
            BookMarkTab(),
            ProfileTab(),
            // OderDetailsScreen(),

            // ProfileDetails(),
            // ProfileDetails(),
            // ProfileDetails(),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Stack(
          children: [
            AnimatedBottomNavigationBar.builder(
              // icons: iconList,
              activeIndex: context.watch<TabControllerProvider>().currentIndex,
              gapWidth: 0,

              // activeColor: Colors.red,
              onTap: (index) {
                context.read<TabControllerProvider>().controlTab(index);
                // setState(() {
                //   _bottomNavIndex = index;
                //   _pageController.animateToPage(
                //     index,
                //     duration: Duration(milliseconds: 300),
                //     curve: Curves.ease,
                //   );
                // });
              },
              itemCount: iconList.length,
              tabBuilder: (int index, bool isActive) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      svgList[index],
                      color: isActive ? Colors.blue[700] : Colors.grey,
                    ),
                    // SvgPicture.asset(
                    //   svgList[index],
                    //   height: 30,
                    //   width: 30,
                    //   colorFilter: index != 0
                    //       ? ColorFilter.mode(
                    //           isActive
                    //               ? AppConstant.appThemeColor
                    //               : Colors.black,
                    //           BlendMode.srcIn)
                    //       : null,
                    // ),
                    Text(
                      titleList[index],
                      style: TextStyle(
                          color: isActive ? Colors.blue[700] : Colors.grey,
                          fontSize: 12,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



  //  AnimatedBottomNavigationBar _bottomNavigationBar(BuildContext context) {
  //   return AnimatedBottomNavigationBar(
  //     icons: iconList,
  //     gapLocation: GapLocation.none,
  //     activeIndex: selectedIndex,
  //     iconSize: 22,
  //     backgroundColor:
  //         Theme.of(context).bottomNavigationBarTheme.backgroundColor,
  //     activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
  //     inactiveColor:
  //         Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
  //     splashColor: Theme.of(context).primaryColor,
  //     onTap: (index) => onItemTapped(index),
  //   );
  // }

  // Widget tabItem(
  //     IconData iconData, int position, DashboardProvider dashboardProvider,
  //     {bool isCircle = false}) {
  //   return Expanded(
  //       child: InkWell(
  //     onTap: () {
  //       dashboardProvider.changeSelectIndex(position);
  //       controller.animateToPage(position,
  //           duration: const Duration(seconds: 1), curve: Curves.easeOut);
  //     },
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         !isCircle
  //             ? Tab(
  //                 icon: Icon(iconData,
  //                     size: 30.0,
  //                     color: dashboardProvider.selectIndex == position
  //                         ? Colors.blue
  //                         : Colors.grey.withOpacity(.8)))
  //             : Container(
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                         color: dashboardProvider.selectIndex == position
  //                             ? Colors.blue
  //                             : Colors.grey.withOpacity(.8),
  //                         width: 2.0)),
  //                 child: Tab(
  //                     icon: Icon(iconData,
  //                         size: 25.0,
  //                         color: dashboardProvider.selectIndex == position
  //                             ? Colors.blue
  //                             : Colors.grey.withOpacity(.8)))),
  //         Container(
  //           height: 3,
  //           margin: const EdgeInsets.only(bottom: 2),
  //           decoration: BoxDecoration(
  //               color: dashboardProvider.selectIndex == position
  //                   ? Colors.blue
  //                   : Colors.transparent,
  //               borderRadius: BorderRadius.circular(10)),
  //         )
  //       ],
  //     ),
  //   ));
  // }

