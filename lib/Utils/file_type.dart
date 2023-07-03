import 'package:flutter/material.dart';

enum FileType {
  general,
  image,
  document,
  folder;

  IconData getIconData({bool isDownload = true}) {
    return switch (this) {
      FileType.general =>
        isDownload ? Icons.file_download_rounded : Icons.file_upload_rounded,
      FileType.image => Icons.image_rounded,
      FileType.document => Icons.file_copy,
      FileType.folder => Icons.folder
    };
  }
}
