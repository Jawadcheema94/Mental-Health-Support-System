import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class AllTherapistsScreen extends StatelessWidget {
  final List<dynamic> therapists;
  final String userId;

  const AllTherapistsScreen({
    super.key,
    required this.therapists,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern App Bar
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppTheme.radiusXL),
                    bottomRight: Radius.circular(AppTheme.radiusXL),
                  ),
                  boxShadow: AppTheme.mediumShadow,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      "All Therapists",
                      style: AppTheme.headingMedium.copyWith(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: therapists.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.psychology_outlined,
                              size: 64,
                              color: AppTheme.textLight,
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            Text(
                              "No therapists available",
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                        itemCount: therapists.length,
                        itemBuilder: (context, index) {
                          final therapist = therapists[index];
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: AppTheme.spacingM),
                            decoration: BoxDecoration(
                              gradient: AppTheme.cardGradient,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusL),
                              boxShadow: AppTheme.softShadow,
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/therapist_detail',
                                    arguments: {
                                      'therapist': therapist,
                                      'userId': userId,
                                    },
                                  );
                                },
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusL),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(AppTheme.spacingM),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: isSmallScreen ? 50 : 60,
                                        height: isSmallScreen ? 50 : 60,
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.primaryGradient,
                                          borderRadius: BorderRadius.circular(
                                              AppTheme.radiusRound),
                                          boxShadow: AppTheme.softShadow,
                                        ),
                                        child: Icon(
                                          Icons.psychology,
                                          color: Colors.white,
                                          size: isSmallScreen ? 24 : 28,
                                        ),
                                      ),
                                      const SizedBox(width: AppTheme.spacingM),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              therapist['name'] ?? 'Unknown',
                                              style: AppTheme.headingSmall
                                                  .copyWith(
                                                fontSize:
                                                    isSmallScreen ? 16 : 18,
                                              ),
                                            ),
                                            const SizedBox(
                                                height: AppTheme.spacingXS),
                                            Text(
                                              therapist['specialty'] ??
                                                  therapist['specialization'] ??
                                                  'General',
                                              style:
                                                  AppTheme.bodyMedium.copyWith(
                                                color: AppTheme.textSecondary,
                                                fontSize:
                                                    isSmallScreen ? 14 : 16,
                                              ),
                                            ),
                                            const SizedBox(
                                                height: AppTheme.spacingXS),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  color: AppTheme.warningColor,
                                                  size: isSmallScreen ? 16 : 18,
                                                ),
                                                const SizedBox(
                                                    width: AppTheme.spacingXS),
                                                Text(
                                                  "${therapist['rating'] ?? 4.5}",
                                                  style: AppTheme.bodySmall
                                                      .copyWith(
                                                    color:
                                                        AppTheme.textSecondary,
                                                    fontSize:
                                                        isSmallScreen ? 12 : 14,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: AppTheme.spacingS),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal:
                                                        AppTheme.spacingS,
                                                    vertical:
                                                        AppTheme.spacingXS,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.successColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppTheme.radiusS),
                                                  ),
                                                  child: Text(
                                                    'Available',
                                                    style: AppTheme.bodySmall
                                                        .copyWith(
                                                      color:
                                                          AppTheme.successColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(
                                            AppTheme.spacingS),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                              AppTheme.radiusS),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppTheme.primaryColor,
                                          size: isSmallScreen ? 16 : 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
