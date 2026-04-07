import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/profile_feature/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile_feature/presentation/widgets/list_tile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileCubit>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text('My Profile', style: AppTextStyles.appBarTitle1),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: SizedBox(
                    height: screenSize.height * 0.26,
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(AssetImages.profilePageShapeImage),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: AppColors.lightBlueColor,
                                  child: ClipOval(
                                    child:
                                        state.user.image != null &&
                                            state.user.image!.isNotEmpty
                                        ? Image.network(
                                            state.user.image!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Icon(
                                              Icons.person_outline,
                                              size: 60,
                                              color: AppColors.navyColor,
                                            ),
                                            loadingBuilder:
                                                (context, child, progress) {
                                                  if (progress == null) {
                                                    return child;
                                                  }
                                                  return Icon(
                                                    Icons.person_outline,
                                                    size: 60,
                                                    color: AppColors.navyColor,
                                                  );
                                                },
                                          )
                                        : Icon(
                                            Icons.person_outline,
                                            size: 60,
                                            color: AppColors.navyColor,
                                          ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  state.user.name ?? 'Your Name',
                                  style: AppTextStyles.heading1,
                                ),
                                Text(
                                  '@${state.user.name ?? '@user_name'}',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.greyScaleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTileWidget(
                            leadingIcon: Icons.person_2_outlined,
                            title: 'Account Preferences',
                            trailingWidget: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.payment,
                            title: 'Subscription & Payment',
                            trailingWidget: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.notifications_active_outlined,
                            title: 'App Notifications',
                            trailingWidget: Switch(
                              value: true,
                              onChanged: (value) {},
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.mode_night_outlined,
                            title: 'Dark Mode',
                            trailingWidget: Switch(
                              value: false,
                              onChanged: (value) {},
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.star_border_outlined,
                            title: 'Rate Us',
                            trailingWidget: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.feedback_outlined,
                            title: 'Provide Feedback',
                            trailingWidget: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                          ListTileWidget(
                            leadingIcon: Icons.logout_outlined,
                            title: 'Log Out',
                            trailingWidget: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Loader();
        },
      ),
    );
  }
}
