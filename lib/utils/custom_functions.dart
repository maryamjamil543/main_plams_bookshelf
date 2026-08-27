import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/custom_widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/api_events_register_notifier.dart';
import '../providers/api_subscription_detail_notifier.dart';

void pickMedia(
    {required BuildContext context,
      required WidgetRef ref,
      String? type,
      bool? isCompress}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  if(await Utils.isAllPermissionsGranted()){
    XFile? pickedFile;
    showDialogForPickingSource(
        context: context,
        onTapFile: () async {
          pickedFile = null;
          Navigator.of(context).pop();
          pickedFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
              imageQuality: isCompress == false ? 100 : 50);

          if (pickedFile != null) {
            if (isCompress != false) {
              File? compressedFile = await compressImage(File(pickedFile!.path));
              if (compressedFile != null) {
                pickedFile = XFile(compressedFile.path);
              }
            }
            if (type == 'transaction_screenshot') {
              final int? sizeInBytes = await (pickedFile)?.length();
              final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
              log("images size ${sizeInMB}");
              if (sizeInMB <= 0.5) {
                ref.read(pictureOfTransctionStateProvider.notifier).state =
                    (pickedFile?.path).toString();
              } else {
                Fluttertoast.showToast(
                    msg: "Your picture should be less than 500KB");
              }
            } else if (type == 'payment_proof') {
              final int? sizeInBytes = await (pickedFile)?.length();
              final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
              log("images size ${sizeInMB}");
              if (sizeInMB <= 0.5) {
                ref.read(pictureOfPaymentProofStateProvider.notifier).state =
                    (pickedFile?.path).toString();
              } else {
                Fluttertoast.showToast(
                    msg: "Your picture should be less than 500KB");
              }
            }
          }
        },
        onTapCamera: () async {
          pickedFile = null;
          Navigator.of(context).pop();
          pickedFile = await ImagePicker().pickImage(
              source: ImageSource.camera,
              imageQuality: isCompress == false ? 100 : 50);

          if (pickedFile != null) {
            if (isCompress != false) {
              File? compressedFile = await compressImage(File(pickedFile!.path));
              if (compressedFile != null) {
                pickedFile = XFile(compressedFile.path);
              }
            }
            if (type == 'transaction_screenshot') {
              final int? sizeInBytes = await (pickedFile)?.length();
              final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
              log("images size ${sizeInMB}");
              if (sizeInMB <= 2) {
                ref.read(pictureOfTransctionStateProvider.notifier).state =
                    (pickedFile?.path).toString();
              } else {
                Fluttertoast.showToast(
                    msg: "Your picture should be less than 500KB");
              }
              ref.read(pictureOfPaymentProofStateProvider.notifier).state = (pickedFile?.path).toString();
            } else if (type == 'payment_proof') {
              final int? sizeInBytes = await (pickedFile)?.length();
              final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
              log("images size ${sizeInMB}");
              if (sizeInMB <= 2) {
                ref.read(pictureOfPaymentProofStateProvider.notifier).state =
                    (pickedFile?.path).toString();
              } else {
                Fluttertoast.showToast(
                    msg: "Your picture should be less than 500KB");
              }
            }
          }
        });
  }else{
    Utils.showToast(allowAllPermissionText);
    await openAppSettings();
  }
}

Future<void> pickPdfFromGallery(
    {String? cnicType,
    int? cnicIndex,
    String? moduleName,
    bool isNOC = false,
    bool? isCnic = false,
    required BuildContext context,
    required String type,
    int? index,
    WidgetRef? ref}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  print('isNOC::::::${isNOC.toString()}');

  if (result != null && result.files.isNotEmpty) {
    PlatformFile file = result.files.first;
    File imageFile = File(file.path.toString());
    final fileLength = await imageFile.length();
    print('file length of document::::::${fileLength.toString()}');
    if (fileLength < 5 * 1024 * 1024) {
    } else {
      Utils.showToast('File size should be less than 5 MB');
    }
  }
}

Future<File?> compressImage(File file) async {
  final dir = await getTemporaryDirectory();

  final targetPath =
      "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

  final compressed = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 50,
    minWidth: 200,
    minHeight: 300,
    format: CompressFormat.jpeg,
  );

  return compressed != null ? File(compressed.path) : null;

}