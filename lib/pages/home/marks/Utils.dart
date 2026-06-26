import 'package:flutter/material.dart';
import 'package:school_mate/l10n/app_localizations.dart';

List<Color> markColors = [
  const Color(0xFF00C000),
  const Color(0xFF00C000),
  const Color(0xFFBDBD00),
  const Color(0xFFFFC000),
  const Color(0xFFFFA000),
  const Color(0xFFFF6400),
  const Color(0xFFB00000),
];

Color getMarkColor({
  required int bestMark,
  required int worstMark,
  required double? valueMark,
  required List<Color> colors,
}) {
  if (valueMark == null || int.tryParse(valueMark.toString()) == 0) {
    return Colors.grey;
  }

  if (bestMark == worstMark || colors.isEmpty) {
    throw ArgumentError("Invalid mark range or empty color list.");
  }

  final markRange = (worstMark - bestMark).abs();
  final colorSteps = colors.length - 1;

  // Normalize based on whether bestMark is lower or higher than worstMark
  double normalizedValue = (valueMark - bestMark) / (worstMark - bestMark);

  // If the scale is descending (e.g., 1 = best), we need to reverse it
  if (bestMark > worstMark) {
    normalizedValue = 1.0 - normalizedValue;
  }

  normalizedValue = normalizedValue.clamp(0.0, 1.0);

  int colorIndex = (normalizedValue * colorSteps).round();

  return colors[colorIndex.clamp(0, colorSteps)];
}

List<String> getStudyTips(AppLocalizations l10n) => [
      l10n.studyTip1,
      l10n.studyTip2,
      l10n.studyTip3,
      l10n.studyTip4,
      l10n.studyTip5,
      l10n.studyTip6,
      l10n.studyTip7,
      l10n.studyTip8,
      l10n.studyTip9,
      l10n.studyTip10,
      l10n.studyTip11,
      l10n.studyTip12,
      l10n.studyTip13,
      l10n.studyTip14,
      l10n.studyTip15,
      l10n.studyTip16,
      l10n.studyTip17,
      l10n.studyTip18,
      l10n.studyTip19,
      l10n.studyTip20,
    ];

List<String> getMotivationalQuotes(AppLocalizations l10n) => [
      l10n.motivationalQuote1,
      l10n.motivationalQuote2,
      l10n.motivationalQuote3,
      l10n.motivationalQuote4,
      l10n.motivationalQuote5,
      l10n.motivationalQuote6,
      l10n.motivationalQuote7,
      l10n.motivationalQuote8,
      l10n.motivationalQuote9,
      l10n.motivationalQuote10,
      l10n.motivationalQuote11,
      l10n.motivationalQuote12,
      l10n.motivationalQuote13,
      l10n.motivationalQuote14,
      l10n.motivationalQuote15,
      l10n.motivationalQuote16,
      l10n.motivationalQuote17,
      l10n.motivationalQuote18,
      l10n.motivationalQuote19,
      l10n.motivationalQuote20,
    ];
