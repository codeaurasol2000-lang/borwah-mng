import 'package:flutter/widgets.dart';
import '../../../../l10n/app_localizations.dart';

class FinanceLocalizer {
  static String localizeBankName(BuildContext context, String bankName) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return bankName;
    if (bankName.contains('الراجحي')) return l10n.alRajhiBankName;
    if (bankName.contains('الأهلي')) return l10n.snbBankName;
    if (bankName.contains('الرياض')) return l10n.riyadBankName;
    if (bankName.contains('مدى') || bankName.contains('Mada')) {
      return l10n.madaGatewayName;
    }
    if (bankName.contains('STC')) return l10n.stcPayWalletName;
    return bankName;
  }

  static String localizeAccountType(BuildContext context, String accountType) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return accountType;
    if (accountType.contains('ضمان') || accountType.contains('Escrow')) {
      return l10n.escrowAccountType;
    }
    if (accountType.contains('تشغيلي')) return l10n.operatingAccountType;
    if (accountType.contains('بوابة دفع')) {
      return l10n.electronicPaymentGatewayType;
    }
    if (accountType.contains('رقمية')) return l10n.digitalWalletType;
    return accountType;
  }

  static String localizePackageName(BuildContext context, String packageName) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return packageName;
    if (packageName.contains('الذهبية')) return l10n.goldenAnnualPackage;
    if (packageName.contains('احترافي')) return l10n.proServiceProvider;
    if (packageName.contains('VIP')) return l10n.vipAnnualPackage;
    if (packageName.contains('اللامحدود')) return l10n.unlimitedDeliveryPackage;
    if (packageName.contains('أسبوع')) return l10n.featuredWeekPackage;
    return packageName;
  }

  static String localizePaymentMethod(BuildContext context, String method) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return method;
    if (method.contains('سداد') || method.contains('الراجحي')) {
      return l10n.directBankTransferSadad;
    }
    if (method.contains('المحفظة الضامنة') || method.contains('Escrow')) {
      return l10n.directDebitEscrow;
    }
    if (method.contains('الائتمانية') || method.contains('Mada')) {
      return l10n.creditCardMada;
    }
    if (method.contains('خصم من المحفظة')) return l10n.walletDeduction;
    if (method.contains('الأهلي')) return l10n.directBankTransferSnb;
    return method;
  }

  static String localizeProviderName(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return name;
    if (name.contains('النخبة')) return l10n.eliteElectronicsStore;
    if (name.contains('ورشة الصيانة')) return l10n.maintenanceWorkshop;
    if (name.contains('VIP')) return l10n.vipUserUpgrade;
    if (name.contains('المندوب السريع')) return l10n.fastCourierPackage;
    if (name.contains('بانر رئيسي')) return l10n.mainBannerAd;
    return name;
  }

  static String localizeCategoryName(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return category;
    if (category.contains('تاجر مميز')) return l10n.featuredMerchantSubscription;
    if (category.contains('خدمات منزلية')) return l10n.homeServicesProvider;
    if (category.contains('مستخدم مميز')) return l10n.premiumUser;
    if (category.contains('مندوب توصيل')) return l10n.deliveryCourier;
    if (category.contains('إعلانات تجارية')) return l10n.commercialAds;
    return category;
  }

  static String? localizeAvailableBalance(BuildContext context, String? balance) {
    if (balance == null) return null;
    final l10n = AppLocalizations.of(context);
    if (l10n == null || l10n.localeName.startsWith('ar')) return balance;
    final clean =
        balance.replaceAll('رصيد متاح', '').replaceAll('ر.س', '').trim();
    return '${l10n.availableBalanceLabel}: $clean ${l10n.currencySar}';
  }
}
