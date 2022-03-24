import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutterbuyandsell/ui/vender_screens/vender_dashboard.dart';

// import 'package:dio/dio.dart' as dioC;
import 'package:flutterbuyandsell/vender_models/category_model.dart';
import 'package:flutterbuyandsell/vender_models/city_model.dart';
import 'package:flutterbuyandsell/vender_models/subcategory_model.dart';
import 'package:flutterbuyandsell/vender_models/location_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/ui/vender_screens/my_listing.dart';
import 'package:flutterbuyandsell/ui/vender_screens/packages.dart';
import 'package:flutterbuyandsell/ui/vender_screens/purchase_history.dart';

class AddListing extends StatefulWidget {
  const AddListing({Key key}) : super(key: key);

  @override
  _AddListingState createState() => _AddListingState();
}

class _AddListingState extends State<AddListing> {
  String title;
  bool isTitleError = false;
  String description;
  bool isDescriptionError = false;
  String price;
  bool isPriceError;
  List<XFile> pickedImages;

  String category;
  String city;
  String location;
  String subCategory;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<CategoryModel> categoryClass;
  List<CategoryListModel> categoryList;

  List<CityModel> cityClass;
  List<CityListModel> cityList;
  Future loadLocation;
  List<LocationModel> locationClass;
  List<LocationListModel> locationList;
  Future loadSubCategory;
  List<SubCategoryModel> subCategoryClass;
  List<SubCategoryListModel> subCategoryList;

  List<CategoryModel> categoryModelFromJson(String str) =>
      List<CategoryModel>.from(
          json.decode(str).map((dynamic x) => CategoryModel.fromJson(x)));
  List<CityModel> cityModelFromJson(String str) => List<CityModel>.from(
      json.decode(str).map((dynamic x) => CityModel.fromJson(x)));
  List<LocationModel> locationModelFromJson(String str) =>
      List<LocationModel>.from(
          json.decode(str).map((dynamic x) => LocationModel.fromJson(x)));
  List<SubCategoryModel> subCategoryModelFromJson(String str) =>
      List<SubCategoryModel>.from(
          json.decode(str).map((dynamic x) => SubCategoryModel.fromJson(x)));

  Future _loadCategory() async {
    dynamic response = await get(
            Uri.parse('https://deals24.live/Dealsjson/listing_categories'))
        .catchError((dynamic error) {
      print(error);
    });
    if (response.statusCode == 200) {
      categoryClass = categoryModelFromJson(response.body);
      setState(() {
        categoryList = categoryClass[0].categoryList;
      });
    } else {
      print('error in loading category list');
    }
  }

  Future _loadCity() async {
    dynamic response =
        await get(Uri.parse('https://deals24.live/Dealsjson/listing_city'))
            .catchError((dynamic error) {
      print(error);
    });
    if (response.statusCode == 200) {
      cityClass = cityModelFromJson(response.body);
      setState(() {
        cityList = cityClass[0].cityList;
      });
      print(cityList);
    } else {
      print('error in loading category list');
    }
  }

  Future _loadLocation() async {
    dynamic response =
        await get(Uri.parse('https://deals24.live/Dealsjson/listing_location'))
            .catchError((dynamic error) {
      print(error);
    });
    if (response.statusCode == 200) {
      locationClass = locationModelFromJson(response.body);
      locationList = locationClass[0].locationList;
      print(locationList);
    } else {
      print('error in loading category list');
    }
  }

