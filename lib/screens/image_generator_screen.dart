import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../services/image_service.dart';
import '../services/download_service.dart';
import '../services/gallery_service.dart';
import '../services/share_service.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() =>
      _ImageGeneratorScreenState();
}

class _ImageGeneratorScreenState
    extends State<ImageGeneratorScreen> {
  final TextEditingController promptController =
  TextEditingController();

  bool isLoading = false;
  bool isDownloading = false;
  String? imageUrl;
  File? downloadedFile;

  String size = "1024x1024";
  String quality = "high";

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  Future<void> generateImage() async {
    if (isLoading || isDownloading) return;

    // 🎯 जनरेट करते ही कीबोर्ड को अपने आप बंद करें
    FocusScope.of(context).unfocus();

    if (promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter image prompt"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      imageUrl = null;
      downloadedFile = null;
    });

    try {
      final result = await ImageService.generateImage(
        prompt: promptController.text,
        size: size,
        quality: quality,
      );

      if (!mounted) return;

      if (result.startsWith("http")) {
        setState(() {
          imageUrl = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // 🎯 सुरक्षित और ऑप्टिमाइज्ड हेल्पर मेथड (mounted check के साथ)
  Future<File?> _getOrDownloadFile() async {
    if (downloadedFile != null) return downloadedFile;

    if (imageUrl == null) return null;

    if (!mounted) return null;
    setState(() {
      isDownloading = true;
    });

    // 🎯 पुरानी स्नैकबार को हटाकर नई दिखाएं ताकि स्टैक न बने
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preparing image...")),
    );

    try {
      downloadedFile = await DownloadService.downloadImage(imageUrl!);
      return downloadedFile;
    } catch (e) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
      return null;
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Image Generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 🎯 टेक्स्ट फील्ड (मल्टीलाइन और लोडिंग के दौरान लॉक्ड)
            TextField(
              controller: promptController,
              maxLines: 5,
              enabled: !isLoading && !isDownloading,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: "Image Prompt",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🎯 साइज ड्रॉपडाउन (लोडिंग के दौरान लॉक्ड)
            DropdownButtonFormField<String>(
              initialValue: size,
              decoration: const InputDecoration(
                labelText: "Image Size",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "1024x1024",
                  child: Text("1024 x 1024"),
                ),
                DropdownMenuItem(
                  value: "1536x1024",
                  child: Text("1536 x 1024"),
                ),
                DropdownMenuItem(
                  value: "1024x1536",
                  child: Text("1024 x 1536"),
                ),
              ],
              onChanged: (isLoading || isDownloading)
                  ? null
                  : (value) {
                if (value != null) {
                  setState(() {
                    size = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // 🎯 क्वालिटी ड्रॉपडाउन (लोडिंग के दौरान लॉक्ड)
            DropdownButtonFormField<String>(
              initialValue: quality,
              decoration: const InputDecoration(
                labelText: "Quality",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "low",
                  child: Text("Low"),
                ),
                DropdownMenuItem(
                  value: "medium",
                  child: Text("Medium"),
                ),
                DropdownMenuItem(
                  value: "high",
                  child: Text("High"),
                ),
              ],
              onChanged: (isLoading || isDownloading)
                  ? null
                  : (value) {
                if (value != null) {
                  setState(() {
                    quality = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            // 🎯 जनरेट बटन
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: (isLoading || isDownloading) ? null : generateImage,
                child: isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.round,
                    semanticsLabel: "Generating image",
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  "Generate Image",
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🎯 इमेज डिस्प्ले और एक्शन बटन्स
            if (imageUrl != null) ...[
              GestureDetector(
                onTap: () {
                  // TODO: Full Screen Preview Navigation
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      cacheKey: imageUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 1024,
                      maxWidthDiskCache: 2048,
                      maxHeightDiskCache: 2048,
                      filterQuality: FilterQuality.medium,
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 150),
                      placeholder: (context, url) => const SizedBox(
                        height: 350,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const SizedBox(
                        height: 350,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🎯 Wrap का उपयोग ताकि छोटे स्क्रीन पर बटन ओवरफ्लो न हों
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  // 1. Download Button
                  ElevatedButton.icon(
                    onPressed: (imageUrl == null || isDownloading || isLoading)
                        ? null
                        : () async {
                      final file = await _getOrDownloadFile();
                      if (!context.mounted) return;

                      if (file != null) {
                        ScaffoldMessenger.of(context)
                            .hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Image downloaded successfully!")),
                        );
                      }
                    },
                    icon: isDownloading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.download),
                    label: const Text("Download"),
                  ),

                  // 2. Gallery Button
                  ElevatedButton.icon(
                    onPressed: (imageUrl == null || isDownloading || isLoading)
                        ? null
                        : () async {
                      final file = await _getOrDownloadFile();
                      if (!context.mounted) return;

                      if (file != null) {
                        final success =
                        await GalleryService.saveImage(file);
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context)
                            .hideCurrentSnackBar();
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Saved to Gallery successfully!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Failed to save in Gallery")),
                          );
                        }
                      }
                    },
                    icon: isDownloading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.save),
                    label: const Text("Gallery"),
                  ),

                  // 3. Share Button
                  ElevatedButton.icon(
                    onPressed: (imageUrl == null || isDownloading || isLoading)
                        ? null
                        : () async {
                      try {
                        final file = await _getOrDownloadFile();
                        if (!context.mounted) return;

                        if (file != null) {
                          await ShareService.shareImage(file);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Image shared successfully")),
                          );
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)
                            .hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Error sharing image: $e")),
                        );
                      }
                    },
                    icon: isDownloading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(Icons.share),
                    label: const Text("Share"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}