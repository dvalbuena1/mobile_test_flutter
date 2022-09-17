import 'package:flutter/material.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/screens/post_detail/post_detail.dart';
import 'package:mobile_test_flutter/screens/post_list/post_list.dart';

class Routes {
  static final navKey = GlobalKey<NavigatorState>();

  static const String home = '/';
  static const String post = '/post-detail';

  static Route? generateRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case home:
        return _buildRoute(settings, const PostList());
      case post:
        return _buildRoute(settings, PostDetail(post: args as PostModel,));
      default:
        return null;
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => builder,
    );
  }
}
