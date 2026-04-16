import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/features/home/presentation/cubits/theme_cubit/theme_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Add this

import 'package:marketi_app/core/constants/asset_images.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile/presentation/widgets/list_tile_widget.dart';

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

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bool isLoading = state is ProfileLoading;

        final user = (state is ProfileSuccess) ? state.user : null;

        final userName = isLoading
            ? 'Loading Full Name'
            : (user?.name ?? 'Guest User');
        final userHandle = isLoading
            ? '@loading_handle'
            : '@${user?.name ?? 'guest'}';
        final userImage = isLoading ? '' : (user?.image ?? '');

        return Skeletonizer(
          enabled: isLoading,
          ignoreContainers: true, // Keeps your custom shapes clean
          child: Column(
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
                                child: ClipOval(
                                  child: userImage.isNotEmpty
                                      ? Image.network(
                                          userImage,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              _buildPlaceholder(),
                                        )
                                      : _buildPlaceholder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userName,
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium,
                              ),
                              Text(
                                userHandle,
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(color: AppColors.greyScaleColor),
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
                child: ListView(
                  physics: isLoading
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  children: [
                    _buildItem(
                      Icons.person_2_outlined,
                      'Account Preferences',
                      () {},
                    ),
                    _buildItem(
                      Icons.receipt_long_outlined,
                      'Orders History',
                      () {
                        context.push(AppRoutes.orderHistoryPage);
                      },
                    ),
                    ListTileWidget(
                      leadingIcon: Icons.notifications_active_outlined,
                      title: 'App Notifications',
                      trailingWidget: Switch(value: true, onChanged: (v) {}),
                      onTab: () {},
                    ),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, state) {
                        bool isDarkMode = state == ThemeMode.dark;
                        return ListTileWidget(
                          leadingIcon: Icons.mode_night_outlined,
                          title: 'Dark Mode',
                          trailingWidget: Switch(
                            value: isDarkMode,
                            onChanged: (value) {
                              context.read<ThemeCubit>().toggleTheme(value);
                            },
                          ),
                          onTab: () {
                            context.read<ThemeCubit>().toggleTheme(!isDarkMode);
                          },
                        );
                      },
                    ),
                    _buildItem(Icons.star_border_outlined, 'Rate Us', () {}),
                    _buildItem(
                      Icons.feedback_outlined,
                      'Provide Feedback',
                      () {},
                    ),
                    _buildItem(Icons.logout_outlined, 'Log Out', () {}),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(Icons.person_outline, size: 60);
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTab) {
    return ListTileWidget(
      leadingIcon: icon,
      title: title,
      trailingWidget: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.keyboard_arrow_right),
      ),
      onTab: onTab,
    );
  }
}
