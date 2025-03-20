import 'package:community_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_app/features/home/presentation/bloc/profile/profile_bloc.dart';
import 'package:community_app/components/post_card.dart';
import 'package:community_app/utility/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(secureStorage: const FlutterSecureStorage())
            ..add(FetchProfile()),
      child: Scaffold(
        backgroundColor: AppColors.bggreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.barColor,
          title: const Text('Profile',style: TextStyle(color: AppColors.whiteColor)),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final profileData = state.profileData;
              final posts = state.posts;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 150,
                          color: const Color.fromARGB(255, 207, 207, 207),
                        ),
                        Positioned(
                          top: 80,
                          left: MediaQuery.of(context).size.width / 2 - 60,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                '${Constants.baseUrl}/uploads/${profileData['image']}'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
                    Text(
                      '${profileData['firstName']} ${profileData['lastName']}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เข้าร่วมเมื่อ ${profileData['createdAt']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'ศึกษาที่ ไม่เรียน เป็นคนสอบ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'เกิดเมื่อ ไม่รู้',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ]),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      shadowColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(profileData['address']?['street'] ?? 'ไม่มี'),
                            Text(profileData['address']?['city'] ?? 'ไม่มี'),
                            Text(profileData['address']?['state'] ?? 'ไม่มี'),
                            Text(profileData['address']?['zipCode'] ?? 'ไม่มี'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'My Posts',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: posts[index]);
                      },
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Failed to load profile data'));
            }
          },
        ),
      ),
    );
  }
}
