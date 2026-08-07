import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.onSend,
    required this.isLoading,
  });

  final ValueChanged<String> onSend;
  final bool isLoading;

  @override
  State<MessageInput> createState() =>
      _MessageInputState();
}

class _MessageInputState
    extends State<MessageInput> {
  final TextEditingController _controller =
  TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    widget.onSend(text);

    _controller.clear();

    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                minLines: 1,
                maxLines: 5,
                textInputAction:
                TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText:
                  "Ask JB Creator AI...",
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      30,
                    ),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            SizedBox(
              width: 54,
              height: 54,
              child: ElevatedButton(
                onPressed: widget.isLoading
                    ? null
                    : _send,
                style: ElevatedButton.styleFrom(
                  shape:
                  const CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
                child: widget.isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                )
                    : const Icon(
                  Icons.send,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}