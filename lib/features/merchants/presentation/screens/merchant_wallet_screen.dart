import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

enum _WalletTransferMethod { instapay, wallet, bank }

class MerchantWalletScreen extends StatefulWidget {
  const MerchantWalletScreen({super.key});

  @override
  State<MerchantWalletScreen> createState() => _MerchantWalletScreenState();
}

class _MerchantWalletScreenState extends State<MerchantWalletScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '8450');
  _WalletTransferMethod _method = _WalletTransferMethod.instapay;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = l10n.localeName.startsWith('ar');

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n.merchantWalletTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: const [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 12),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primaryDark,
                child:
                    Icon(Icons.person_outline, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _buildStatus(l10n),
            const SizedBox(height: 18),
            _buildBalanceCard(l10n),
            const SizedBox(height: 8),
            _buildTotals(l10n),
            const SizedBox(height: 22),
            _buildSettlementInfo(l10n),
            const SizedBox(height: 22),
            _buildWithdrawalForm(l10n),
            const SizedBox(height: 22),
            _buildBonus(l10n),
            const SizedBox(height: 22),
            _buildTransactions(l10n),
            const SizedBox(height: 18),
            _buildAuditFooter(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            l10n.merchantWalletSupervisorStatus,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.info, fontSize: 10),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.circle, color: AppColors.info, size: 9),
      ],
    );
  }

  Widget _buildBalanceCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _pill(l10n.merchantWalletReady, const Color(0xFF183454)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.merchantWalletAvailableBalance,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ),
              const SizedBox(width: 7),
              const Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${l10n.merchantWalletAvailableAmount} ${l10n.finRequestCurrency}',
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.merchantWalletBalanceDescription,
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Color(0xFFB8C8DB), fontSize: 10, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            l10n.merchantWalletPendingDues,
            l10n.merchantWalletPendingAmount,
            Icons.hourglass_top,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _metricCard(
            l10n.merchantWalletTotalDues,
            l10n.merchantWalletTotalAmount,
            Icons.payments_outlined,
          ),
        ),
      ],
    );
  }

  Widget _metricCard(String label, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.info, size: 16),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.merchantWalletSettlementCycle,
              style: const TextStyle(color: AppColors.info, fontSize: 9),
            ),
          ),
          const Icon(Icons.show_chart, color: AppColors.info, size: 17),
          const SizedBox(width: 6),
          Text(
            l10n.merchantWalletReadiness,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawalForm(AppLocalizations l10n) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionHeader(
            l10n.merchantWalletWithdrawTitle,
            Icons.currency_exchange,
            trailing: l10n.merchantWalletNoTransferFees,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.merchantWalletRequestedAmount,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 10),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.merchantWalletFullBalance,
                style: const TextStyle(color: AppColors.info, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              suffixText: l10n.finRequestCurrency,
              filled: true,
              fillColor: const Color(0xFFF1F3F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            l10n.merchantWalletTransferLimit,
            textAlign: TextAlign.end,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.merchantWalletChooseMethod,
            textAlign: TextAlign.end,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _methodCard(
                  _WalletTransferMethod.bank,
                  Icons.account_balance_outlined,
                  l10n.merchantWalletBankTransfer,
                  l10n.merchantWalletIban,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _methodCard(
                  _WalletTransferMethod.wallet,
                  Icons.phone_iphone_outlined,
                  l10n.merchantWalletDigitalWallet,
                  l10n.merchantWalletWalletProvider,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _methodCard(
                  _WalletTransferMethod.instapay,
                  Icons.bolt,
                  l10n.merchantWalletInstantTransfer,
                  l10n.merchantWalletInstant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            _method == _WalletTransferMethod.bank
                ? l10n.merchantWalletIban
                : l10n.merchantWalletTransferAddress,
            textAlign: TextAlign.end,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          ),
          const SizedBox(height: 6),
          _detailField(
            icon: _method == _WalletTransferMethod.bank
                ? Icons.account_balance_outlined
                : Icons.alternate_email,
            value: _method == _WalletTransferMethod.bank
                ? l10n.merchantWalletIbanValue
                : _method == _WalletTransferMethod.wallet
                    ? l10n.merchantWalletPhoneValue
                    : l10n.merchantWalletInstantAddress,
          ),
          const SizedBox(height: 8),
          _detailField(
            icon: Icons.verified_user_outlined,
            value: l10n.merchantWalletAccountName,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.merchantWalletProcessingDetails,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 9, height: 1.7),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.schedule, color: AppColors.info, size: 15),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showUnavailable(l10n),
              icon: const Icon(Icons.currency_exchange, size: 18),
              label: Text(l10n.merchantWalletConfirmWithdrawal),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodCard(
    _WalletTransferMethod method,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final selected = _method == method;
    return InkWell(
      onTap: () => setState(() => _method = method),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(minHeight: 76),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primaryDark : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 19,
                color: selected ? Colors.white : AppColors.textSecondary),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white70 : AppColors.textMuted,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailField({required IconData icon, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(value,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: AppColors.info, size: 17),
        ],
      ),
    );
  }

  Widget _buildBonus(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.merchantWalletBonusTitle,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.merchantWalletBonusDescription,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 9, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: Color(0xFFD8E6FF),
            child:
                Icon(Icons.workspace_premium_outlined, color: AppColors.info),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.merchantWalletTransactionHistory,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 7),
            const Icon(Icons.history, color: AppColors.info, size: 17),
          ],
        ),
        const SizedBox(height: 8),
        _transaction(
          icon: Icons.account_balance_outlined,
          title: l10n.merchantWalletTransactionBank,
          date: l10n.merchantWalletTransactionDateOne,
          amount: l10n.merchantWalletTransactionAmountOne,
          l10n: l10n,
        ),
        const SizedBox(height: 7),
        _transaction(
          icon: Icons.bolt,
          title: l10n.merchantWalletTransactionInstant,
          date: l10n.merchantWalletTransactionDateTwo,
          amount: l10n.merchantWalletTransactionAmountTwo,
          l10n: l10n,
        ),
      ],
    );
  }

  Widget _transaction({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required AppLocalizations l10n,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(amount,
                  style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(l10n.finRequestCurrency,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 8)),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: AppColors.primaryDark, fontSize: 10)),
                Text(date,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 9)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _pill(l10n.merchantWalletCompleted, const Color(0xFFE8EAED)),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF0F2F4),
            child: Icon(icon, color: AppColors.primaryDark, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditFooter(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.merchantWalletAuditNotice,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.merchantWalletAuditCode,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon, {String? trailing}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.info, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 6),
          _pill(trailing, const Color(0xFFEAF1FB)),
        ],
      ],
    );
  }

  Widget _pill(String text, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.info,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }

  void _showUnavailable(AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.merchantWalletActionUnavailable)),
      );
  }
}
