import '../models/user_profile.dart';
import '../models/social_post.dart';
import '../models/chat_message.dart';
import '../models/match_item.dart';

class MockData {
  static final UserProfile currentUser = UserProfile(
    id: 'user_me',
    name: 'Alex Rivera',
    age: 25,
    bio:
        'Architect by day, vinyl collector & amateur chef by night. Looking for someone to explore hidden coffee shops and art galleries with. Always down for spontaneous road trips 🚗✨',
    occupation: 'Architect & Designer',
    company: 'Studio Form',
    education: 'Columbia University',
    location: 'Brooklyn, NY',
    distanceKm: 0.0,
    photos: [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
    ],
    interests: ['Architecture', 'Vinyl Records', 'Coffee', 'Hiking', 'Cooking', 'Art Museums'],
    prompts: {
      'My ideal Sunday': 'Pour-over coffee, vinyl spinning, and wandering through local flea markets.',
      'A boundary of mine': 'Don’t text me while driving. Ever!',
      'The key to my heart': 'Surprise me with good playlists and authentic street tacos.',
    },
    intention: 'Long-term relationship',
    isVerified: true,
    compatibilityScore: 98,
    height: "5' 11\"",
    zodiac: 'Libra',
  );

  static final List<UserProfile> discoverProfiles = [
    UserProfile(
      id: 'p_1',
      name: 'Sofia Chen',
      age: 24,
      bio:
          'UX Researcher & ceramicist 🏺 Obsessed with matcha lattes, 35mm film cameras, and weekend farmers markets. Tell me your top 3 travel destinations!',
      occupation: 'UX Designer',
      company: 'DesignLab',
      education: 'Parsons School of Design',
      location: 'SoHo, Manhattan',
      distanceKm: 2.4,
      photos: [
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Photography', 'Matcha', 'Ceramics', 'Film Cameras', 'Design', 'Yoga'],
      prompts: {
        'My ideal Sunday': 'Making ceramics in the studio with lo-fi beats playing in the background.',
        'Two truths and a lie': 'I have been to 22 countries, I can speak 4 languages, I have never eaten sushi.',
        'We will get along if': 'You appreciate good aesthetics and love exploring rooftop views.',
      },
      intention: 'Long-term relationship',
      isVerified: true,
      compatibilityScore: 95,
      height: "5' 7\"",
      zodiac: 'Taurus',
    ),
    UserProfile(
      id: 'p_2',
      name: 'Elena Rostova',
      age: 26,
      bio:
          'Classical pianist who secretly loves electronic synthwave 🎹 Passionate about sourdough baking, bouldering, and French cinema. Let’s swap playlists!',
      occupation: 'Music Producer & Pianist',
      company: 'SoundWave Collective',
      education: 'Juilliard',
      location: 'Williamsburg, Brooklyn',
      distanceKm: 3.8,
      photos: [
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Piano', 'Synthwave', 'Bouldering', 'Baking', 'French Cinema', 'Travel'],
      prompts: {
        'Together, we could': 'Compose a track or bake the crispiest sourdough loaf in town.',
        'My biggest pet peeve': 'People who play loud TikToks in public without headphones.',
        'Best travel story': 'Got lost in Kyoto at 2 AM and stumbled into the most magical jazz bar.',
      },
      intention: 'Looking for a genuine connection',
      isVerified: true,
      compatibilityScore: 92,
      height: "5' 8\"",
      zodiac: 'Scorpio',
    ),
    UserProfile(
      id: 'p_3',
      name: 'Maya Lin',
      age: 23,
      bio:
          'Software engineer & marathon runner 🏃‍♀️ If I am not debugging code, I am probably training in Central Park or scouring thrift stores for vintage jackets.',
      occupation: 'Mobile Developer',
      company: 'TechFlow Inc.',
      education: 'NYU Computer Science',
      location: 'West Village, NY',
      distanceKm: 1.8,
      photos: [
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Running', 'Thrifting', 'Coding', 'Podcasts', 'Dogs', 'Brewery Tours'],
      prompts: {
        'A quick life goal': 'Run all six World Marathon Majors before 30!',
        'I know the best spot for': 'Crispy Neapolitan pizza in the city. Dare to test me?',
      },
      intention: 'Casual dating & fun vibes',
      isVerified: false,
      compatibilityScore: 88,
      height: "5' 6\"",
      zodiac: 'Gemini',
    ),
    UserProfile(
      id: 'p_4',
      name: 'Lucas Vance',
      age: 27,
      bio:
          'Landscape architect and environmental advocate. Big on outdoor adventures, campfires under star skies, and making the best spicy ramen you will ever taste.',
      occupation: 'Landscape Architect',
      company: 'Terra Design Lab',
      education: 'Cornell University',
      location: 'DUMBO, Brooklyn',
      distanceKm: 4.1,
      photos: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Hiking', 'Camping', 'Ramen', 'Sustainability', 'Vinyl', 'Coffee'],
      prompts: {
        'My simple pleasures': 'Waking up before sunrise on mountain summits with hot brew.',
        'I am convinced that': 'Pineapple on pizza is an underrated delicacy.',
      },
      intention: 'Long-term relationship',
      isVerified: true,
      compatibilityScore: 94,
      height: "6' 1\"",
      zodiac: 'Sagittarius',
    ),
    UserProfile(
      id: 'p_5',
      name: 'Chloe Dubois',
      age: 25,
      bio:
          'Art curator and wine enthusiast 🍷 Born in Paris, living in NYC. Looking for someone who can teach me something new or challenge me to a game of chess.',
      occupation: 'Art Gallery Curator',
      company: 'Pace Gallery',
      education: 'Sorbonne Paris',
      location: 'Chelsea, NY',
      distanceKm: 1.2,
      photos: [
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Modern Art', 'Wine Tasting', 'Chess', 'Museums', 'Bookstores', 'Jazz'],
      prompts: {
        'The first round is on me if': 'You can beat me in 3-minute blitz chess.',
        'Favorite museum': 'The Met Cloisters on a rainy afternoon.',
      },
      intention: 'Long-term relationship',
      isVerified: true,
      compatibilityScore: 96,
      height: "5' 9\"",
      zodiac: 'Aquarius',
    ),
  ];

  static final List<UserProfile> whoLikedYou = [
    UserProfile(
      id: 'l_1',
      name: 'Amara Johnson',
      age: 25,
      bio: 'Fashion designer & indie filmmaker. Life is too short for boring outfits.',
      occupation: 'Creative Director',
      company: 'Vogue Studio',
      location: 'SoHo, NY',
      distanceKm: 2.1,
      photos: [
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Fashion', 'Film', 'Indie Rock', 'Coffee'],
      intention: 'Looking for vibes',
      isVerified: true,
      compatibilityScore: 96,
    ),
    UserProfile(
      id: 'l_2',
      name: 'Isabella Rossi',
      age: 24,
      bio: 'Pastry chef & Italian espresso addict. Let me bake you fresh cannoli!',
      occupation: 'Pastry Chef',
      company: 'Little Italy Bakery',
      location: 'Lower East Side',
      distanceKm: 3.5,
      photos: [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Baking', 'Foodie', 'Travel', 'Art'],
      intention: 'Long-term relationship',
      isVerified: true,
      compatibilityScore: 93,
    ),
    UserProfile(
      id: 'l_3',
      name: 'Liam Zhang',
      age: 27,
      bio: 'Fintech analyst by day, cocktail mixologist by night. Speakeasy explorer.',
      occupation: 'Financial Analyst',
      company: 'Apex Capital',
      location: 'Tribeca, NY',
      distanceKm: 1.5,
      photos: [
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Mixology', 'Investing', 'Tennis', 'Travel'],
      intention: 'Looking for dates',
      isVerified: false,
      compatibilityScore: 89,
    ),
    UserProfile(
      id: 'l_4',
      name: 'Zara Al-Mansoor',
      age: 26,
      bio: 'Architectural photographer. Chasing light and clean geometric angles.',
      occupation: 'Photographer',
      company: 'Freelance',
      location: 'Greenpoint, NY',
      distanceKm: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
      ],
      interests: ['Photography', 'Architecture', 'Podcasts', 'Museums'],
      intention: 'Meaningful connection',
      isVerified: true,
      compatibilityScore: 91,
    ),
  ];

  static final List<MatchItem> matches = [
    MatchItem(
      id: 'm_1',
      user: discoverProfiles[0], // Sofia Chen
      matchedAt: DateTime.now().subtract(const Duration(hours: 2)),
      lastMessage: 'Hey Alex! Loved your vinyl collection prompt 🎶',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 18)),
      unreadCount: 2,
      isOnline: true,
    ),
    MatchItem(
      id: 'm_2',
      user: discoverProfiles[1], // Elena Rostova
      matchedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastMessage: 'Let’s definitely grab matcha at that spot in SoHo!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isOnline: false,
    ),
    MatchItem(
      id: 'm_3',
      user: discoverProfiles[4], // Chloe Dubois
      matchedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastMessage: 'Haha challenge accepted! 3-min blitz chess it is 😉',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: true,
    ),
  ];

  static final Map<String, List<ChatMessage>> chatHistories = {
    'm_1': [
      ChatMessage(
        id: 'msg_1',
        senderId: 'p_1',
        text: 'Hey Alex! 👋 Saw your profile and your taste in music is amazing.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: 'msg_2',
        senderId: 'user_me',
        text: 'Hey Sofia! Thank you so much! What kind of records are you into right now?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isMe: true,
      ),
      ChatMessage(
        id: 'msg_3',
        senderId: 'p_1',
        text: 'Mostly indie folk and warm 70s bossa nova! Perfect soundtrack for ceramics pottery.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isMe: false,
      ),
      ChatMessage(
        id: 'msg_4',
        senderId: 'user_me',
        text: 'Bossa nova while making pottery sounds like the ultimate vibe ✨',
        timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
        isMe: true,
      ),
      ChatMessage(
        id: 'msg_5',
        senderId: 'p_1',
        text: 'It really is! We should swap some of our favorite vinyl tracks 🎶',
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
        isMe: false,
      ),
    ],
  };

  static final List<SocialPost> socialPosts = [
    SocialPost(
      id: 'post_1',
      authorId: 'p_1',
      authorName: 'Sofia Chen',
      authorAvatar:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
      content:
          'Morning pottery session finished! Working on these terracotta mugs for my upcoming exhibition. What do you all think? 🏺✨',
      imageUrl:
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80',
      likesCount: 142,
      commentsCount: 28,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      tags: ['Ceramics', 'Handmade', 'ArtStudio', 'ViblyVibes'],
      location: 'SoHo Pottery Loft',
    ),
    SocialPost(
      id: 'post_2',
      authorId: 'p_2',
      authorName: 'Elena Rostova',
      authorAvatar:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=400&q=80',
      content:
          'Golden hour in Brooklyn. There is something serene about watching the sun dip behind the skyline with a warm cortado in hand ☕️🌇',
      imageUrl:
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      likesCount: 230,
      commentsCount: 45,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      tags: ['GoldenHour', 'Brooklyn', 'SunsetLovers', 'Coffee'],
      location: 'Brooklyn Bridge Park',
    ),
    SocialPost(
      id: 'post_3',
      authorId: 'p_4',
      authorName: 'Lucas Vance',
      authorAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      content:
          'Weekend camping trail conquered! Fresh mountain air hits completely different. Never taking campfires and starry skies for granted 🌲🏕️',
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?auto=format&fit=crop&w=1200&q=80',
      likesCount: 89,
      commentsCount: 12,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      tags: ['OutdoorLife', 'Hiking', 'Wilderness', 'Campfire'],
      location: 'Catskill Mountains, NY',
    ),
  ];

  static const List<String> interestCategories = [
    'Music 🎵',
    'Coffee ☕',
    'Photography 📸',
    'Hiking 🥾',
    'Art & Museums 🎨',
    'Foodie 🍜',
    'Travel ✈️',
    'Fitness 🏋️',
    'Books 📚',
    'Film 🎬',
    'Cooking 🍳',
    'Design 🖌️',
    'Dogs 🐶',
    'Cats 🐱',
    'Yoga 🧘',
    'Gaming 🎮',
    'Tech 💻',
    'Wine 🍷',
  ];
}

