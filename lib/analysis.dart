// import 'package:flutter/material.dart';

// class AnxietyDepressionTestScreen extends StatefulWidget {
//   const AnxietyDepressionTestScreen({super.key});

//   @override
//   _AnxietyDepressionTestScreenState createState() =>
//       _AnxietyDepressionTestScreenState();
// }

// class _AnxietyDepressionTestScreenState
//     extends State<AnxietyDepressionTestScreen> {
//   final List<Question> questions = [
//     Question(
//       questionText: "Do you often feel nervous or anxious?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you find it hard to focus on tasks?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you feel sad or down most of the time?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you have difficulty sleeping?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you often feel tired or low on energy?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you experience sudden mood swings?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you avoid social interactions or gatherings?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you feel overwhelmed by small tasks?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you experience physical symptoms like headaches or stomach aches due to stress?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//     Question(
//       questionText: "Do you feel hopeless or have thoughts of self-doubt frequently?",
//       options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
//     ),
//   ];

//   final Map<int, int> _responses = {};
//   int _score = 0;

//   void _calculateResult() {
//     _score = _responses.values.fold(0, (sum, item) => sum + item);

//     String resultMessage;
//     if (_score <= 7) {
//       resultMessage =
//           "Your results suggest that you are doing well. Keep maintaining a balanced lifestyle!";
//     } else if (_score <= 15) {
//       resultMessage =
//           "You may be experiencing mild symptoms of anxiety or depression. Consider making small lifestyle changes or reaching out to a professional.";
//     } else if (_score <= 25) {
//       resultMessage =
//           "Your results indicate moderate symptoms of anxiety or depression. It would be beneficial to seek professional guidance.";
//     } else {
//       resultMessage =
//           "Your results suggest significant symptoms of anxiety or depression. Please consult with a healthcare professional as soon as possible.";
//     }

//     _showResultDialog(resultMessage);
//   }

//   void _showResultDialog(String resultMessage) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Test Results"),
//         content: Text(resultMessage),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: const Text("Anxiety & Depression Test"),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           const Text(
//             "Answer the following questions to help us understand your symptoms:",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 20),
//           ...questions.asMap().entries.map((entry) {
//             int questionIndex = entry.key;
//             Question question = entry.value;
//             return _buildQuestionCard(questionIndex, question);
//           }),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _calculateResult,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text(
//               "Submit",
//               style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionCard(int index, Question question) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Q${index + 1}. ${question.questionText}",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...question.options.entries.map((option) {
//               return RadioListTile<int>(
//                 title: Text(option.key),
//                 value: option.value,
//                 groupValue: _responses[index],
//                 onChanged: (value) {
//                   setState(() {
//                     _responses[index] = value!;
//                   });
//                 },
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Question {
//   final String questionText;
//   final Map<String, int> options;

//   Question({required this.questionText, required this.options});
// }

import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

class AnxietyDepressionTestScreen extends StatefulWidget {
  const AnxietyDepressionTestScreen({super.key});

  @override
  _AnxietyDepressionTestScreenState createState() =>
      _AnxietyDepressionTestScreenState();
}

class _AnxietyDepressionTestScreenState
    extends State<AnxietyDepressionTestScreen> {
  final List<Question> questions = [
    Question(
      questionText: "Do you often feel nervous or anxious?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you find it hard to focus on tasks?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you feel sad or down most of the time?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you have difficulty sleeping?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you often feel tired or low on energy?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you experience sudden mood swings?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you avoid social interactions or gatherings?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you feel overwhelmed by small tasks?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText: "Do you experience physical symptoms due to stress?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
    Question(
      questionText:
          "Do you feel hopeless or have thoughts of self-doubt frequently?",
      options: {"Never": 0, "Sometimes": 1, "Often": 2, "Always": 3},
    ),
  ];

  final Map<int, int> _responses = {};
  int _score = 0;
  bool _showChart = false;
  String _severity = "";

  void _calculateResult() {
    if (_responses.length < questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _score = _responses.values.fold(0, (sum, item) => sum + item);
      _showChart = true;

      if (_score <= 7) {
        _severity = "Low";
      } else if (_score <= 15) {
        _severity = "Mild";
      } else if (_score <= 25) {
        _severity = "Moderate";
      } else {
        _severity = "Severe";
      }
    });
  }

  Color getSeverityColor() {
    switch (_severity) {
      case "Low":
        return Colors.green;
      case "Mild":
        return Colors.yellow;
      case "Moderate":
        return Colors.orange;
      case "Severe":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: Text(
                        "Anxiety & Depression Test",
                        style: AppTheme.headingMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              // Content Area
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingL),
                      margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
                      decoration: BoxDecoration(
                        gradient: AppTheme.cardGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusL),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingM),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusRound),
                            ),
                            child: Icon(
                              Icons.psychology_rounded,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Text(
                              "Answer the following questions to help us understand your symptoms:",
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...questions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Question question = entry.value;
                      return _buildQuestionCard(index, question);
                    }),
                    const SizedBox(height: AppTheme.spacingL),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: ElevatedButton(
                        onPressed: _calculateResult,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingM),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusM),
                          ),
                        ),
                        child: Text(
                          "Submit Assessment",
                          style: AppTheme.buttonText.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXL),
                    if (_showChart) _buildChartSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index, Question question) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Text(
                "Question ${index + 1}",
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              question.questionText,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...question.options.entries.map((option) {
              final isSelected = _responses[index] == option.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: RadioListTile<int>(
                  title: Text(
                    option.key,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  value: option.value,
                  groupValue: _responses[index],
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _responses[index] = value!;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Your score: $_score/30",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Severity: $_severity",
            style: TextStyle(fontSize: 16, color: getSeverityColor())),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: _score / 30,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(getSeverityColor()),
          minHeight: 20,
        ),
      ],
    );
  }
}

class Question {
  final String questionText;
  final Map<String, int> options;

  Question({required this.questionText, required this.options});
}
