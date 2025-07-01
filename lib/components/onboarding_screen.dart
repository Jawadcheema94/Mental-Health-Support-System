// import 'package:flutter/material.dart';
// import 'package:myapp/login_page.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final List<String> titles = [
//     'Welcome to MindEase',
//     'Track Your Mental Health',
//     'Achieve Peace of Mind'
//   ];
//   final List<String> descriptions = [
//     'MindEase helps you stay mindful and improve mental clarity.',
//     'Get personalized insights and improve your well-being.',
//     'Start your journey towards peace and happiness with us.'
//   ];

//   int currentIndex = 0;

//   void nextPage() {
//     setState(() {
//       if (currentIndex < titles.length - 1) {
//         currentIndex++;
//       }
//     });
//   }

//   void navigateToLogin() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFFFFE29F), // Light yellow
//               Color(0xFFFFC0CB), // Light pink
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   itemCount: titles.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentIndex = index;
//                     });
//                   },
//                   itemBuilder: (context, index) => Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         titles[index],
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black, // Title in black
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         descriptions[index],
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black54, // Description in dark gray
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   titles.length,
//                   (index) => AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                     width: currentIndex == index ? 12.0 : 8.0,
//                     height: currentIndex == index ? 12.0 : 8.0,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           currentIndex == index ? Colors.black : Colors.black38,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: currentIndex == titles.length - 1
//                     ? navigateToLogin
//                     : nextPage,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple, // Button color
//                   minimumSize: const Size(120, 40), // Adjust button size
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   currentIndex == titles.length - 1 ? 'Get Started' : 'Next',
//                   style: const TextStyle(
//                     color: Colors.black, // Button text in black
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:myapp/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final List<String> titles = [
    'Welcome to MindEase',
    'Track Your Mental Health',
    'Achieve Peace of Mind'
  ];
  final List<String> descriptions = [
    'MindEase helps you stay mindful and improve mental clarity.',
    'Get personalized insights and improve your well-being.',
    'Start your journey towards peace and happiness with us.'
  ];

  final PageController _pageController = PageController();
  int currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  void nextPage() {
    if (currentIndex < titles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      navigateToLogin();
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 226, 159, 1), // Light yellow
              Color(0xFFFFC0CB), // Light pink
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo1.png',
                  height: 400, width: 400, fit: BoxFit.contain),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: titles.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    _animationController.reset();
                    _animationController.forward();
                  },
                  itemBuilder: (context, index) => FadeTransition(
                    opacity: _fadeInAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          titles[index],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Title in black
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          descriptions[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54, // Description in dark gray
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  titles.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: currentIndex == index ? 16.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: currentIndex == index
                          ? Colors.deepPurple
                          : Colors.black38,
                      boxShadow: currentIndex == index
                          ? [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  minimumSize: const Size(120, 40), // Adjust button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  currentIndex == titles.length - 1 ? 'Get Started' : 'Next',
                  style: const TextStyle(
                    color: Colors.black, // Button text in black
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

