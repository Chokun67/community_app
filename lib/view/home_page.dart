import 'dart:io';
import 'package:community_app/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    return BlocProvider(
      create: (context) => PostBloc(secureStorage: const FlutterSecureStorage())
        ..add(FetchPosts()),
      child: Scaffold(
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
        body: Column(
          children: [
            _CreatePostBox(),
            const Expanded(child: PostList()),
          ],
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
      ),
    );
  }
}

class _CreatePostBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final postBloc = BlocProvider.of<PostBloc>(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BlocProvider.value(
              value: postBloc,
              child: _CreatePostDialog(),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text('คุณกำลังคิดอะไร'),
      ),
    );
  }
}

class _CreatePostDialog extends StatefulWidget {
  @override
  __CreatePostDialogState createState() => __CreatePostDialogState();
}

class __CreatePostDialogState extends State<_CreatePostDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  XFile? _image;
  List<dynamic> categories = [];
  List<int> selectedCategoryIds = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Constants.baseUrl}/categories'));
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = MediaQuery.of(context).size.width * 0.95;
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostLoaded) {
          Navigator.of(context).pop();
        } else if (state is PostError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add post: ${state.message}'),
            backgroundColor: Colors.red,
          ));
        }
      },
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: 'Content'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        hint: const Text('Select Category'),
                        value: selectedCategoryId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategoryId = newValue;
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((dynamic category) {
                          return DropdownMenuItem<String>(
                            value: category['id'].toString(),
                            child: Text(category['name']),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedCategoryId != null &&
                              !selectedCategoryIds
                                  .contains(int.parse(selectedCategoryId!))) {
                            setState(() {
                              selectedCategoryIds
                                  .add(int.parse(selectedCategoryId!));
                            });
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: selectedCategoryIds.map<Widget>((int categoryId) {
                      final categoryName = categories.firstWhere(
                          (category) => category['id'] == categoryId)['name'];
                      return Chip(
                        label: Text(categoryName),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  _image == null
                      ? const Text('No image selected.')
                      : Image.file(File(_image!.path)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {
                        _image = pickedFile;
                      });
                    },
                    child: const Text('Select Image'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = _titleController.text;
                final content = _contentController.text;
                BlocProvider.of<PostBloc>(context).add(AddPost(
                  title: title,
                  content: content,
                  categoryIds: selectedCategoryIds,
                  image: _image,
                ));
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
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
            Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              runSpacing: 4.0, // Vertical spacing between rows of chips
              children: post.categories.map<Widget>((category) {
                return Chip(
                  label: Text(category.name),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Text(post.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text(post.content),
            if (post.image != null) ...[
              const SizedBox(height: 10),
              Image.network('${Constants.baseUrl}/uploads/${post.image}'),
            ],
          ],
        ),
      ),
    );
  }
}
