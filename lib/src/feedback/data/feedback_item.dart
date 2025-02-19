// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:wiredash/src/_feedback.dart';
import 'package:wiredash/src/_wiredash_internal.dart';

/// Contains all relevant feedback information, both user-provided and
/// automatically inferred, that will be eventually sent to the Wiredash
/// console and are in the meantime persisted on disk inside
/// [PendingFeedbackItem].
///
/// Actual serialization happens in [PendingFeedbackItem]
class FeedbackItem {
  final List<PersistedAttachment>? attachments;
  final String feedbackId;
  final List<String>? labels;
  final AllMetaData metadata;
  final String message;

  const FeedbackItem({
    this.attachments,
    required this.feedbackId,
    this.labels,
    required this.metadata,
    required this.message,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedbackItem &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(attachments, other.attachments) &&
          feedbackId == other.feedbackId &&
          const ListEquality().equals(labels, other.labels) &&
          metadata == other.metadata &&
          message == other.message);

  @override
  int get hashCode =>
      const ListEquality().hash(attachments) ^
      feedbackId.hashCode ^
      const ListEquality().hash(labels) ^
      metadata.hashCode ^
      message.hashCode;

  @override
  String toString() {
    return 'FeedbackItem{ '
        'attachments: $attachments, '
        'feedbackId: $feedbackId, '
        'labels: $labels, '
        'metadata: $metadata, '
        'message: $message, '
        '}';
  }

  FeedbackItem copyWith({
    List<PersistedAttachment>? attachments,
    String? feedbackId,
    List<String>? labels,
    AllMetaData? metadata,
    String? message,
  }) {
    return FeedbackItem(
      attachments: attachments ?? this.attachments,
      feedbackId: feedbackId ?? this.feedbackId,
      labels: labels ?? this.labels,
      metadata: metadata ?? this.metadata,
      message: message ?? this.message,
    );
  }
}

abstract class PersistedAttachment {
  const PersistedAttachment();

  FileDataEventuallyOnDisk get file;

  bool get isUploaded => file.isUploaded;

  // ignore: prefer_constructors_over_static_methods
  static Screenshot screenshot({
    required FileDataEventuallyOnDisk file,
  }) {
    return Screenshot._(
      file: file,
    );
  }

// TODO add freezed like when() for more attachment types
}

/// A attachment type the user created using Wiredash screenshot feature
class Screenshot extends PersistedAttachment {
  const Screenshot._({
    required this.file,
  });

  @override
  final FileDataEventuallyOnDisk file;

  @override
  String toString() {
    return 'Screenshot{'
        'file: $file, '
        '}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Screenshot &&
          runtimeType == other.runtimeType &&
          file == other.file;

  @override
  int get hashCode => file.hashCode;

  Screenshot copyWith({
    FileDataEventuallyOnDisk? file,
    FlutterInfo? deviceInfo,
  }) {
    return PersistedAttachment.screenshot(
      file: file ?? this.file,
    );
  }
}

/// A [PersistedAttachment] type that is either in-memory, on disk or already
/// uploaded to the cloud
class FileDataEventuallyOnDisk {
  final Uint8List? data;
  final String? pathToFile;
  final AttachmentId? attachmentId;

  FileDataEventuallyOnDisk.inMemory(Uint8List data)
      // ignore: prefer_initializing_formals
      : data = data,
        pathToFile = null,
        attachmentId = null;

  FileDataEventuallyOnDisk.file(String path)
      : pathToFile = path,
        data = null,
        attachmentId = null;

  FileDataEventuallyOnDisk.uploaded(AttachmentId attachmentId)
      // ignore: prefer_initializing_formals
      : attachmentId = attachmentId,
        data = null,
        pathToFile = null;

  bool get isOnDisk => pathToFile != null;

  bool get isUploaded => attachmentId != null;

  bool get isInMemory => data != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileDataEventuallyOnDisk &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          pathToFile == other.pathToFile &&
          attachmentId == other.attachmentId;

  @override
  int get hashCode =>
      data.hashCode ^ pathToFile.hashCode ^ attachmentId.hashCode;

  @override
  String toString() {
    if (isUploaded) return "FileDataEventuallyOnDisk.uploaded($attachmentId)";
    if (isOnDisk) return "FileDataEventuallyOnDisk.file($pathToFile)";
    return 'FileDataEventuallyOnDisk.inMemory(${data!.lengthInBytes}bytes)';
  }
}

extension BinaryDataFromFile on FileDataEventuallyOnDisk {
  Uint8List? binaryData(FileSystem filesystem) {
    if (data != null) return data!;
    if (pathToFile != null) {
      return filesystem.file(pathToFile).readAsBytesSync();
    }
    return null;
  }
}
