import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../models/prompt_model.dart';
import '../services/history_service.dart';
import '../services/image_service.dart';
import '../services/openai_service.dart';
import '../widgets/generate_button.dart';

class AIThumbnailScreen extends StatefulWidget {
  const AIThumbnailScreen({super.key});

  @override
  State<AIThumbnailScreen> createState() =>
      _AIThumbnailScreenState();
}

class _AIThumbnailScreenState
    extends State<AIThumbnailScreen> {
  final TextEditingController topicController =
  TextEditingController();

  String thumbnailStyle = 'Vibrant & Modern';
  String colorTone = 'High Contrast';

  final List<String> thumbnailStyles = [
    'Vibrant & Modern',
    'Minimalist',
    'Cinematic',
    'Gaming / Esports',
    'Tech & Gadgets',
  ];

  final List<String> colorTones = [
    'High Contrast',
    'Dark & Moody',
    'Bright & Neon',
    'Warm Tones',
    'Cool Tones',
  ];

  String generatedPrompt = '';
  String generatedImage = '';

  bool isGeneratingPrompt = false;
  bool isGeneratingImage = false;
  bool isFavorite = false;

  bool get isBusy =>
      isGeneratingPrompt || isGeneratingImage;

  @override
  void dispose() {
    topicController.dispose();
    super.dispose();
  }

  Future<void> generateThumbnail() async {
    final messenger = ScaffoldMessenger.of(context);

    FocusScope.of(context).unfocus();

    final topic = topicController.text.trim();

    if (topic.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your video title or thumbnail idea.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isGeneratingImage = true;
      generatedPrompt = '';
      generatedImage = '';
      isFavorite = false;
    });

    try {
      final promptRequest = '''
Create a professional, high-CTR YouTube thumbnail
generation prompt.

Video / Thumbnail Topic:
$topic

Thumbnail Style:
$thumbnailStyle

Color Tone:
$colorTone

Canvas:
16:9 YouTube thumbnail.

Requirements:
- Create an eye-catching professional composition.
- Strong visual hierarchy.
- One clear main subject.
- Dramatic and attractive lighting.
- High contrast.
- Professional depth and cinematic composition.
- Leave suitable space for thumbnail text.
- Make the image visually understandable even at small size.
- Use realistic and detailed visual elements.
- Avoid clutter.
- Make it suitable for a modern YouTube channel.
- Do not generate a long explanation.
- Return only the final image-generation prompt.
''';

      final promptResult =
      await OpenAIService.generateText(
        promptRequest,
      );

      if (!mounted) return;

      if (promptResult.startsWith('ERROR:') ||
          promptResult.startsWith('❌') ||
          promptResult.startsWith('⚠️')) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(promptResult),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final finalPrompt = promptResult.trim();

      setState(() {
        generatedPrompt = finalPrompt;
      });

      final imageResult =
      await ImageService.generateImage(
        prompt: finalPrompt,
        size: '1536x1024',
        quality: 'high',
      );

      if (!mounted) return;

      if (imageResult.startsWith('ERROR:')) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              _friendlyError(imageResult),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() {
        generatedImage = imageResult;
      });

      await HistoryService.addPrompt(
        PromptModel(
          title: topic,
          prompt: finalPrompt,
          createdAt: DateTime.now(),
          isFavorite: false,
        ),
      );

      if (!mounted) return;

      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Professional YouTube thumbnail generated! 🎉',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Thumbnail generation failed: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingImage = false;
        });
      }
    }
  }

  Future<void> generatePromptOnly() async {
    final messenger = ScaffoldMessenger.of(context);

    FocusScope.of(context).unfocus();

    final topic = topicController.text.trim();

    if (topic.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your thumbnail idea.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isGeneratingPrompt = true;
      generatedPrompt = '';
      generatedImage = '';
      isFavorite = false;
    });

    try {
      final prompt = '''
Create a professional high-CTR YouTube thumbnail prompt.

Topic:
$topic

Style:
$thumbnailStyle

Color Tone:
$colorTone

Aspect Ratio:
16:9

Return only a detailed production-ready
image generation prompt.
''';

      final result =
      await OpenAIService.generateText(prompt);

      if (!mounted) return;

      if (result.startsWith('ERROR:') ||
          result.startsWith('❌') ||
          result.startsWith('⚠️')) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );
        return;
      }

      setState(() {
        generatedPrompt = result.trim();
      });

      await HistoryService.addPrompt(
        PromptModel(
          title: topic,
          prompt: result.trim(),
          createdAt: DateTime.now(),
          isFavorite: false,
        ),
      );

      if (!mounted) return;

      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Thumbnail prompt generated and saved.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Prompt generation failed: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingPrompt = false;
        });
      }
    }
  }

  String _friendlyError(String error) {
    switch (error) {
      case 'ERROR: API_KEY':
        return 'OpenAI API key is not configured.';

      case 'ERROR: INVALID_API_KEY':
        return 'Invalid OpenAI API key.';

      case 'ERROR: BILLING_OR_RATE_LIMIT':
        return 'OpenAI billing or rate-limit issue.';

      case 'ERROR: ACCESS_DENIED':
        return 'Image generation access was denied.';

      case 'ERROR: TIMEOUT':
        return 'Image generation timed out. Please try again.';

      case 'ERROR: NETWORK':
        return 'Network error. Check your internet connection.';

      case 'ERROR: SERVER':
        return 'OpenAI server error. Please try again.';

      default:
        return error;
    }
  }

  Future<Uint8List?> _getImageBytes() async {
    if (generatedImage.isEmpty) {
      return null;
    }

    if (generatedImage.startsWith('BASE64:')) {
      final data =
      generatedImage.substring(7);

      return base64Decode(data);
    }

    final response = await http.get(
      Uri.parse(generatedImage),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return response.bodyBytes;
    }

    return null;
  }

  Future<void> saveImage() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final bytes = await _getImageBytes();

      if (bytes == null) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to load generated thumbnail.',
            ),
          ),
        );
        return;
      }

      final result =
      await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name:
        'JB_Thumbnail_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result != null
                ? 'Thumbnail saved to gallery! 📸'
                : 'Unable to save thumbnail.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Save failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> shareImage() async {
    try {
      final bytes = await _getImageBytes();

      if (bytes == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to load thumbnail for sharing.',
            ),
          ),
        );

        return;
      }

      final file = XFile.fromData(
        bytes,
        name: 'jb_creator_thumbnail.png',
        mimeType: 'image/png',
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [file],
          text: 'Created with JB Creator AI',
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Share failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> copyPrompt() async {
    if (generatedPrompt.isEmpty) return;

    await Clipboard.setData(
      ClipboardData(
        text: generatedPrompt,
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Thumbnail prompt copied.',
        ),
      ),
    );
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Added to Favorites ❤️'
              : 'Removed from Favorites',
        ),
      ),
    );
  }

  void clearAll() {
    setState(() {
      topicController.clear();
      generatedPrompt = '';
      generatedImage = '';
      thumbnailStyle = 'Vibrant & Modern';
      colorTone = 'High Contrast';
      isFavorite = false;
    });
  }

  Widget _buildImagePreview() {
    if (generatedImage.startsWith('BASE64:')) {
      final data =
      generatedImage.substring(7);

      return Image.memory(
        base64Decode(data),
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      generatedImage,
      fit: BoxFit.cover,
      loadingBuilder:
          (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder:
          (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 60,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Thumbnail Generator',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Clear',
            icon: const Icon(
              Icons.delete_outline,
            ),
            onPressed: isBusy ? null : clearAll,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create YouTube Thumbnails',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Generate professional 16:9 thumbnails designed for YouTube.',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: topicController,
                maxLines: 3,
                maxLength: 500,
                textCapitalization:
                TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText:
                  'Thumbnail Topic / Video Title',
                  hintText:
                  'Example: Heart Touching Hindi Romantic Song',
                  prefixIcon: const Icon(
                    Icons.lightbulb_outline_rounded,
                  ),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Thumbnail Style',
                value: thumbnailStyle,
                items: thumbnailStyles,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    thumbnailStyle = value;
                  });
                },
              ),

              const SizedBox(height: 14),

              _buildDropdown(
                label: 'Color Tone',
                value: colorTone,
                items: colorTones,
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    colorTone = value;
                  });
                },
              ),

              const SizedBox(height: 14),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.aspect_ratio_rounded,
                  ),
                  title: const Text(
                    'YouTube Thumbnail',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    '16:9 • 1536 × 1024 • High Quality',
                  ),
                  trailing: Icon(
                    Icons.check_circle_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GenerateButton(
                text: 'Generate Thumbnail',
                isLoading: isGeneratingImage,
                onPressed:
                isBusy ? null : generateThumbnail,
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed:
                isBusy ? null : generatePromptOnly,
                icon: const Icon(
                  Icons.auto_awesome_rounded,
                ),
                label: Text(
                  isGeneratingPrompt
                      ? 'Creating Prompt...'
                      : 'Generate Prompt Only',
                ),
              ),

              if (isGeneratingImage) ...[
                const SizedBox(height: 20),
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text(
                        'Creating your YouTube thumbnail...',
                      ),
                    ],
                  ),
                ),
              ],

              if (generatedPrompt.isNotEmpty) ...[
                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Generated Thumbnail Prompt',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy',
                              onPressed: copyPrompt,
                              icon: const Icon(
                                Icons.copy_rounded,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        SelectableText(
                          generatedPrompt,
                          style: const TextStyle(
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              if (generatedImage.isNotEmpty) ...[
                const SizedBox(height: 24),

                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: _buildImagePreview(),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child:
                              OutlinedButton.icon(
                                onPressed:
                                toggleFavorite,
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons
                                      .favorite_border,
                                ),
                                label: Text(
                                  isFavorite
                                      ? 'Favorited'
                                      : 'Favorite',
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child:
                              OutlinedButton.icon(
                                onPressed: saveImage,
                                icon: const Icon(
                                  Icons.download_rounded,
                                ),
                                label:
                                const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(
                          12,
                          0,
                          12,
                          12,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child:
                          ElevatedButton.icon(
                            onPressed: shareImage,
                            icon: const Icon(
                              Icons.share_rounded,
                            ),
                            label:
                            const Text('Share Thumbnail'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: items.map(
            (item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        },
      ).toList(),
      onChanged: isBusy ? null : onChanged,
    );
  }
}