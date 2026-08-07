import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.imageUrl,
    required this.isLoading,
    required this.onDownload,
    required this.onShare,
    required this.onRegenerate,
  });

  final String imageUrl;
  final bool isLoading;

  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onRegenerate;

  bool get hasImage =>
      imageUrl.isNotEmpty &&
          !imageUrl.startsWith("ERROR:");

  bool get hasError =>
      imageUrl.startsWith("ERROR:");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 60,
                ),
                child: CircularProgressIndicator(),
              )

            else if (hasImage)
              ClipRRect(
                borderRadius:
                BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,

                  placeholder:
                      (context, url) =>
                  const SizedBox(
                    height: 260,
                    child: Center(
                      child:
                      CircularProgressIndicator(),
                    ),
                  ),

                  errorWidget:
                      (context, url, error) =>
                  const SizedBox(
                    height: 260,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              )

            else if (hasError)
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Column(
                    children: [

                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        imageUrl,
                        textAlign:
                        TextAlign.center,
                      ),

                    ],
                  ),
                )

              else
                const Padding(
                  padding:
                  EdgeInsets.symmetric(
                    vertical: 60,
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                    hasImage
                        ? onDownload
                        : null,
                    icon: const Icon(
                      Icons.download,
                    ),
                    label:
                    const Text("Download"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                    hasImage
                        ? onShare
                        : null,
                    icon: const Icon(
                      Icons.share,
                    ),
                    label:
                    const Text("Share"),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                hasImage
                    ? onRegenerate
                    : null,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  "Regenerate",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}