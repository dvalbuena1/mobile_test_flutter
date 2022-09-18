import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_test_flutter/config/routes.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_detail/post_detail_cubit.dart';
import 'package:mobile_test_flutter/data/blocs/post_list/post_list_cubit.dart';
import 'package:mobile_test_flutter/data/models/post.dart';
import 'package:mobile_test_flutter/data/models/user.dart';
import 'package:mobile_test_flutter/data/repositories/comment_repository.dart';
import 'package:mobile_test_flutter/data/repositories/post_repository.dart';
import 'package:mobile_test_flutter/data/repositories/user_repository.dart';
import 'package:mobile_test_flutter/screens/post_detail/post_detail.dart';
import 'package:mobile_test_flutter/screens/post_list/post_list.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_list_detail_test.mocks.dart';

@GenerateMocks(
    [Connectivity, PostRepository, UserRepository, CommentRepository])
void main() {
  late MockConnectivity connectivity;
  late MockPostRepository postRepository;
  late MockUserRepository userRepository;
  late MockCommentRepository commentRepository;
  setUpAll(() {
    connectivity = MockConnectivity();
    postRepository = MockPostRepository();
    userRepository = MockUserRepository();
    commentRepository = MockCommentRepository();
  });

  Widget createWidgetForTesting(bool isOnline) {
    ConnectivityResult connectivityResult =
        isOnline ? ConnectivityResult.wifi : ConnectivityResult.none;
    when(connectivity.onConnectivityChanged).thenAnswer(
        (_) => Stream<ConnectivityResult>.fromIterable([connectivityResult]));
    when(connectivity.checkConnectivity())
        .thenAnswer((_) => Future.value(connectivityResult));

    final connectivityCubit = ConnectivityCubit(connectivity: connectivity);
    connectivityCubit.setConnectivityState(connectivityResult);
    connectivityCubit.listenConnectivity();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityCubit>(create: (context) => connectivityCubit),
        BlocProvider<PostListCubit>(
            create: (context) => PostListCubit(
                connectivityCubit: connectivityCubit,
                repository: postRepository)),
        BlocProvider<PostDetailCubit>(
            create: (context) => PostDetailCubit(
                connectivityCubit: connectivityCubit,
                userRepository: userRepository,
                commentRepository: commentRepository)),
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

  void return5Posts() {
    when(postRepository.getPostsOnline()).thenAnswer((_) async => [
          PostModel(
              id: 1, userId: 1, title: 'title', body: 'body', favorite: false),
          PostModel(
              id: 2, userId: 1, title: 'title', body: 'body', favorite: false),
          PostModel(
              id: 3, userId: 1, title: 'title', body: 'body', favorite: false),
          PostModel(
              id: 4, userId: 1, title: 'title', body: 'body', favorite: false),
          PostModel(
              id: 5, userId: 1, title: 'title', body: 'body', favorite: false)
        ]);
  }

  void return5FavoritePosts() {
    when(postRepository.getPostsOnline()).thenAnswer((_) async => [
          PostModel(
              id: 1, userId: 1, title: 'title', body: 'body', favorite: true),
          PostModel(
              id: 2, userId: 1, title: 'title', body: 'body', favorite: true),
          PostModel(
              id: 3, userId: 1, title: 'title', body: 'body', favorite: true),
          PostModel(
              id: 4, userId: 1, title: 'title', body: 'body', favorite: true),
          PostModel(
              id: 5, userId: 1, title: 'title', body: 'body', favorite: true)
        ]);
  }

  void return0Posts() {
    when(postRepository.getPostsOnline()).thenAnswer((_) async => []);
  }

  void returnNullUser() {
    when(userRepository.getUserOnline(any)).thenAnswer((_) async => null);
  }

  void return1User() {
    when(userRepository.getUserOnline(1))
        .thenAnswer((_) async => UserModel.fromJson({
              'id': 1,
              'name': 'name',
              'username': 'username',
              'email': 'email',
              'phone': 'phone',
              'website': 'website',
              'address': {
                'street': 'street',
                'suite': 'suite',
                'city': 'city',
                'zipcode': 'zipcode',
                'geo': {'lat': 'lat', 'lng': 'lng'}
              },
              'company': {
                'name': 'name',
                'catchPhrase': 'catchPhrase',
                'bs': 'bs'
              }
            }));
  }

  void returnNullComments() {
    when(commentRepository.getCommentsOnline(any))
        .thenAnswer((_) async => null);
  }

  void return5Comments() {
    when(commentRepository.getCommentsOnline(1)).thenAnswer((_) async => [
          CommentModel(
              id: 1, postId: 1, name: 'name', email: 'email', body: 'body'),
          CommentModel(
              id: 2, postId: 1, name: 'name', email: 'email', body: 'body'),
          CommentModel(
              id: 3, postId: 1, name: 'name', email: 'email', body: 'body'),
          CommentModel(
              id: 4, postId: 1, name: 'name', email: 'email', body: 'body'),
          CommentModel(
              id: 5, postId: 1, name: 'name', email: 'email', body: 'body')
        ]);
  }

  testWidgets(
    "Title displayed",
    (widgetTester) async {
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      expect(find.text("Mobile Test"), findsOneWidget);
    },
  );

  testWidgets(
    "Load 5 posts",
    (widgetTester) async {
      return5Posts();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      expect(find.byType(PostItem), findsNWidgets(5));
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
    },
  );

  testWidgets(
    "Load 5 favorite posts",
    (widgetTester) async {
      return5FavoritePosts();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      expect(find.byType(PostItem), findsNWidgets(5));
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    },
  );

  testWidgets(
    "No posts",
    (widgetTester) async {
      return0Posts();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      expect(find.text("No posts to show"), findsOneWidget);
    },
  );

  testWidgets(
    "Add post to favorites",
    (widgetTester) async {
      return5Posts();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      expect(find.byIcon(Icons.star_border), findsNWidgets(5));
      await widgetTester.tap(find.byIcon(Icons.star_border).first);
      await widgetTester.pump();

      expect(find.byIcon(Icons.star_border), findsNWidgets(4));
      expect(find.byIcon(Icons.star), findsOneWidget);
    },
  );

  testWidgets("Delete post from favorites", (widgetTester) async {
    return5FavoritePosts();
    await widgetTester.pumpWidget(createWidgetForTesting(true));
    await widgetTester.pump();

    expect(find.byIcon(Icons.star), findsNWidgets(5));
    await widgetTester.tap(find.byIcon(Icons.star).first);
    await widgetTester.pump();

    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_border), findsOneWidget);
  });

  testWidgets("Tap delete post", (widgetTester) async {
    return5Posts();
    await widgetTester.pumpWidget(createWidgetForTesting(true));
    await widgetTester.pump();

    expect(find.byType(PostItem), findsNWidgets(5));
    await widgetTester.tap(find.byIcon(Icons.delete_outline).first);
    await widgetTester.pump();

    expect(find.byType(PostItem), findsNWidgets(4));
  });

  testWidgets("Tap delete all posts", (widgetTester) async {
    return5Posts();
    await widgetTester.pumpWidget(createWidgetForTesting(true));
    await widgetTester.pump();

    expect(find.byType(PostItem), findsNWidgets(5));
    await widgetTester.tap(find.byIcon(Icons.delete_forever).first);
    await widgetTester.pump();

    expect(find.byType(PostItem), findsNothing);
  });

  testWidgets(
    "Tap post to open detail without user and comments",
    (widgetTester) async {
      return5Posts();
      returnNullUser();
      returnNullComments();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      await widgetTester.tap(find.byType(PostItem).first);
      await widgetTester.pumpAndSettle();

      expect(find.byType(PostDetail), findsOneWidget);
      expect(find.text("Something went wrong"), findsOneWidget);
    },
  );

  testWidgets(
    "Tap post to open detail",
    (widgetTester) async {
      return5Posts();
      return1User();
      return5Comments();
      await widgetTester.pumpWidget(createWidgetForTesting(true));
      await widgetTester.pump();

      await widgetTester.tap(find.byType(PostItem).first);
      await widgetTester.pumpAndSettle();

      expect(find.byType(PostDetail), findsOneWidget);
      expect(find.byType(UserInfo), findsOneWidget);
      expect(find.byType(Comments), findsOneWidget);
      expect(find.byType(Comments), findsOneWidget);
    },
  );

  testWidgets("Tap post to open detail and go back", (widgetTester) async {
    return5Posts();
    return1User();
    return5Comments();
    await widgetTester.pumpWidget(createWidgetForTesting(true));
    await widgetTester.pump();

    await widgetTester.tap(find.byType(PostItem).first);
    await widgetTester.pumpAndSettle();

    expect(find.byType(PostDetail), findsOneWidget);
    await widgetTester.tap(find.byIcon(Icons.arrow_back).first);
    await widgetTester.pumpAndSettle();

    expect(find.byType(PostList), findsOneWidget);
    expect(find.byType(PostDetail), findsNothing);
  });
}
