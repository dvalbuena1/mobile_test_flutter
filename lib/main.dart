import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/config/routes.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_cubit.dart';
import 'package:mobile_test_flutter/screens/post_list/post_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostListCubit>(create: (context) => PostListCubit()),
        BlocProvider<PostDetailCubit>(create: (context) => PostDetailCubit()),
      ],
      child: MaterialApp(
        title: 'Mobile Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PostList(),
        onGenerateRoute: Routes.generateRoutes,
        navigatorKey: Routes.navKey,
      ),
    );
  }
}
