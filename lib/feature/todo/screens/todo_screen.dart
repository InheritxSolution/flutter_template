import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_structure/core/utils/custom_widgets/translated_text.dart';

import '../../../core/base/base_provider.dart';
import '../../../core/base/locale_provider.dart';
import '../../../core/utils/custom_widgets/stack_loader.dart';
import '../../../core/utils/extensions/widget_extension.dart';
import '../provider/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  final int todoId;

  const TodoScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider()..fetchTodo(todoId),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TranslatedText('todo_details'),
        actions: [
          DropdownButton<String>(
            value: Provider.of<LocaleProvider>(context).locale.languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
            ],
            onChanged: (String? newLocale) {
              if (newLocale != null) {
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(newLocale);
              }
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return StackLoader(
              state: provider.state, content: buildBody(context, provider));
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, TodoProvider provider) {
    if (provider.state == ViewState.error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          provider.errorMessage!.textWidget(),
          ElevatedButton(
            onPressed: () => provider.fetchTodo(100),
            child: 'retry'.translatedTextWidget(),
          ),
        ],
      ).center;
    }

    final todo = provider.todo;
    if (todo == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              todo.title
                  .textWidget(style: Theme.of(context).textTheme.headlineSmall),
              8.hSpace,
              Row(
                children: [
                  Icon(
                    todo.completed ? Icons.check_circle : Icons.circle_outlined,
                    color: todo.completed ? Colors.green : Colors.grey,
                  ),
                  8.hSpace,
                  (todo.completed ? 'completed' : 'pending')
                      .translatedTextWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
