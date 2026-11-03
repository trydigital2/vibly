import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_data.dart';
import '../models/chat_message.dart';
import '../models/match_item.dart';
import '../models/social_post.dart';
import '../models/user_profile.dart';

// Current Auth State
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

// Active Tab Index Provider
final selectedTabProvider = StateProvider<int>((ref) => 0);

// Current User Profile State
final currentUserProvider = StateProvider<UserProfile>((ref) {
  return MockData.currentUser;
});

// Discover Profiles State Notifier
class DiscoverProfilesNotifier extends StateNotifier<List<UserProfile>> {
  final List<UserProfile> _allProfiles;
  final List<UserProfile> _swipedHistory = [];

  DiscoverProfilesNotifier(this._allProfiles) : super(List.from(_allProfiles));

  void swipeLeft(String profileId) {
    final profile = state.firstWhere((p) => p.id == profileId);
    _swipedHistory.add(profile);
    state = state.where((p) => p.id != profileId).toList();
  }

  bool swipeRight(String profileId) {
    final profile = state.firstWhere((p) => p.id == profileId);
    _swipedHistory.add(profile);
    state = state.where((p) => p.id != profileId).toList();
    // Simulate mutual match if compatibility is high
    return profile.compatibilityScore >= 90;
  }

  bool superLike(String profileId) {
    final profile = state.firstWhere((p) => p.id == profileId);
    _swipedHistory.add(profile);
    state = state.where((p) => p.id != profileId).toList();
    return true; // Super like triggers match
  }

  void rewind() {
    if (_swipedHistory.isNotEmpty) {
      final last = _swipedHistory.removeLast();
      state = [last, ...state];
    }
  }

  void reset() {
    state = List.from(_allProfiles);
    _swipedHistory.clear();
  }
}

final discoverProfilesProvider =
    StateNotifierProvider<DiscoverProfilesNotifier, List<UserProfile>>((ref) {
  return DiscoverProfilesNotifier(MockData.discoverProfiles);
});

// Likes State Notifier (Who liked you)
class LikesNotifier extends StateNotifier<List<UserProfile>> {
  LikesNotifier() : super(List.from(MockData.whoLikedYou));

  void removeLike(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final likesProvider = StateNotifierProvider<LikesNotifier, List<UserProfile>>((ref) {
  return LikesNotifier();
});

// Matches State Notifier
class MatchesNotifier extends StateNotifier<List<MatchItem>> {
  MatchesNotifier() : super(List.from(MockData.matches));

  void addMatch(UserProfile user) {
    final newMatch = MatchItem(
      id: 'match_${DateTime.now().millisecondsSinceEpoch}',
      user: user,
      matchedAt: DateTime.now(),
      lastMessage: 'You matched with ${user.name}! Say hello 👋',
      lastMessageTime: DateTime.now(),
      unreadCount: 1,
      isOnline: true,
    );
    state = [newMatch, ...state];
  }
}

final matchesProvider = StateNotifierProvider<MatchesNotifier, List<MatchItem>>((ref) {
  return MatchesNotifier();
});

// Chat Messages State Notifier (Match ID -> List<ChatMessage>)
class ChatMessagesNotifier extends StateNotifier<Map<String, List<ChatMessage>>> {
  ChatMessagesNotifier() : super(Map.from(MockData.chatHistories));

  void sendMessage(String matchId, String text, {String? imageUrl}) {
    final newMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_me',
      text: text,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
    );

    final currentMessages = List<ChatMessage>.from(state[matchId] ?? []);
    currentMessages.add(newMessage);

    state = {
      ...state,
      matchId: currentMessages,
    };

    // Simulate an automatic charming reply after 1.5 seconds!
    Timer(const Duration(milliseconds: 1500), () {
      final replies = [
        "Haha that's amazing! Absolutely made my day 😄",
        "I couldn't agree more! You definitely have great taste ✨",
        "Sounds like a plan! Let's make it happen this weekend ☕️",
        "That's so cool! Tell me more about that!",
      ];
      final autoReplyText = replies[DateTime.now().second % replies.length];

      final autoReply = ChatMessage(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'partner',
        text: autoReplyText,
        timestamp: DateTime.now(),
        isMe: false,
        isRead: true,
      );

      final updated = List<ChatMessage>.from(state[matchId] ?? []);
      updated.add(autoReply);
      state = {
        ...state,
        matchId: updated,
      };
    });
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, Map<String, List<ChatMessage>>>((ref) {
  return ChatMessagesNotifier();
});

// Social Posts State Notifier
class SocialPostsNotifier extends StateNotifier<List<SocialPost>> {
  SocialPostsNotifier() : super(List.from(MockData.socialPosts));

  void toggleLike(String postId) {
    state = [
      for (final post in state)
        if (post.id == postId)
          post.copyWith(
            isLiked: !post.isLiked,
            likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          )
        else
          post
    ];
  }

  void addPost(String content, {String? imageUrl, List<String>? tags, String? location}) {
    final newPost = SocialPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: MockData.currentUser.id,
      authorName: MockData.currentUser.name,
      authorAvatar: MockData.currentUser.photos.first,
      content: content,
      imageUrl: imageUrl,
      likesCount: 1,
      commentsCount: 0,
      isLiked: true,
      createdAt: DateTime.now(),
      tags: tags ?? ['ViblyMoments'],
      location: location ?? 'New York, NY',
    );
    state = [newPost, ...state];
  }
}

final socialPostsProvider =
    StateNotifierProvider<SocialPostsNotifier, List<SocialPost>>((ref) {
  return SocialPostsNotifier();
});

