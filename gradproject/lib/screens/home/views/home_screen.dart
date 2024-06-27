import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproject/screens/home/views/routine_screen.dart';
import 'package:lottie/lottie.dart';
import '../../../data/uvfetch.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/get_product_bloc/get_product_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  String? uvIndexAdvice;
  int? uvIndex;

  final List<String> afterUseOptions = [
    "Irritation",
    "Redness",
    "Dry Skin",
    "Aging",
    "Scars",
    "Oily Skin",
    "Large Pores",
    "Acne",
    "Dark Spots"
  ];
  final List<String> selectedAfterUseOptions = [];
  bool optionsSelected = false;

  @override
  void initState() {
    super.initState();
    _fetchUVIndex();
  }

  Future<void> _fetchUVIndex() async {
    try {
      final result = await fetchUVIndex();
      final uvIndexValue = result.split('/')[0].trim();
      setState(() {
        uvIndex = int.tryParse(uvIndexValue) ?? 0;
        uvIndexAdvice = _determineAdvice(uvIndex!);
      });
    } catch (error) {
      setState(() {
        uvIndexAdvice = 'Error: $error';
      });
    }
  }

  String _determineAdvice(int uvIndex) {
    if (uvIndex <= 2) {
      return 'Generally, you do not need to apply sunscreen.';
    } else if (uvIndex <= 5) {
      return 'It is recommended to apply sunscreen about 20 minutes before going out in the sun.';
    } else if (uvIndex <= 7) {
      return 'It is recommended to apply sunscreen and wear protective clothing such as hats and sunglasses.';
    } else if (uvIndex <= 10) {
      return 'It is strongly recommended to apply sunscreen, wear long-sleeved clothing, a hat, and sunglasses before going out. Avoid being outdoors during peak sun hours if possible.';
    } else {
      return 'Always use high SPF sunscreen when going out and try to stay in the shade as much as possible. Limit your time outdoors and avoid going out during the strongest sun hours.';
    }
  }

  void _searchProducts() {
    setState(() {
      optionsSelected = selectedAfterUseOptions.isNotEmpty;
    });
    context.read<GetProductBloc>().add(GetProduct(selectedAfterUseOptions));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'SKINCARE',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line,
                color: Colors.black),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFEDE7F6),
            ],
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            buildHomeContent(context),
            const RoutineScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _currentIndex == 0 ? Colors.deepPurple : Colors.grey),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar,
                color: _currentIndex == 1 ? Colors.deepPurple : Colors.grey),
            label: 'Routine',
            backgroundColor: Colors.white,
          ),
        ],
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
      ),
    );
  }

  Widget buildHomeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          uvIndex != null && uvIndexAdvice != null
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 231, 175),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current UV Index: $uvIndex',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        uvIndexAdvice!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Lottie.network(
                    'https://lottie.host/b90aa3db-56d3-4e92-a70d-f7897dd43869/1h8maXGxx2.json',
                    width: 130,
                    height: 80,
                  ),
                ),
          const SizedBox(height: 16),
          const Text(
            "Select the symptoms you have:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: afterUseOptions.map((option) {
              bool isSelected = selectedAfterUseOptions.contains(option);
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedAfterUseOptions.add(option);
                    } else {
                      selectedAfterUseOptions.remove(option);
                    }
                  });
                },
                backgroundColor: Colors.white,
                selectedColor:
                    const Color.fromARGB(255, 171, 132, 219).withOpacity(0.5),
                shadowColor: Colors.black54,
                elevation: isSelected ? 10 : 0,
                labelStyle:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _searchProducts,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(117, 18, 18, 18),
              ),
              child: const Text('Search'),
            ),
          ),
          const SizedBox(height: 16),
          optionsSelected
              ? Expanded(
                  child: BlocListener<GetProductBloc, GetProductState>(
                    listener: (context, state) {
                      if (state is GetProductFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${state.error}')),
                        );
                      }
                    },
                    child: BlocBuilder<GetProductBloc, GetProductState>(
                      builder: (context, state) {
                        if (state is GetProductSuccess) {
                          final filteredProducts =
                              state.products.where((product) {
                            return selectedAfterUseOptions.every(
                                (option) => product.afterUse.contains(option));
                          }).toList();
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 9 / 18,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, int i) {
                              return Material(
                                elevation: 3,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/genel.png'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              child: Text(
                                                filteredProducts[i].brand,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        filteredProducts[i].name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else if (state is GetProductLoading) {
                          return Center(
                            child: Lottie.network(
                              'https://lottie.host/41fec1d1-a1cc-4397-ac35-b361f2a6c2f8/8KokvNM5ol.json',
                              width: 150,
                              height: 90,
                            ),
                          );
                        } else if (state is GetProductFailure) {
                          return Center(child: Text('Error: ${state.error}'));
                        } else {
                          return const Center(
                              child: Text("An unexpected error occurred"));
                        }
                      },
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Text(
                        "Please select at least one option to see products."),
                  ),
                ),
        ],
      ),
    );
  }
}
