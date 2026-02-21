enum CardType { visa, mastercard, amex, discover, unknown }

class CreditCardValidator {
  CreditCardValidator._();

  static CardType detectCardType(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.isEmpty) return CardType.unknown;

    if (cleanNumber.startsWith('4')) {
      return CardType.visa;
    }

    if (cleanNumber.length >= 2) {
      final firstTwo = int.tryParse(cleanNumber.substring(0, 2)) ?? 0;
      if (firstTwo >= 51 && firstTwo <= 55) {
        return CardType.mastercard;
      }
      if (cleanNumber.length >= 4) {
        final firstFour = int.tryParse(cleanNumber.substring(0, 4)) ?? 0;
        if (firstFour >= 2221 && firstFour <= 2720) {
          return CardType.mastercard;
        }
      }
    }

    if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
      return CardType.amex;
    }

    if (cleanNumber.startsWith('6011') ||
        cleanNumber.startsWith('65') ||
        (cleanNumber.length >= 3 &&
            int.tryParse(cleanNumber.substring(0, 3)) != null &&
            int.parse(cleanNumber.substring(0, 3)) >= 644 &&
            int.parse(cleanNumber.substring(0, 3)) <= 649)) {
      return CardType.discover;
    }

    return CardType.unknown;
  }

  static bool isValidCardNumber(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    return _luhnCheck(cleanNumber);
  }

  static bool _luhnCheck(String number) {
    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  static int expectedLength(CardType type) {
    switch (type) {
      case CardType.amex:
        return 15;
      case CardType.visa:
      case CardType.mastercard:
      case CardType.discover:
        return 16;
      case CardType.unknown:
        return 16;
    }
  }

  static bool isValidCvv(String cvv, CardType cardType) {
    final cleanCvv = cvv.replaceAll(RegExp(r'\D'), '');
    final expectedLength = cardType == CardType.amex ? 4 : 3;
    return cleanCvv.length == expectedLength;
  }

  static bool isValidExpiry(String expiry) {
    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear) return false;
    if (year == currentYear && month < currentMonth) return false;

    return true;
  }
}
