import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool hasShadow;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? borderRadius;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.hasShadow = true,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppTheme.cardColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusL),
        boxShadow: hasShadow ? AppTheme.softShadow : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusL),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingL),
            child: child,
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Gradient? gradient;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.iconColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      gradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            title,
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            description,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  value,
                  style: AppTheme.headingMedium.copyWith(color: color),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    subtitle!,
                    style: AppTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TherapistCard extends StatelessWidget {
  final Map<String, dynamic> therapist;
  final VoidCallback? onTap;

  const TherapistCard({
    super.key,
    required this.therapist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  therapist['name'] ?? 'Unknown',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  therapist['specialty'] ?? 'General Therapy',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text(
                      therapist['location'] ?? 'Location not specified',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.warningColor,
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text(
                      '${therapist['rating'] ?? 4.5}',
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Text(
                      '\$${therapist['hourlyRate'] ?? 150}/hr',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.textLight,
          ),
        ],
      ),
    );
  }
}
