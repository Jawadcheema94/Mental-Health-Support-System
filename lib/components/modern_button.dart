import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, secondary, outline, ghost }
enum ButtonSize { small, medium, large }

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: _buildButtonContent(),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    final baseStyle = ElevatedButton.styleFrom(
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      padding: _getPadding(),
    );

    switch (variant) {
      case ButtonVariant.primary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppTheme.textLight;
            }
            if (states.contains(MaterialState.pressed)) {
              return AppTheme.primaryDark;
            }
            return AppTheme.primaryColor;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        );
      
      case ButtonVariant.secondary:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return AppTheme.textLight;
            }
            if (states.contains(MaterialState.pressed)) {
              return AppTheme.secondaryDark;
            }
            return AppTheme.secondaryColor;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        );
      
      case ButtonVariant.outline:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(AppTheme.primaryColor),
          side: MaterialStateProperty.all(
            const BorderSide(color: AppTheme.primaryColor, width: 1.5),
          ),
        );
      
      case ButtonVariant.ghost:
        return baseStyle.copyWith(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AppTheme.primaryColor.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
          foregroundColor: MaterialStateProperty.all(AppTheme.primaryColor),
        );
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingL,
          vertical: AppTheme.spacingM,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXL,
          vertical: AppTheme.spacingL,
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.outline || variant == ButtonVariant.ghost
                ? AppTheme.primaryColor
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: AppTheme.spacingS),
          Text(text, style: _getTextStyle()),
        ],
      );
    }

    return Text(text, style: _getTextStyle());
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: variant == ButtonVariant.outline || variant == ButtonVariant.ghost
          ? AppTheme.primaryColor
          : Colors.white,
    );

    switch (size) {
      case ButtonSize.small:
        return baseStyle.copyWith(fontSize: 14);
      case ButtonSize.medium:
        return baseStyle.copyWith(fontSize: 16);
      case ButtonSize.large:
        return baseStyle.copyWith(fontSize: 18);
    }
  }
}

// Specialized button variants for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      icon: icon,
      isLoading: isLoading,
      fullWidth: fullWidth,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: ButtonSize.large,
      icon: icon,
      isLoading: isLoading,
      fullWidth: fullWidth,
    );
  }
}
