import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/base_provider.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? asyncOnPressed;
  final bool isEnabled;
  final bool useProviderLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final EdgeInsets padding;

  const CustomButton({
    super.key,
    required this.text,
    this.asyncOnPressed,
    this.isEnabled = true,
    this.useProviderLoading = true, // Uses BaseProvider's loading state
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.borderRadius = 8.0,
    this.textStyle,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseProvider>(context, listen: true);
    final bool isButtonLoading =
        useProviderLoading && baseProvider.isButtonLoading;

    return GestureDetector(
      onTap: !isEnabled || isButtonLoading
          ? null
          : () async {
              if (asyncOnPressed != null) {
                if (useProviderLoading) baseProvider.startButtonLoading();
                await asyncOnPressed!();
                if (useProviderLoading) baseProvider.stopButtonLoading();
              }
            },
      child: Card(
        elevation: 2,
        color: !isEnabled && !isButtonLoading
            ? (disabledBackgroundColor ?? Colors.grey) // Use disabled color
            : (backgroundColor ?? Theme.of(context).primaryColor),
        child: Container(
          width: width,
          height: height ?? 50,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
          child: isButtonLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: textStyle ??
                            TextStyle(
                              color: !isEnabled
                                  ? (disabledTextColor ??
                                      Colors.white.withValues(alpha: 0.6))
                                  : (textColor ?? Colors.white),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
