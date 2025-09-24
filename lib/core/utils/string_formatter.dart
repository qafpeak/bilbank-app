String formatNumber(int value) {
  if (value >= 1000000) {
    double mValue = value / 1000000;
    return mValue % 1 == 0
        ? '${mValue.toInt()}m'
        : '${mValue.toStringAsFixed(1)}m';
  } else if (value >= 1000) {
    double kValue = value / 1000;
    return kValue % 1 == 0
        ? '${kValue.toInt()}k'
        : '${kValue.toStringAsFixed(1)}k';
  } else {
    return value.toString();
  }
}
