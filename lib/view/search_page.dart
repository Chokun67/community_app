import 'package:community_app/bloc/auth/auth_bloc.dart';
import 'package:community_app/bloc/auth/auth_event.dart';
import 'package:community_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_app/bloc/search/search_bloc.dart';
import 'package:community_app/components/post_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(secureStorage: const FlutterSecureStorage()),
      child: const SearchContent(),
    );
  }
}

class SearchContent extends StatefulWidget {
  const SearchContent({super.key}); // เพิ่ม key ใน constructor

  @override
  SearchContentState createState() => SearchContentState();
}

class SearchContentState extends State<SearchContent> {
  int _selectedCategoryId = 1;

  void _onCategorySelected(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    BlocProvider.of<SearchBloc>(context).add(FetchPostsByCategory(categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        title: const Text('Search',style: TextStyle(color: AppColors.whiteColor)),
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
          _CategoryNavigationBar(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: _onCategorySelected,
          ),
          const Expanded(child: _PostList()),
        ],
      ),
    );
  }
}

class _CategoryNavigationBar extends StatelessWidget {
  final int selectedCategoryId;
  final ValueChanged<int> onCategorySelected;

  const _CategoryNavigationBar({
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _CategoryButton(
          text: 'Sport',
          categoryId: 1,
          isSelected: selectedCategoryId == 1,
          onCategorySelected: onCategorySelected,
        ),
        _CategoryButton(
          text: 'News',
          categoryId: 2,
          isSelected: selectedCategoryId == 2,
          onCategorySelected: onCategorySelected,
        ),
        _CategoryButton(
          text: 'Entertainment',
          categoryId: 3,
          isSelected: selectedCategoryId == 3,
          onCategorySelected: onCategorySelected,
        ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String text;
  final int categoryId;
  final bool isSelected;
  final ValueChanged<int> onCategorySelected;

  const _CategoryButton({
    required this.text,
    required this.categoryId,
    required this.isSelected,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onCategorySelected(categoryId),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostCard(post: post);
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Select a category to view posts'));
        }
      },
    );
  }
}
