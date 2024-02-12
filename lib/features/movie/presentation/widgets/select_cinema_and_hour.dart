import 'package:flut_cinematic/features/features.dart';
import 'package:flut_cinematic_domain/flut_cinematic_domain.dart';
import 'package:flut_cinematic_ui/flut_cinematic_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeAviable {
  const TimeAviable._();

  static List<DateTime> _dates(Duration duration) {
    return List.generate(
      5,
      (index) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, 13)
            .add(duration * (index + 1));
      },
    );
  }

  static List<DateTime> dates(Duration duration) {
    final totalDates = _dates(duration);
    return totalDates.where((date) => date.today).toList();
  }
}

class SelectCinemaAndHour extends HookConsumerWidget {
  const SelectCinemaAndHour({super.key, required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = ref.watch(movieProvider(this.movie));
    return FlutCinematicCustomCard(
      borderColor: Palette.transparent,
      backgroundColor: Palette.grey,
      padding: edgeInsets16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Starview Cinema'.hardCode,
                  style: context.textTheme.headlineSmall,
                ),
              ),
              FlutCinematicIconButton(
                iconData: FlutCinematicIcons.arrowDown,
                color: Palette.red,
                onPressed: () {},
              ),
            ],
          ),
          gap2,
          Text(
            'Elije el horario que mas te guste'.hardCode,
            style: context.textTheme.bodyMedium,
          ),
          gap12,
          if (movie.runtime != null)
            Wrap(
              runSpacing: 4,
              spacing: 4,
              children: [
                ...TimeAviable.dates(Duration(minutes: movie.runtime!)).mapList(
                  (date) => _HourSelector(date: date),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HourSelector extends HookConsumerWidget {
  const _HourSelector({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketState = ref.watch(ticketProvider);
    var hourAvailable = false;
    if (ticketState.date != null) {
      if (ticketState.date!.today) {
        hourAvailable = ticketState.date!.isBefore(date);
      } else {
        hourAvailable = true;
      }
    }
    final selected = date.hour == ticketState.time?.hour;
    final borderColor = selected ? Palette.red : Palette.white.withOpacity(.2);
    final backgroundColor =
        hourAvailable ? null : Palette.white.withOpacity(.2);
    return FlutCinematicCustomCard(
      onPressed: hourAvailable
          ? () {
              ref.read(ticketProvider.notifier).timeSelect(date);
            }
          : null,
      padding: edgeInsetsH20.add(edgeInsetsV4),
      backgroundColor: backgroundColor,
      borderRadius: borderRadius8,
      borderColor: borderColor,
      child: Text(
        date.myHour.toLowerCase(),
        style: context.textTheme.bodyLarge?.copyWith(
          color: backgroundColor,
        ),
      ),
    );
  }
}
