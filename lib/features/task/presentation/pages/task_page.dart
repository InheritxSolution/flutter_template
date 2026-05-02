import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_shimmer.dart';
import '../../../../core/base/base_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/app_colors.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Task Management',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                ),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 16.h),
            ),
            actions: [
              IconButton(
                onPressed: () => context.read<TaskProvider>().fetchTasks(),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 8.h),
            sliver: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.state == ViewState.loading && provider.tasks.isEmpty) {
                  return SliverFillRemaining(
                    child: const TaskShimmer(),
                  );
                }

                if (provider.state == ViewState.error && provider.tasks.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 60.w, color: AppColors.error),
                          SizedBox(height: 16.h),
                          Text(provider.errorMessage ?? 'Something went wrong'),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => provider.fetchTasks(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = provider.tasks[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TaskCard(
                          task: task,
                          onToggle: () => provider.toggleTaskStatus(task),
                        ),
                      );
                    },
                    childCount: provider.tasks.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Add New Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'What needs to be done?',
            hintStyle: TextStyle(color: AppColors.textMuted),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TaskProvider>().addTask(controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
