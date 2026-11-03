import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/vibly_avatar.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/match_item.dart';
import '../../data/repositories/vibly_repository.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_bar.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String matchId;

  const ChatDetailScreen({super.key, required this.matchId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  Timer? _typingStartTimer;
  Timer? _typingEndTimer;

  @override
  void dispose() {
    _typingStartTimer?.cancel();
    _typingEndTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendMessage(String text) {
    ref.read(chatMessagesProvider.notifier).sendMessage(widget.matchId, text);
    _scrollToBottom();

    _typingStartTimer?.cancel();
    _typingEndTimer?.cancel();

    // Show simulated typing indicator after 500ms
    _typingStartTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isTyping = true);
    });
    _typingEndTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _isTyping = false);
        _scrollToBottom();
      }
    });
  }

  void _showReportDialog(MatchItem match) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Report ${match.user.name}?'),
        content: const Text(
          'We take community safety seriously. Please let us know if this user engaged in inappropriate behavior, spam, or impersonation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted. Thank you for keeping Vibly safe!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Report & Block', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matches = ref.watch(matchesProvider);
    final allChatMessages = ref.watch(chatMessagesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final match = matches.firstWhere(
      (m) => m.id == widget.matchId,
      orElse: () => matches.first,
    );

    final messages = allChatMessages[widget.matchId] ??
        [
          ChatMessage(
            id: 'init_1',
            senderId: match.user.id,
            text: 'Hey! Loved your profile and your vibe ✨',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            isMe: false,
          ),
        ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ViblyAvatar(
              imageUrl: match.user.photos.first,
              radius: 19,
              isOnline: match.isOnline,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.user.name,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    _isTyping
                        ? 'typing...'
                        : (match.isOnline ? 'Online' : 'Active 2h ago'),
                    style: AppTypography.labelSmall.copyWith(
                      color: _isTyping
                          ? AppColors.primary
                          : (match.isOnline
                              ? AppColors.accentGreen
                              : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.videocam_outlined,
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Starting Vibly Vibe Call with ${match.user.name}...'),
                  backgroundColor: AppColors.secondary,
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
            onSelected: (val) {
              if (val == 'report') {
                _showReportDialog(match);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('View Profile')),
              const PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
              const PopupMenuItem(
                value: 'report',
                child: Text('Block & Report', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return ChatBubble(message: msg);
                },
              ),
            ),

            // Simulated Typing Indicator
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${match.user.name} is typing',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Icebreaker Chips (if early conversation)
            if (messages.length <= 5)
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildIcebreakerChip("Loved your prompt about music! 🎶", isDark),
                    _buildIcebreakerChip("What's your favorite coffee place? ☕", isDark),
                    _buildIcebreakerChip("Up for grabbing tacos this weekend? 🌮", isDark),
                  ],
                ),
              ),

            // Input Bar
            ChatInputBar(
              onSendMessage: _onSendMessage,
              onAttachImage: () {
                _onSendMessage('📷 [Shared a Photo]');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcebreakerChip(String prompt, bool isDark) {
    return GestureDetector(
      onTap: () => _onSendMessage(prompt),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Center(
          child: Text(
            prompt,
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.white : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

