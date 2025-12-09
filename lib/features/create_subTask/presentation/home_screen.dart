import 'package:declara/features/create_subTask/presentation/widgets/request_text_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Declara'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('あなたが本当にやりたいことは何？'),
            RequestTextField(textEditingController: textEditingController),
          ],
        ),
      ),
    );
  }
}
