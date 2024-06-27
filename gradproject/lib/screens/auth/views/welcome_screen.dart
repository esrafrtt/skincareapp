import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../blocs/sign_up_bloc/sign_up_bloc.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE1BEE7), // Açık mor
                      Colors.white,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0), // Yukarıdan boşluk bırak
                  child: Lottie.network(
                    'https://lottie.host/5c2ebbe8-6095-4f91-8839-324d5b31e2ca/nBy1mmrVWU.json',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 300), // Daha fazla boşluk ekle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TabBar(
                        controller: tabController,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                        labelColor: const Color(0xFFE1BEE7), // Açık mor
                        indicatorColor: const Color(0xFFE1BEE7), // Açık mor
                        tabs: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    Color.fromRGBO(80, 38, 87, 1), // Açık mor
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(80, 38, 87, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          BlocProvider<SignInBloc>(
                            create: (context) => SignInBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignInScreen(),
                          ),
                          BlocProvider<SignUpBloc>(
                            create: (context) => SignUpBloc(context
                                .read<AuthenticationBloc>()
                                .userRepository),
                            child: const SignUpScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
