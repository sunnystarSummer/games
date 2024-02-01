import 'dart:math';

import 'package:flutter/foundation.dart';

import 'card_suit.dart';

@immutable
class PlayingCard {
  static final _random = Random();

  final CardSuit suit;

  final int value;

  //是否為正面
  bool isFront = false;

  //是否配對完成
  bool isPairingCompleted;

  //配對代表者
  bool isPairingRepresentative;

  //已分類回收
  bool isSortedForRecycling;

  double rotateAngle;

  PlayingCard(
    this.suit,
    this.value, {
    this.isFront = true,
    this.isPairingCompleted = false,
    this.isPairingRepresentative = false,
    this.isSortedForRecycling = false,
    this.rotateAngle = -1.0,
  });

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      json['suit'] as CardSuit,
      json['value'] as int,
      isFront: json['isFront'] as bool,
      isPairingCompleted: json['isPairingCompleted'] as bool,
      isPairingRepresentative: json['isPairingRepresentative'] as bool,
      isSortedForRecycling: json['isSortedForRecycling'] as bool,
      rotateAngle: json['rotateAngle'] as double,
    );
  }

  factory PlayingCard.order(CardSuit cardSuit, int value) {
    return PlayingCard(
      cardSuit,
      value,
    );
  }

  static int randomValue(CardSuit cardSuit, [Random? random]) {
    random ??= _random;
    //const cardSuit = CardSuit.kitchenWasteAsPigFood;
    return random.nextInt(cardSuit.trashType.itemsCount - 1);
  }

  // @override
  // int get hashCode => Object.hash(suit, value);
  //
  // @override
  // bool operator ==(Object other) {
  //   return other is PlayingCard && other.suit == suit && other.value == value;
  // }

  void clearState() {
    isPairingCompleted = false;
    isPairingRepresentative = false;
    isSortedForRecycling = false;
  }

  void paired() {
    isPairingCompleted = true;
    isPairingRepresentative = false;
    isSortedForRecycling = true;
  }

  void pairedAsRepresentative() {
    isPairingCompleted = true;
    isPairingRepresentative = true;
    isSortedForRecycling = false;
  }

  void rotate() {
    const rotateAngleMax = 0.5;
    final random = Random();
    rotateAngle = random.nextDouble() * rotateAngleMax;
    if (random.nextBool()) {
      rotateAngle = -rotateAngle;
    }
  }

  Map<String, dynamic> toJson() => {
        'suit': suit.internalRepresentation,
        'value': value,
        'isFront': isFront,
        'isPairingCompleted': isPairingCompleted,
        'isPairingRepresentative': isPairingRepresentative,
        'isSortedForRecycling': isSortedForRecycling,
        'rotateAngle': rotateAngle,
      };

  @override
  String toString() {
    return '$suit'
        '$value'
        '$isFront'
        '$isPairingCompleted'
        '$isPairingRepresentative'
        '$isSortedForRecycling'
        '$rotateAngle';
  }

  static PlayingCard clone(PlayingCard other) {
    return PlayingCard(
      other.suit,
      other.value,
      isFront: other.isFront,
      isPairingCompleted: other.isPairingCompleted,
      isPairingRepresentative: other.isPairingRepresentative,
      isSortedForRecycling: other.isSortedForRecycling,
      rotateAngle: other.rotateAngle,
    );
  }
}