  void _onChangeCategory(String categoryId, BuildContext context) async {
    dynamic response = await post(
        Uri.parse('https://deals24.live/Dealsjson/listing_subcategories'),
        body: {'category_id': categoryId}).catchError((dynamic error) {
      print(error);
    });
    if (response.statusCode == 200) {
      subCategoryClass = subCategoryModelFromJson(response.body);
      if (subCategoryClass[0].error == false) {
        setState(() {
          subCategoryList = subCategoryClass[0].subCategoryList;
        });
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error in Loading Sub Category'),
                content: Text(subCategoryClass[0].msg),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(); // dismiss dialog
                      })
                ],
              );
            });

        print(response.body);
      }
    } else {
      print('error in loading sub category list');
    }
  }

  void _onChangeCity(String cityId, BuildContext context) async {
    dynamic response = await post(
        Uri.parse('https://deals24.live/Dealsjson/listing_location'),
        body: {'city_id': cityId}).catchError((dynamic error) {
      print(error);
    });
    if (response.statusCode == 200) {
      locationClass = locationModelFromJson(response.body);
      if (locationClass[0].error == false) {
        setState(() {
          locationList = locationClass[0].locationList;
        });
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error in Loading city locations'),
                content: Text(subCategoryClass[0].msg),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(); // dismiss dialog
                      })
                ],
              );
            });

        print(response.body);
      }
    } else {
      print('error in loading location list');
    }
  }

  void _showToast(String title) {
    showToast(title,
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: Offset(0.0, 3.0),
        reverseEndOffset: Offset(0.0, 3.0),
        position: StyledToastPosition.center,
        duration: Duration(seconds: 4),
        //Animation duration   animDuration * 2 <= duration
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
  }

  Widget _showLoader(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 5,
                child: Lottie.asset("assets/images/loader.json")));
      },
    );
  }

  void _submitHandler(BuildContext context) async {
    if (category == null) {
      showToast('Please Select Category',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          startOffset: Offset(0.0, 3.0),
          reverseEndOffset: Offset(0.0, 3.0),
          position: StyledToastPosition.center,
          duration: Duration(seconds: 4),
          //Animation duration   animDuration * 2 <= duration
          animDuration: Duration(seconds: 1),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn);
    } else if (city == null) {
      showToast('Please Select City',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          startOffset: Offset(0.0, 3.0),
          reverseEndOffset: Offset(0.0, 3.0),
          position: StyledToastPosition.center,
          duration: Duration(seconds: 4),
          //Animation duration   animDuration * 2 <= duration
          animDuration: Duration(seconds: 1),
          curve: Curves.elasticOut,
          reverseCurve: Curves.fastOutSlowIn);
    } else if (location == null) {
      _showToast(
        'Please Select location',
      );
    } else if (subCategory == null) {
      _showToast(
        'Please Select Sub Category',
      );
    } else if (pickedImages?.isEmpty) {
      _showToast(
        'Please Select Image',
      );
    } else {
      // dioC.Dio dio = dioC.Dio();
      _showLoader(context);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user_id = await prefs.getString('vender_user_id');
      String user_name = await prefs.getString('vender_user_name');
      String user_email = await prefs.getString('vender_user_email');

      String user_phone = await prefs.getString('vender_user_phone');
      print(user_id);

      List<MultipartFile> fileList = new List<MultipartFile>();

      for (int i = 0; i < pickedImages.length; i++) {
        var file = await MultipartFile.fromPath(
            'gallery[]', pickedImages[i].path,
            filename: pickedImages[i].name);
        fileList.add(file);
      }

      print(fileList);

      dynamic request = await MultipartRequest(
          'POST', Uri.parse("https://deals24.live/Dealsjson/add_listing"));

      request.files.addAll(fileList);

      request.fields['user_id'] = user_id;
      request.fields['user_name'] = user_name;
      request.fields['user_email'] = user_email;
      request.fields['user_phone'] = user_phone;
      request.fields['category_id'] = category;
      request.fields['subcategory_id'] = subCategory;
      request.fields['city_id'] = city;
      request.fields['location_id'] = location;
      request.fields['title'] = titleController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['price'] = priceController.text;
      request.fields['property_id'] = '0';

      Response response = await Response.fromStream(await request.send());
      print("Result: ${response.statusCode}");

      if (response.statusCode == 200) {
        _showToast('List Added Succesfully');
        Navigator.pop(context);
        setState(() {
          category = null;
          subCategory = null;
          city = null;
          location = null;
          titleController.text = '';
          descriptionController.text = '';
          priceController.text = '';
          pickedImages = null;
        });
        Navigator.pushReplacement<dynamic, dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (context) => VenderDashboard()));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCategory();

    _loadCity();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 100),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [Text('Category')],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButton<String>(
                                      value: category,
                                      // icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          category = newValue;
                                          _onChangeCategory(newValue, context);
                                        });
                                      },
                                      hint: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Select Category')),
                                      items: categoryList != null
                                          ? categoryList
                                              .map<DropdownMenuItem<String>>(
                                                  (CategoryListModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.categoryId,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        value.categoryName)),
                                              );
                                            }).toList()
                                          : [],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [Text('City')],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButton<String>(
                                      value: city,
                                      // icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Select City')),
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          city = newValue;
                                          _onChangeCity(newValue, context);
                                        });
                                      },
                                      items: cityList != null
                                          ? cityList
                                              .map<DropdownMenuItem<String>>(
                                                  (CityListModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.cityId,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child:
                                                        Text(value.cityName)),
                                              );
                                            }).toList()
                                          : [],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [Text('Location')],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButton<String>(
                                      value: location,
                                      // icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          location = newValue;
                                        });
                                      },
                                      hint: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Select Location')),
                                      items: locationList != null
                                          ? locationList
                                              .map<DropdownMenuItem<String>>(
                                                  (LocationListModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.locationId,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        value.locationName)),
                                              );
                                            }).toList()
                                          : [],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [Text('Sub Category')],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButton<String>(
                                      value: subCategory,
                                      // icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      hint: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Select Sub Category')),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          subCategory = newValue;
                                        });
                                      },
                                      items: subCategoryList != null
                                          ? subCategoryList
                                              .map<DropdownMenuItem<String>>(
                                                  (SubCategoryListModel value) {
                                              return DropdownMenuItem<String>(
                                                value: value.subcategoryId,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                        value.subcategoryName)),
                                              );
                                            }).toList()
                                          : [],
                                    ),
                                  ),
                                  TextField(
                                    controller: titleController,
                                    onChanged: (value) {
                                      print(titleController.text);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      // errorText:
                                      //     isTitleError ? "Enter Title" : null,
                                    ),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      errorText: isDescriptionError
                                          ? 'Enter Description'
                                          : null,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 2,
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      labelStyle: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: Colors.grey,
                                      )),
                                      errorText: isDescriptionError
                                          ? 'Enter price'
                                          : null,
                                    ),
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: const Text('Select image'),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      )),
                                  const SizedBox(height: 10),
                                  if (pickedImages != null)
                                    SingleChildScrollView(
                                        child: Row(
                                            children: List.generate(
                                                pickedImages?.length,
                                                (index) => Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Image.file(
                                                        File(pickedImages[index]
                                                            .path),
                                                        height: 50,
                                                        width: 50)))))
                                  else
                                    const Text('not selected')
                                ],
                              ),
                            ))),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _submitHandler(context);
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff1d293e),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit Property',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: avoid_void_async
  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    pickedImages = await _picker.pickMultiImage();
    setState(() {});
  }
}
