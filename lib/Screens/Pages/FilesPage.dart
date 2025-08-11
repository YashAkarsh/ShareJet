import 'package:flutter/material.dart';

class RecievedfilesPage extends StatelessWidget {
  const RecievedfilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Received Files'));
  }
}

class SentFilesPage extends StatelessWidget {
  const SentFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sent Files'));
  }
}

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  State<FilesPage> createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage>
    with AutomaticKeepAliveClientMixin {
  int _index = 0;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 20),

        // Tab Bar
        Center(
          child: Container(
            width: 220,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                // Sliding background
                AnimatedAlign(
                  alignment: _index == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                // Text Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _onTabTap(0),
                        child: Center(
                          child: Text(
                            'Received',
                            style: TextStyle(
                              color: _index == 0 ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _onTabTap(1),
                        child: Center(
                          child: Text(
                            'Sent',
                            style: TextStyle(
                              color: _index == 1 ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // PageView with controller
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _index = page;
              });
            },
            children: const [
              RecievedfilesPage(),
              SentFilesPage(),
            ],
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
