import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_locale_controller.dart';
import '../../../../core/widgets/app_brand_mark.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/theme_mode_menu_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import '../controllers/auth_cubit.dart';
import '../controllers/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onFinancialLogin;
  final VoidCallback? onMerchantLogin;
  final VoidCallback? onProductLogin;
  final VoidCallback? onWasalnyLogin;
  final VoidCallback? onServicesLogin;
  final VoidCallback? onHeadSupervisorLogin;

  const LoginScreen({
    super.key,
    required this.onFinancialLogin,
    this.onMerchantLogin,
    this.onProductLogin,
    this.onWasalnyLogin,
    this.onServicesLogin,
    this.onHeadSupervisorLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'finance@barwah.com');
  final _passwordController = TextEditingController(text: '••••••••••••');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _workspacePendingMessage(UserEntity user) {
    return 'تم التعرف على حساب ${user.name}، لكن واجهته لم تُجهز بعد.';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.user.role == UserRole.headOfSupervisors &&
              widget.onHeadSupervisorLogin != null) {
            widget.onHeadSupervisorLogin!();
          } else if (state.user.role == UserRole.financialSupervisor) {
            widget.onFinancialLogin();
          } else if (state.user.role == UserRole.merchantSupervisor &&
              widget.onMerchantLogin != null) {
            widget.onMerchantLogin!();
          } else if (state.user.role == UserRole.productSupervisor &&
              widget.onProductLogin != null) {
            widget.onProductLogin!();
          } else if (state.user.role == UserRole.wasalnySupervisor &&
              widget.onWasalnyLogin != null) {
            widget.onWasalnyLogin!();
          } else if (state.user.role == UserRole.servicesSupervisor &&
              widget.onServicesLogin != null) {
            widget.onServicesLogin!();
          } else {
            AppSnackBar.showInfo(context, _workspacePendingMessage(state.user));
          }
        } else if (state is AuthError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isArabic = l10n.localeName.startsWith('ar');
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final palette = context.appThemePalette;
        final colorScheme = Theme.of(context).colorScheme;

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor:
                isDark ? palette.background : const Color(0xFFF1F5F9),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ThemeModeMenuButton(),
                            OutlinedButton.icon(
                              onPressed: AppLocaleController.instance.toggle,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isDark
                                    ? palette.surfaceElevated
                                    : Colors.white,
                                side: BorderSide(
                                  color: isDark
                                      ? palette.border
                                      : Colors.grey.shade300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              icon: Icon(
                                Icons.language,
                                size: 16,
                                color: palette.accent,
                              ),
                              label: Text(
                                isArabic ? 'English' : 'العربية',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: palette.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? palette.surface : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const AppBrandMark(size: 72, iconSize: 40),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.appName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.appSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? palette.accentContainer
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.secureLoginPortal,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: isDark ? palette.surface : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.workEmail,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.mail_outline,
                                    size: 18,
                                    color: palette.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? palette.surfaceElevated
                                    : const Color(0xFFF8FAFC),
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: palette.textSecondary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.password,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.lock_outline,
                                    size: 18,
                                    color: palette.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? palette.surfaceElevated
                                    : const Color(0xFFF8FAFC),
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? palette.surfaceElevated
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.hub_outlined,
                                    color: AppColors.info,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.roleAccessNotice,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: palette.textSecondary,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? colorScheme.primary
                                      : AppColors.primaryDark,
                                  foregroundColor: colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () => context.read<AuthCubit>().login(
                                          _emailController.text,
                                          _passwordController.text,
                                        ),
                                child: state is AuthLoading
                                    ? CircularProgressIndicator(
                                        color: colorScheme.onPrimary,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.loginButton,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.login,
                                            color: colorScheme.onPrimary,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                '${l10n.forgotPassword}\n${l10n.requestAccessReset}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.info,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.restrictedAccessFooter,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: palette.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.lock_person_outlined,
                            size: 14,
                            color: palette.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.copyrightNotice,
                        style: TextStyle(
                          fontSize: 10,
                          color: palette.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
