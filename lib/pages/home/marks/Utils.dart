import 'package:flutter/material.dart';

List<Color> markColors = [
  const Color(0xFF00C000),
  const Color(0xFF00C000),
  const Color(0xFFBDBD00),
  const Color(0xFFFFC000),
  const Color(0xFFFFA000),
  const Color(0xFFFF6400),
  const Color(0xFFB00000),
];

Color getMarkColor({
  required int bestMark,
  required int worstMark,
  required double? valueMark,
  required List<Color> colors,
}) {
  if (valueMark == null || int.tryParse(valueMark.toString()) == 0) {
    return Colors.grey;
  }

  if (bestMark == worstMark || colors.isEmpty) {
    throw ArgumentError("Invalid mark range or empty color list.");
  }

  final markRange = (worstMark - bestMark).abs();
  final colorSteps = colors.length - 1;

  // Normalize based on whether bestMark is lower or higher than worstMark
  double normalizedValue = (valueMark - bestMark) / (worstMark - bestMark);

  // If the scale is descending (e.g., 1 = best), we need to reverse it
  if (bestMark > worstMark) {
    normalizedValue = 1.0 - normalizedValue;
  }

  normalizedValue = normalizedValue.clamp(0.0, 1.0);

  int colorIndex = (normalizedValue * colorSteps).round();

  return colors[colorIndex.clamp(0, colorSteps)];
}

final List<String> studyTips = [
  "Break study sessions into 25-minute chunks with 5-minute breaks ⏳",
  "Teach concepts to a friend to reinforce your understanding 👩🏫",
  "Create colorful mind maps for visual learning 🎨",
  "Use the Pomodoro technique for focused productivity 🍅",
  "Test yourself with flashcards for active recall 🗂️",
  "Study in natural light to reduce eye strain and boost mood ☀️",
  "Record voice notes of key ideas to listen while walking 🎧",
  "Start with the hardest task when your energy is highest 💪",
  "Organize notes with color-coded highlighters 🌈",
  "Stretch every 30 minutes to improve circulation 🧘♂️",
  "Keep a water bottle nearby to stay hydrated and focused 💧",
  "Use website blockers to minimize digital distractions 🚫",
  "Review notes for 15 minutes before bed for better retention 🌙",
  "Create a lo-fi study playlist to maintain concentration 🎶",
  "Practice past exams under timed conditions ⏱️",
  "Use mnemonics like 'ROYGBIV' for memorization 🧠",
  "Snack on brain foods like nuts and blueberries 🫐",
  "Declutter your workspace for mental clarity 🧹",
  "Reward yourself with a small treat after milestones 🎉",
  "Schedule weekly goals and celebrate progress 📆",
];

final List<String> motivationalQuotes = [
  "Progress over perfection 🌱",
  "You don’t have to be great to start – just start 💫",
  "Every page turned is a step closer to mastery 📖",
  "Mistakes are proof you’re growing 🌻",
  "Your pace is valid – comparison steals joy 🐢⚡",
  "Resting is part of the journey, not quitting 💤",
  "The expert was once a curious beginner 🔍",
  "Small efforts compound into big results 🧱",
  "Courage is quiet persistence, not loud perfection 🦁",
  "You’ve survived 100% of your toughest days 💯",
  "Learning is planting seeds for tomorrow’s forest 🌳",
  "Your brain grows stronger with every challenge 💪🧠",
  "The best time to start was yesterday. The next best time is now 🕒",
  "You’re not failing – you’re discovering what works 🔄",
  "Curiosity is the compass to wisdom 🧭",
  "Your potential is an ocean – dive in 🌊",
  "One chapter at a time writes the story 📝",
  "Burnout isn’t a badge of honor – balance is key ⚖️",
  "You’re building wings while learning to fly 🦅",
  "Today’s effort is tomorrow’s foundation 🏗️",
];
