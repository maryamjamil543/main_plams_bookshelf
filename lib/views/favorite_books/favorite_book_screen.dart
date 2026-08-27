import 'package:flutter/material.dart';
import 'package:flutter_base/providers/api_detail_book_notifier.dart';
import 'package:flutter_base/utils/api_state_model.dart';
import 'package:flutter_base/views/detail_screen/detail_book_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/response/book_response/Book.dart' as ApiBook;
import '../../models/response/sync/SyncResponse.dart';
import '../../models/states.dart';
import '../../utils/colors.dart';
import '../../utils/image_assets.dart';
import '../../utils/strings.dart';
import '../../widgets/dialog_widget/dialog_widget.dart';
import '../../widgets/raleway_text_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';

class FavoriteBooksScreen extends ConsumerStatefulWidget {
  final ApiBook.Book? bookJson;

  const FavoriteBooksScreen({super.key, this.bookJson});

  @override
  FavoriteBooksScreenState createState() => FavoriteBooksScreenState();
}

class FavoriteBooksScreenState extends ConsumerState<FavoriteBooksScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshFields();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiDetailBookNotifierProvider,
            (previous, apiStatesModel) {
          switch (apiStatesModel.states) {
            case States.ERROR:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(apiStatesModel.message),
              ));
              break;
            case States.DATA:
              if (apiStatesModel.data is SyncResponse) {
                final _response = apiStatesModel.data as SyncResponse;
                if (!(_response).status!) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(apiStatesModel.message),
                  ));
                  // }
                } else {
                  if (_response.data != null) {
                    Fluttertoast.showToast(
                        msg: _response.message!,
                        toastLength: Toast.LENGTH_SHORT);
                    // }
                  } else {}
                }
              }
              break;
            case States.SESSIONEXPIRED:
              DialogBuilder.showLogoutDialog(
                title: sessionExpiredText,
                content: sessionExpiredContent,
                isCancelable: false,
                buttonText: okButtonText,
                context: context,
                callback: () {},
              );
              break;
            default:
              break;
          }
        });
    return Stack(
      children: [
        _mainLayout(),
        // :: TODO loading widget
        LoadingWidget(),
      ],
    );
  }

  @override
  Widget _mainLayout() {
    // :: TODO listen filter list of books
    final filteredBooks = ref.watch(favoriteBooksProvider);
    // :: TODO check from db
    final rawState = ref.watch(rawFavoriteBooksProvider);
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        // :: TODO  main layout
        child: Scaffold(
          backgroundColor: ColorUtils.whiteColor,
          body: Stack(
            children: [
              Column(
                children: [
                  _headerSection(_scaffoldKey),
                  Expanded(
                    child: rawState.when(
                      data: (_) => _buildBooksList(filteredBooks),
                      loading: () => Center(child: LoadingWidget()),
                      error: (err, stack) =>
                          Center(
                            child: RalewayTextWidget(
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.redColor,
                              text: "Error loading favorites: $err",
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              if (_isLoading) const LoadingWidget(),
            ],
          ),
        ));
  }

  //TODO :: Header with background, search, and icons
  Widget _headerSection(GlobalKey<ScaffoldState> key) {
    return Stack(
      children: [
        // :: TODO dashboard background image
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.r),
            bottomRight: Radius.circular(30.r),
          ),
          child: Image.asset(
            dashboardBackgroundImage,
            height: 0.27.sh,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //::TODO  back arrow icon
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        backArrow,
                        height: 35.h,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    // :: TODO  favorite book
                    RalewayTextWidget(
                      fontsize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.whiteColor,
                      text: favoriteText,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 80.h),
                // :: TODO  search text filed to filter list of favorite books
                Row(
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minHeight: 50.h, maxHeight: 50.h),
                        child: CustomTextFieldSplash(
                          controller: searchController,
                          labelText: searchText,
                          fontSize: 21.sp,
                          hintColor: ColorUtils.lightBlackTextColor,
                          keyboardType: TextInputType.text,
                          isSearchField: false,
                          onChanged: (value) {
                            if (value.isEmpty)
                              ref
                                  .read(searchProvider.notifier)
                                  .state = "";
                          },

                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // :: TODO  search icon
                    InkWell(
                      onTap: () {
                        ref
                            .read(searchProvider.notifier)
                            .state =
                            searchController.text;
                      },
                      child: Container(
                        width: 56.w,
                        height: 51.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child:  Center(
                          child: Icon(
                            Icons.search,
                            color:ColorUtils.greenTextColor,
                            size: 26.h,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //TODO :: List of favorite books empty showing no data
  Widget _buildBooksList(List<ApiBook.Book> books) {
    if (books.isEmpty) {
      return Center(
        child: RalewayTextWidget(
          fontsize: 18.sp,
          fontWeight: FontWeight.w500,
          color: ColorUtils.mediumGrayColor,
          text:noFavoriteBook,
        ),
      );
    }
//TODO :: list of favorite books showing
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: books.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final book = books[index];

        return Card(
          elevation: 1,
          color: ColorUtils.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailBookScreen(bookJson: book),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  //TODO:: Book cover or initials
                  (book.coverImage != null && book.coverImage!.isNotEmpty)
                      ? Image.network(
                    book.coverImage!,
                    width: 60.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _initialsAvatar(book.title ?? "NA"),
                  )
                      : _initialsAvatar(book.title ?? "NA"),

                  SizedBox(width: 12.w),

                  //TODO:: Title & Author
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RalewayTextWidget(
                          fontsize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.blackColor,
                          text: book.title ?? "N/A",
                        ),
                        SizedBox(height: 4.h),
                        RalewayTextWidget(
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.mediumGrayColor,
                          text: book.author?.name ?? "N/A",
                        ),
                      ],
                    ),
                  ),

                  //TODO:: Delete button
                  IconButton(
                    icon: const Icon(Icons.delete, color: ColorUtils.redColor),
                    onPressed: () async {
                      final dao = ref.read(favoriteBookDaoProvider);
                      await dao.deleteByTitle(book.title ?? "");

                      ref.invalidate(rawFavoriteBooksProvider);

                      Fluttertoast.showToast(
                        msg: bookRemoved,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  //TODO :: Show initials avatar if no cover image
  Widget _initialsAvatar(String title) {
    final initials = _getInitials(title);
    return Container(
      width: 60.w,
      height: 80.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorUtils.lightYellow,
        borderRadius: BorderRadius.circular(8.r),
      ),
      //TODO:: initials text
      child: RalewayTextWidget(
        fontsize: 24.sp,
        fontWeight: FontWeight.w800,
        color: ColorUtils.blackColor,
        text: initials,
      ),
    );
  }
  //TODO:: get initials first 2 letters
  String _getInitials(String title) {
    if (title.isEmpty) return "NA";
    final words = title.trim().split(" ");
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else {
      return title.length >= 2
          ? title.substring(0, 2).toUpperCase()
          : title.toUpperCase();
    }
  }
  //TODO:: refresh fields
 void refreshFields(){
    ref.invalidate(rawFavoriteBooksProvider);
    ref.invalidate(favoriteBooksProvider);
    ref.refresh(searchProvider.notifier).state = searchController.text;
  }
}
