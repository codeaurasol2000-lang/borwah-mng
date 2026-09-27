import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../presentation/screens/finance_dashboard_screen.dart';
import '../../domain/entities/user_role.dart';
import '../controllers/auth_cubit.dart';
import '../controllers/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@barwah.com');
  final _passwordController = TextEditingController(text: '••••••••••••');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.user.role == UserRole.financialSupervisor) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FinanceDashboardScreen()),
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الشعار في بطاقة بيضاء دائرية
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // عنوان النظام
                    const Text(
                      'برواح المازوري',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'نظام الإدارة والإشراف الميداني',
                      style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),

                    // شارة بوابة تسجيل الدخول
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_user_rounded, size: 16, color: AppColors.info),
                          SizedBox(width: 6),
                          Text('بوابة تسجيل دخول آمنة ومشفّرة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // بطاقة الحقول
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // حقل البريد
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('البريد الإلكتروني الوظيفي', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                SizedBox(width: 6),
                                Icon(Icons.mail_outline, size: 18, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // حقل كلمة المرور
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('كلمة المرور', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                SizedBox(width: 6),
                                Icon(Icons.lock_outline, size: 18, color: AppColors.textSecondary),
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
                              fillColor: const Color(0xFFF8FAFC),
                              prefixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // صندوق التنبيه بالرتب
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.hub_outlined, color: AppColors.info, size: 22),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'يتم تحديد واجهة العمل وصلاحيات النظام تلقائياً حسب الرتبة الإشرافية فور التحقق.',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // زر تسجيل الدخول
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: state is AuthLoading
                                  ? null
                                  : () => context.read<AuthCubit>().login(
                                _emailController.text,
                                _passwordController.text,
                              ),
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(width: 8),
                                  Icon(Icons.login, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // استعادة الوصول
                          const Center(
                            child: Text(
                              'نسيت كلمة المرور؟\nطلب استعادة الوصول عبر المسؤول التقني',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.info, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // حقوق النظام بالأسفل
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('هذا التطبيق مخصص للإدارة والمشرفين فقط', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        SizedBox(width: 4),
                        Icon(Icons.lock_person_outlined, size: 14, color: AppColors.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'الإصدار 3.4.0 (داخلي) • جميع الحقوق محفوظة لشركة برواح المازوري',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}