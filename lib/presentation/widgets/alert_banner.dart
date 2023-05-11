import 'package:alert_banner/exports.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

void showAlert(BuildContext context, String message, bool errorColor) {
  showAlertBanner(
    context,
    () {},
    Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: errorColor ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        message,
        style: font3.copyWith(color: Theme.of(context).colorScheme.onError),
        textAlign: TextAlign.center,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    alertBannerLocation: AlertBannerLocation.bottom,
    maxLength: MediaQuery.of(context).size.width / 3,
  );
}
