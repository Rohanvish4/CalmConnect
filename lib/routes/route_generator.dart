import 'dart:developer';
import 'dart:io';
import 'package:calm_connect/routes/routes.dart';
import 'package:calm_connect/screens/auth/auth_screen.dart';
import 'package:calm_connect/screens/chat/view/chat_screen.dart';
import 'package:calm_connect/screens/home/view/home_screen.dart';
import 'package:calm_connect/screens/profile/profile_screen.dart';
import 'package:calm_connect/screens/resources/view/resources_screen.dart';
import 'package:calm_connect/screens/self_care/view/self_care_screen.dart';
import 'package:calm_connect/screens/support/support_screen.dart';
import 'package:calm_connect/screens/user_profile/user_profile_view.dart';
import 'package:calm_connect/screens/users/users_list_screen.dart';
import 'package:flutter/cupertino.dart';

import '../shared/animated_navigation.dart';
import '../shared/fade_route_transition.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    Map<String, dynamic> arguments = <String, dynamic>{};

    if (settings.arguments != null) {
      arguments = settings.arguments as Map<String, dynamic>;
    }

    log(settings.name ?? "Null Route Name");

    ///Helper to navigate from router
    navigateToScreen({required RouteSettings settings, required Widget route, RouteTransition? transition}) {
      if (Platform.isIOS) {
        return CupertinoPageRoute(builder: (_) => route);
      }
      return AnimatedRoute(
        child: route,
        settings: settings,
        transition: transition ?? RouteTransition.slideAndFade,
      );
    }

    switch (settings.name) {
      case "/":
        return navigateToScreen(settings: settings, route: const HomeScreen());
      // case Routes.dashboardPageRoute:
      //   return navigateToScreen(
      //     settings: settings,
      //     route: const DashboardScreen(),
      //   );
      case Routes.homePageRoute:
        return navigateToScreen(
          settings: settings, 
          route: HomeScreen(),
          transition: RouteTransition.fade,
        );

      case Routes.chatView:
        return navigateToScreen(
          settings: settings,
          route: ChatView(otherUserUID: arguments['otherUserUID']),
          transition: RouteTransition.slideFromRight,
        );
      case Routes.authView:
        return navigateToScreen(
          settings: settings, 
          route: const AuthScreen(),
          transition: RouteTransition.fade,
        );
      case Routes.usersListView:
        return navigateToScreen(
          settings: settings, 
          route: const UsersListScreen(),
          transition: RouteTransition.slideAndFade,
        );
      case Routes.profileView:
        return navigateToScreen(
          settings: settings, 
          route: const ProfileScreen(),
          transition: RouteTransition.slideFromRight,
        );
      case Routes.userProfileView:
        return navigateToScreen(
          settings: settings, 
          route: UserProfileView(userUID: arguments['userUID']),
          transition: RouteTransition.scale,
        );
      case Routes.selfCareView:
        return navigateToScreen(
          settings: settings, 
          route: const SelfCareScreen(),
          transition: RouteTransition.slideAndFade,
        );
      case Routes.supportView:
        return navigateToScreen(
          settings: settings, 
          route: const SupportScreen(),
          transition: RouteTransition.slideAndFade,
        );
      case Routes.resourcesView:
        return navigateToScreen(
          settings: settings, 
          route: const ResourcesScreen(),
          transition: RouteTransition.slideAndFade,
        );
      default:
        return FadeRoute(settings: settings, route: const HomeScreen());
    }
  }
}
