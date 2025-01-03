import 'package:flutter/material.dart';
import 'package:school_mate/main.dart';

// Useful debugging tool
class NavigationTreeObserver extends NavigatorObserver {
  List<String> routeHistory = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    String routeName = route.settings.name ?? _getWidgetClassName(route);
    routeHistory.add(routeName);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routeHistory.removeLast();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      routeHistory.removeLast();
      String routeName =
          newRoute.settings.name ?? _getWidgetClassName(newRoute);
      routeHistory.add(routeName);
    }
  }

  // Utility function to get the class name of the widget being pushed
  String _getWidgetClassName(Route<dynamic> route) {
    if (route is MaterialPageRoute) {
      final widgetType = route.builder.runtimeType.toString();
      return widgetType.split('<')[0]; // To get class name, e.g., HomePage
    }
    return route.runtimeType.toString().split('<')[0];
  }

  void printHistory() {
    String historyString = "";
    for (String route in routeHistory) {
      historyString += "$route -> ";
    }
    // Remove the trailing " -> " at the end
    if (historyString.isNotEmpty) {
      historyString = historyString.substring(0, historyString.length - 4);
    }
    logger.d("Navigation History: $historyString");
  }
}
