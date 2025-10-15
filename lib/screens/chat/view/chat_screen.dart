import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../component/ktext_form_field.dart';
import '../../../controller/auth_controller.dart';
import '../../../model/chat_item.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class ChatView extends StatefulWidget {
  final String otherUserUID; // The user they are chatting with
  const ChatView({super.key, required this.otherUserUID});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _otherUser;
  bool _isLoading = true;
  bool _isTyping = false;

  String get _currentUserUID => Get.find<AuthController>().currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();
    _loadOtherUserInfo();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOtherUserInfo() async {
    try {
      final users = await FirebaseService.getUsersList();
      _otherUser = users.firstWhereOrNull((user) => user.userUID == widget.otherUserUID);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // --- Send Message to Firestore ---
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) {
      return;
    }

    // Clear the input field and unfocus
    _messageController.clear();
    FocusScope.of(context).unfocus();

    // Add the message to Firestore
    try {
      final DocumentReference docRef = _firestore
          .collection('chats')
          .doc(_getChatRoomId())
          .collection('messages')
          .doc();

      // 2. Create the message object, now including the document ID
      final newMessage = Message(
        docId: docRef.id, // Assign the document ID here
        chatByUID: _currentUserUID,
        itemId: '',
        message: messageText,
        createdAt: DateTime.now(),
      );
      await docRef.set(newMessage.toFirestore());
      _scrollToBottom();
    } catch (e) {
      // Show an error if sending fails
      Get.snackbar(
        "Error",
        "Failed to send message. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // --- Create a unique but consistent chat room ID ---
  String _getChatRoomId() {
    List<String> ids = [_currentUserUID, widget.otherUserUID];
    ids.sort(); // Sort the UIDs to ensure the ID is the same regardless of who starts the chat
    return '${"sss"}_${ids.join('_')}';
  }

  // --- Auto-scroll to the bottom of the list ---
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Loading..."),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                _otherUser?.name.isNotEmpty == true 
                    ? _otherUser!.name[0].toUpperCase() 
                    : 'U',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _otherUser?.name ?? "Unknown User",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_otherUser != null)
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: _otherUser!.isOnline ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _otherUser!.isOnline ? "Online" : "Offline",
                          style: TextStyle(
                            fontSize: 12,
                            color: _otherUser!.isOnline ? Colors.green : Colors.grey,
                          ),
                        ),
                        if (_isTyping) ...[
                          const SizedBox(width: 8),
                          const Text(
                            "typing...",
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          if (_otherUser?.userType == UserType.counsellor)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showUserInfo(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_getChatRoomId())
                  .collection('messages')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No messages yet. Say hello!"),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong."));
                }

                // Scroll to bottom after the list is built
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final message = Message.fromFirestore(doc);
                    final isCurrentUser = message.chatByUID == _currentUserUID;
                    
                    // Show date separator if it's a new day
                    bool showDateSeparator = false;
                    if (index == 0) {
                      showDateSeparator = true;
                    } else {
                      final prevDoc = snapshot.data!.docs[index - 1];
                      final prevMessage = Message.fromFirestore(prevDoc);
                      final currentDate = DateTime(message.createdAt.year, message.createdAt.month, message.createdAt.day);
                      final prevDate = DateTime(prevMessage.createdAt.year, prevMessage.createdAt.month, prevMessage.createdAt.day);
                      showDateSeparator = !currentDate.isAtSameMomentAs(prevDate);
                    }

                    return Column(
                      children: [
                        if (showDateSeparator) _buildDateSeparator(message.createdAt),
                        Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser 
                                  ? CrossAxisAlignment.end 
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(18),
                                      topRight: const Radius.circular(18),
                                      bottomLeft: Radius.circular(isCurrentUser ? 18 : 4),
                                      bottomRight: Radius.circular(isCurrentUser ? 4 : 18),
                                    ),
                                  ),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color: isCurrentUser ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    _formatTime(message.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // --- Helper Methods ---
  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;
    return '${displayHour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (messageDate.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  void _showUserInfo(BuildContext context) {
    if (_otherUser == null) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                _otherUser!.name.isNotEmpty ? _otherUser!.name[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _otherUser!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_otherUser!.userType == UserType.counsellor) ...[
              Text(
                _otherUser!.specialization,
                style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                '${_otherUser!.experienceYears} years experience',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              if (_otherUser!.rating > 0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      _otherUser!.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ] else ...[
              Text(
                _otherUser!.occupation.isNotEmpty ? _otherUser!.occupation : 'Peer Support',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --- Message Input Field Widget ---
  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) {
                    setState(() {
                      _isTyping = value.trim().isNotEmpty;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _messageController.text.trim().isEmpty ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
