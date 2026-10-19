import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import './auth/login_screen.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/profile/profile_cubit.dart';
import '../blocs/profile/profile_state.dart';
import '../../domain/repositories/profile_unlock_service.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../widgets/profile/profile_activity_summary.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<ProfileUnlockResult>? _unlock;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _unlock ??= getIt<ProfileUnlockService>().unlock('biometricReason'.tr());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileUnlockResult>(
      future: _unlock,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == ProfileUnlockResult.denied) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 12),
                Text('profileLocked'.tr()),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => setState(() {
                    _unlock = getIt<ProfileUnlockService>().unlock(
                      'biometricReason'.tr(),
                    );
                  }),
                  child: Text('retryButton'.tr()),
                ),
              ],
            ),
          );
        }
        return _profileContent();
      },
    );
  }

  Widget _profileContent() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
      ],
      child: const ProfileBodyWidget(),
    );
  }
}

class ProfileBodyWidget extends StatelessWidget {
  const ProfileBodyWidget({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('logoutConfirmTitle'.tr()),
        content: Text('logoutConfirmMessage'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: Text(
              'confirm'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthRepository>().currentUser;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              context.read<CartBloc>().add(const CartCleared());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            final message = switch (state) {
              ProfilePhotoUpdated() => 'profilePhotoUpdated'.tr(),
              ProfileFailure(:final messageKey) => messageKey.tr(),
              _ => null,
            };
            if (message != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          },
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'profileTitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final photoUrl = state.photoUrl ?? user?.photoUrl;
              final loading = state is ProfileLoading;
              return Center(
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: photoUrl == null
                          ? null
                          : NetworkImage(photoUrl),
                      child: photoUrl == null
                          ? const Icon(Icons.person_outline_rounded, size: 44)
                          : null,
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: FloatingActionButton.small(
                        onPressed: loading
                            ? null
                            : () => context
                                  .read<ProfileCubit>()
                                  .chooseAndUploadPhoto(),
                        tooltip: 'changeProfilePhoto'.tr(),
                        child: loading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Icon(Icons.photo_camera_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              user?.displayName ?? 'profileNameFallback'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: 4),
            Center(
              child: Text(
                user!.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          if (user != null) ProfileActivitySummary(userId: user.id),
          const SizedBox(height: 32),

          // Theme selector
          Text(
            'themeLabel'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('themeLight'.tr()),
                    icon: const Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('themeSystem'.tr()),
                    icon: const Icon(Icons.settings_suggest_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('themeDark'.tr()),
                    icon: const Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (selected) =>
                    context.read<ThemeCubit>().setTheme(selected.first),
              );
            },
          ),
          const SizedBox(height: 32),

          // Language selector
          Text(
            'languageLabel'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'en', label: Text('languageEnglish'.tr())),
              ButtonSegment(value: 'ar', label: Text('languageArabic'.tr())),
            ],
            selected: {context.locale.languageCode},
            onSelectionChanged: (selected) =>
                context.setLocale(Locale(selected.first)),
          ),
          const SizedBox(height: 48),

          // Logout
          OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              'logoutButton'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.error),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
