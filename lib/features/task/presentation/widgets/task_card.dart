import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Accent Border
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    task.completed ? AppColors.success : AppColors.primary,
                    task.completed ? AppColors.success.withOpacity(0.5) : AppColors.secondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.only(left: 21.w, right: 16.w, top: 16.h, bottom: 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: task.completed 
                            ? AppColors.success.withOpacity(0.1) 
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Icon(
                        task.completed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: task.completed ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              decoration: task.completed ? TextDecoration.lineThrough : null,
                              color: task.completed ? AppColors.textMuted : AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'User ID: ${task.userId}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.w,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
