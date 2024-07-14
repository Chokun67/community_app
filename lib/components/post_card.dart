import 'package:community_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:community_app/models/post.dart';
import 'package:community_app/utility/constants.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      color: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
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
