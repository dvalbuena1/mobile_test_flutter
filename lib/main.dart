import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/config/routes.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_cubit.dart';
import 'package:mobile_test_flutter/data/databases/local_storage.dart';
import 'package:mobile_test_flutter/data/repositories/comment_repository.dart';
import 'package:mobile_test_flutter/data/repositories/post_repository.dart';
import 'package:mobile_test_flutter/data/repositories/user_repository.dart';
import 'package:mobile_test_flutter/screens/post_list/post_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().db;
  final connectivity = Connectivity();
  final connectivityResult = await connectivity.checkConnectivity();
  runApp(MyApp(
      connectivity: connectivity, connectivityResult: connectivityResult));
}

class MyApp extends StatelessWidget {
  final Connectivity connectivity;
  final ConnectivityResult connectivityResult;

  const MyApp(
      {Key? key, required this.connectivity, required this.connectivityResult})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final connectivityCubit = ConnectivityCubit(connectivity: connectivity);
    connectivityCubit.setConnectivityState(connectivityResult);
    connectivityCubit.listenConnectivity();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(create: (context) => connectivityCubit),
        BlocProvider<PostListCubit>(
            create: (context) => PostListCubit(
                connectivityCubit: connectivityCubit,
                repository: PostRepository())),
        BlocProvider<PostDetailCubit>(
            create: (context) => PostDetailCubit(
                connectivityCubit: connectivityCubit,
                userRepository: UserRepository(),
                commentRepository: CommentRepository())),
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
