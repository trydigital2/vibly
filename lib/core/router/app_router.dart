import 'package:go_router/go_router.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/chat/chat_detail_screen.dart';
import '../../features/main_nav/main_navigation_shell.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile_setup/profile_setup_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const MainNavigationShell(),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      builder: (context, state) {
        final matchId = state.pathParameters['matchId'] ?? 'm_1';
        return ChatDetailScreen(matchId: matchId);
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

 