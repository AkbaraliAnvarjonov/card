import 'package:card_input/src/core/router/app_router.dart';
import 'package:card_input/src/shared/domain/models/card_model.dart';
import 'package:card_input/src/shared/presentation/bloc/card_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardExpiryController;

  @override
  void initState() {
    _cardExpiryController = TextEditingController();
    _cardNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cardExpiryController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Karta ma'lumotlarini kiritish"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => context.pushNamed(Routes.nfc),
                icon: const Icon(CupertinoIcons.news),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: const Size(double.infinity, 55),
                ),
                onPressed: () {
                  
                },
                child: const Text('Kartani qo`shish'),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: _cardNumberController,
                  hintText: 'Karta raqam',
                  prefix: CupertinoIcons.creditcard,
                  suffix: IconButton(
                    onPressed: () {
                      context.pushNamed(Routes.camera);
                    },
                    icon: const Icon(CupertinoIcons.camera),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  textEditingController: _cardExpiryController,
                  hintText: 'Amal qilish mudati',
                  prefix: CupertinoIcons.calendar,
                  maskPattern: '##/##',
                  maxLength: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
