import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    // محاكاة تسجيل دخول المشرف المالي (أ. سليمان الراجحي)
    if (email.trim().isNotEmpty && password.isNotEmpty) {
      final user = const UserEntity(
        id: 'usr_01',
        name: 'أ. سليمان الراجحي',
        email: 'admin@barwah.com',
        role: UserRole.financialSupervisor,
        roleBadgeCode: '#CF0-01',
      );
      emit(AuthSuccess(user));
    } else {
      emit(const AuthError('يرجى إدخال البريد الإلكتروني وكلمة المرور'));
    }
  }
}