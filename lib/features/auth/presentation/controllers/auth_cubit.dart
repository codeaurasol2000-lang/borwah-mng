import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static const _accounts = <String, _RoleAccount>{
    'admin': _RoleAccount(UserRole.admin, 'مدير النظام', '#ADM-01'),
    'head':
        _RoleAccount(UserRole.headOfSupervisors, 'رئيس المشرفين', '#HOS-01'),
    'merchant':
        _RoleAccount(UserRole.merchantSupervisor, 'مشرف التجار', '#MER-01'),
    'wasalny':
        _RoleAccount(UserRole.wasalnySupervisor, 'مشرف وصلني', '#WAS-01'),
    'services':
        _RoleAccount(UserRole.servicesSupervisor, 'مشرف الخدمات', '#SRV-01'),
    'products':
        _RoleAccount(UserRole.productSupervisor, 'مشرف المنتجات', '#PRD-01'),
    'finance':
        _RoleAccount(UserRole.financialSupervisor, 'المشرف المالي', '#FIN-01'),
  };

  AuthCubit() : super(AuthInitial());

  void logout() => emit(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final emailParts = normalizedEmail.split('@');
    if (emailParts.length != 2 ||
        emailParts.first.isEmpty ||
        emailParts.last.isEmpty ||
        password.trim().isEmpty) {
      emit(const AuthError('يرجى إدخال البريد الإلكتروني وكلمة المرور'));
      return;
    }

    final account = _accounts[emailParts.first];
    if (account == null) {
      emit(const AuthError(
          'البريد غير مرتبط بدور متاح. تحقق من بادئة البريد الإلكتروني.'));
      return;
    }

    emit(AuthSuccess(UserEntity(
      id: 'usr_${emailParts.first}_01',
      name: account.name,
      email: normalizedEmail,
      role: account.role,
      roleBadgeCode: account.badgeCode,
    )));
  }
}

class _RoleAccount {
  final UserRole role;
  final String name;
  final String badgeCode;

  const _RoleAccount(this.role, this.name, this.badgeCode);
}
