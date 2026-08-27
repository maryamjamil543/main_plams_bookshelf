// import 'dart:developer';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_base/providers/api_brick_kiln_survey_inspection_form_notifier.dart';
// import 'package:flutter_base/providers/api_de_sealing_form_notifier.dart';
// import 'package:flutter_base/utils/strings.dart';
// import 'package:flutter_base/utils/utils.dart';
// import 'package:flutter_base/widgets/custom_widgets.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:permission_handler/permission_handler.dart';
//
// import '../providers/api_water_pollution_notifier.dart';
//
// void pickMedia(
//     {required BuildContext context,
//     required WidgetRef ref,
//     String? type,
//     bool? isCompress}) async {
//   FocusManager.instance.primaryFocus?.unfocus();
//   if(await Utils.isAllPermissionsGranted()){
//     XFile? pickedFile;
//     showDialogForPickingSource(
//         context: context,
//         onTapFile: () async {
//           pickedFile = null;
//           Navigator.of(context).pop();
//           pickedFile = await ImagePicker().pickImage(
//               source: ImageSource.gallery,
//               imageQuality: isCompress == false ? 100 : 50);
//           if (pickedFile != null) {
//             if (type == 'pictureOfChimney') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(pictureOfChimneyStateProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//             } else if (type == 'selectedImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedWWTPPictureProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             } else if (type == 'selectedOrderDeSealImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPictureDeSealingProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             } else if (type == 'selectedProofOfFineImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPicturePaidOfFineProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }
//             else if (type == 'selectedAffidavitImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPictureAffidavitProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }else if (type == 'selectedPicture') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedActionTakenPictureProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }
//           }
//         },
//         onTapCamera: () async {
//           pickedFile = null;
//           Navigator.of(context).pop();
//           pickedFile = await ImagePicker().pickImage(
//               source: ImageSource.camera,
//               imageQuality: isCompress == false ? 100 : 50);
//
//           if (pickedFile != null) {
//             if (type == 'pictureOfChimney') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(pictureOfChimneyStateProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             } else if (type == 'selectedImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedWWTPPictureProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             } else if (type == 'selectedOrderDeSealImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPictureDeSealingProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }
//             else if (type == 'selectedProofOfFineImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPicturePaidOfFineProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             } else if (type == 'selectedAffidavitImage') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedPictureAffidavitProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }
//             else if (type == 'selectedPicture') {
//               final int? sizeInBytes = await (pickedFile)?.length();
//               final double sizeInMB = Utils.bytesToMegabytes(sizeInBytes!);
//               log("images size ${sizeInMB}");
//               if (sizeInMB <= 2) {
//                 ref.read(selectedActionTakenPictureProvider.notifier).state =
//                     (pickedFile?.path).toString();
//               } else {
//                 Fluttertoast.showToast(
//                     msg: "Your picture should be less than 500KB");
//               }
//               // ref.read(uploadBillProvider.notifier).state = (pickedFile?.path).toString();
//             }
//           }
//         });
//   }else{
//     Utils.showToast(allowAllPermissionText);
//     await openAppSettings();
//   }
// }
//
// String? validateEmail(String? value, {String? errorText}) {
//   // String pattern =
//   //     r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//   //     r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//   //     r"{0,253}[a-zA-Z0-9])?)*$";
//   String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
//   RegExp regex = RegExp(pattern);
//   if (value == null || value.isEmpty) {
//     return errorText ?? "* Required";
//   } else if (!regex.hasMatch(value)) {
//     return errorText ?? "* Enter a valid email address";
//   } else {
//     return null;
//   }
// }
//
// Future<void> pickPdfFromGallery(
//     {String? cnicType,
//     int? cnicIndex,
//     String? moduleName,
//     bool isNOC = false,
//     bool? isCnic = false,
//     required BuildContext context,
//     required String type,
//     int? index,
//     WidgetRef? ref}) async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf'],
//   );
//   print('isNOC::::::${isNOC.toString()}');
//
//   if (result != null && result.files.isNotEmpty) {
//     PlatformFile file = result.files.first;
//     File imageFile = File(file.path.toString());
//     final fileLength = await imageFile.length();
//     print('file length of document::::::${fileLength.toString()}');
//     if (fileLength < 5 * 1024 * 1024) {
//     } else {
//       Utils.showToast('File size should be less than 5 MB');
//     }
//   }
// }
//
// String maskMobileNumber(String mobileNumber) {
//   if (mobileNumber.isEmpty || mobileNumber.length <= 2) {
//     return mobileNumber;
//   }
//   return mobileNumber.replaceRange(
//       0, mobileNumber.length - 2, '*' * (mobileNumber.length - 2));
// }
