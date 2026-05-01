// class ChannelState {
//   final String channelId;
//   final String state;
//   final bool answered;

//   ChannelState({
//     required this.channelId,
//     required this.state,
//     this.answered = false,
//   });

//   ChannelState copyWith({
//     String? state,
//     bool? answered,
//   }) {
//     return ChannelState(
//       channelId: channelId,
//       state: state ?? this.state,
//       answered: answered ?? this.answered,
//     );
//   }
// }

class ChannelState {
  final String channelId;
  final String state;
  final bool answered;
  final String digits;

  ChannelState({
    required this.channelId,
    required this.state,
    this.answered = false,
    this.digits = '',
  });

  ChannelState copyWith({String? state, bool? answered, String? digits}) {
    return ChannelState(
      channelId: channelId,
      state: state ?? this.state,
      answered: answered ?? this.answered,
      digits: digits ?? this.digits,
    );
  }
}
