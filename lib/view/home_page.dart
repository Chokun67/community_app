import 'package:community_app/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:community_app/bloc/auth/auth_bloc.dart';
import 'package:community_app/bloc/auth/auth_event.dart';
import 'package:community_app/bloc/post/post_bloc.dart';
import 'package:community_app/bloc/post/post_event.dart';
import 'package:community_app/bloc/post/post_state.dart';
import 'package:community_app/models/post.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            PostBloc(secureStorage: const FlutterSecureStorage())
              ..add(FetchPosts()),
        child: const PostList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostCard(post: post);
            },
          );
        } else if (state is PostError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No posts available'));
        }
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 40),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${post.user.firstName} ${post.user.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat.yMMMd()
                        .format(DateTime.parse(post.createdAt))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(post.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text(post.content),
            if (post.image != null && !(post.image == "")) ...[
              const SizedBox(height: 10),
              Image.network(
                '${Constants.baseUrl}/uploads/${post.image}',
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Failed to load image');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
