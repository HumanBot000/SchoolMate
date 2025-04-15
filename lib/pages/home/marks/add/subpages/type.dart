import 'package:flutter/material.dart';
import 'package:school_mate/Classes/marks/ExamType.dart';
import 'package:school_mate/Classes/marks/GradingSystem.dart';

class ExamTypeSelector extends StatelessWidget {
  final GradingSystem gradingSystem;
  final Function(ExamType) onSelected;
  final List<ExamType> shownExamTypes;

  const ExamTypeSelector({
    super.key,
    required this.gradingSystem,
    required this.onSelected,
    this.shownExamTypes = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gradingSystem.examTypes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final examType = gradingSystem.examTypes[index];
        if (shownExamTypes.isNotEmpty && !shownExamTypes.contains(examType))
          return Container();
        return Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => onSelected(examType),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: colors.outlineVariant,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildTypeIndicator(context, examType),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildExamTypeContent(examType, textTheme, colors),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeIndicator(BuildContext context, ExamType examType) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        examType.evaluationData.percentage != null
            ? Icons.percent
            : Icons.casino_outlined,
        color: colors.onSecondaryContainer,
      ),
    );
  }

  Widget _buildExamTypeContent(
      ExamType examType, TextTheme textTheme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          examType.name,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        examType.evaluationData.percentage != null
            ? _buildPercentageContent(examType, colors)
            : _buildMultiplicationContent(examType, colors),
      ],
    );
  }

  Widget _buildPercentageContent(ExamType examType, ColorScheme colors) {
    return Row(
      children: [
        Icon(
          Icons.data_usage,
          size: 16,
          color: colors.tertiary,
        ),
        const SizedBox(width: 4),
        Text(
          '${examType.evaluationData.percentage}% Weight',
          style: TextStyle(
            color: colors.tertiary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMultiplicationContent(ExamType examType, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.merge_type,
              size: 16,
              color: colors.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${examType.evaluationData.multiplicationFactor}x Multiplier',
              style: TextStyle(
                color: colors.secondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (examType.evaluationData.multiplicationChildType != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Based on ${examType.evaluationData.multiplicationChildType!.name}',
              style: TextStyle(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
