import 'dart:async';

/// قاعدة بيانات وهمية مركزية وموحدة لجميع الأدوار (المشرف المالي، المشرفين، التجار)
class UnifiedMockDatabase {
  UnifiedMockDatabase._internal() {
    _initInitialData();
  }

  static final UnifiedMockDatabase instance = UnifiedMockDatabase._internal();

  // Streams لإرسال التحديثات الحية لجميع الشاشات
  final _financeStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get financeStream => _financeStreamController.stream;

  // 1. البيانات المخزنة بقاعدة البيانات
  double _totalCompanyBalance = 150000.00;
  double _pendingWithdrawalsAmount = 12500.00;

  final List<Map<String, dynamic>> _merchants = [
    {
      'id': 'm1',
      'name': 'متجر كيدز زون (Kid Zone)',
      'balance': 4500.00,
      'status': 'active',
    },
    {
      'id': 'm2',
      'name': 'متجر الأناقة',
      'balance': 8000.00,
      'status': 'active',
    },
  ];

  final List<Map<String, dynamic>> _withdrawalRequests = [
    {
      'id': 'req_101',
      'merchantId': 'm1',
      'merchantName': 'متجر كيدز زون (Kid Zone)',
      'amount': 1500.00,
      'status': 'pending',
      'createdAt': '2026-10-14 10:00 AM',
    },
    {
      'id': 'req_102',
      'merchantId': 'm2',
      'merchantName': 'متجر الأناقة',
      'amount': 3000.00,
      'status': 'pending',
      'createdAt': '2026-10-14 11:30 AM',
    },
  ];

  void _initInitialData() {
    _notifyChanges();
  }

  void _notifyChanges() {
    _financeStreamController.add(getFinanceSummary());
  }

  Map<String, dynamic> getFinanceSummary() {
    return {
      'totalBalance': _totalCompanyBalance,
      'pendingWithdrawals': _pendingWithdrawalsAmount,
      'activeMerchantsCount': _merchants.length,
      'pendingRequestsCount': _withdrawalRequests.where((r) => r['status'] == 'pending').length,
    };
  }

  List<Map<String, dynamic>> getWithdrawalRequests() {
    return List.unmodifiable(_withdrawalRequests);
  }

  List<Map<String, dynamic>> getMerchants() {
    return List.unmodifiable(_merchants);
  }

  Future<bool> approveWithdrawalRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _withdrawalRequests.indexWhere((r) => r['id'] == requestId);
    if (index != -1 && _withdrawalRequests[index]['status'] == 'pending') {
      final request = _withdrawalRequests[index];
      final double amount = (request['amount'] as num).toDouble();
      final String merchantId = request['merchantId'];

      _withdrawalRequests[index]['status'] = 'approved';

      final mIndex = _merchants.indexWhere((m) => m['id'] == merchantId);
      if (mIndex != -1) {
        _merchants[mIndex]['balance'] = (_merchants[mIndex]['balance'] as num).toDouble() - amount;
      }

      _pendingWithdrawalsAmount -= amount;
      _totalCompanyBalance -= amount;

      _notifyChanges();
      return true;
    }
    return false;
  }

  Future<bool> rejectWithdrawalRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _withdrawalRequests.indexWhere((r) => r['id'] == requestId);
    if (index != -1 && _withdrawalRequests[index]['status'] == 'pending') {
      final double amount = (_withdrawalRequests[index]['amount'] as num).toDouble();

      _withdrawalRequests[index]['status'] = 'rejected';
      _pendingWithdrawalsAmount -= amount;

      _notifyChanges();
      return true;
    }
    return false;
  }

  Future<bool> submitWithdrawalRequest(String merchantId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final merchant = _merchants.firstWhere((m) => m['id'] == merchantId, orElse: () => {});
    if (merchant.isNotEmpty && (merchant['balance'] as num).toDouble() >= amount) {
      final newReq = {
        'id': 'req_\${DateTime.now().millisecondsSinceEpoch}',
        'merchantId': merchantId,
        'merchantName': merchant['name'],
        'amount': amount,
        'status': 'pending',
        'createdAt': DateTime.now().toString().split('.')[0],
      };

      _withdrawalRequests.add(newReq);
      _pendingWithdrawalsAmount += amount;

      _notifyChanges();
      return true;
    }
    return false;
  }
}
