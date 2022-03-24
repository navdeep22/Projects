import 'package:club_app/constants/constants.dart';
import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/add_addon_to_cart_bloc.dart';
import 'package:club_app/logic/bloc/add_on_bloc.dart';
import 'package:club_app/logic/models/add_on_model.dart';
import 'package:club_app/logic/models/cart_table_event_model.dart';
import 'package:club_app/logic/models/tables_model.dart';
import 'package:club_app/observer/add_on_observable.dart';
import 'package:club_app/observer/add_on_observer.dart';
import 'package:club_app/ui/utils/utility.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:club_app/ui/widgets/outline_border_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:club_app/ui/widgets/dialog_addons_dart.dart';

class AddOns extends StatefulWidget {
  @override
  _AddOnsState createState() => _AddOnsState();
}

class _AddOnsState extends State<AddOns> implements AddOnObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AddOnsBloc _addOnsBloc;
  double totalAmount = 0.0;
  List<AddOnModel> addOnBestSellerList;
  List<AddOnModel> addOnFoodPackagesList;
  List<AddOnModel> addOnDrinksList;
  List<AddOnModel> cartAddOn;
  final CarouselController _bestSellerController = CarouselController();
  final CarouselController _foodPackagesController = CarouselController();
  final CarouselController _drinksController = CarouselController();
  AddOnObservable _addOnObservable;
  AddAddonToCartBloc _addAddonToCartBloc;
  int addonID;

  @override
  void initState() {
    super.initState();
    _addOnsBloc = AddOnsBloc();
    _addOnObservable = AddOnObservable();
    _addAddonToCartBloc = AddAddonToCartBloc();
    _addOnObservable.register(this);
    fetchAddOns();
  }

  Future<void> fetchAddOns() async {
//    _addOnsBloc.fetchDummyAddOns();
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      await _addOnsBloc.fetchTableCartList();
      _addOnsBloc.fetchAddOns();
    } else {
      ackAlert(context, ClubApp.no_internet_message);
    }
  }

  @override
  void dispose() {
    _addOnsBloc.dispose();
    _addOnObservable.unRegister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          title: const Text('Add On Packages'),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
            onPressed: () {
              AppNavigator.gotoLanding(context);
            },
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
          )
          ],
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: false,
              dragStartBehavior: DragStartBehavior.start,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  child: Text('Bestseller'),
                ),
                Tab(
                  child: Text('Food'),
                ),
                Tab(
                  child: Text('Drinks'),
                ),
              ],
            ),
            preferredSize: Size.fromHeight(56.0),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<bool>(
            stream: _addOnsBloc.loaderController.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              bool isLoading = false;
              if (snapshot.hasData) {
                isLoading = snapshot.data;
              }

              return ModalProgressHUD(
                inAsyncCall: isLoading,
                //color: dividerColor,
                progressIndicator: const CircularProgressIndicator(
                  backgroundColor: dividerColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TabBarView(
                        //physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          getBestSeller(),
                          getFoodPackages(),
                          getDrinks()
                        ],
                      ),
                    ),
                    getBottomView(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getBottomView(context) {
    return Container(
      color: cardBackgroundColor,
//      color: Colors.grey.withAlpha(75),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Total',
                //     style: Theme.of(context)
                //         .textTheme
                //         .subtitle1
                //         .apply(color: textColorDarkPrimary)),
                // Text('${ClubApp.currencyLbl} ' + totalAmount.toStringAsFixed(2),
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyText1
                //         .apply(color: textColorDarkPrimary)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlineBorderButton(
                  buttonBackground,
                  12.0,
                  32.0,
                  ClubApp.btn_go_cart,
                  Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(color: Colors.white), onPressed: () {
                AppNavigator.gotoTableCart(
                    context, _addOnsBloc.tableCart, _addOnsBloc.eventCart);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget getBestSeller() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        debugPrint('In aad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In aad ons list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == AddOnState.NoData) {
          debugPrint('In aad ons list controller snapshot no data ');
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }

        if (addOnBestSellerList == null) {
          addOnBestSellerList = <AddOnModel>[];
        } else {
          addOnBestSellerList.clear();
        }
        for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
          if (_addOnsBloc.addOnList[i].addOnType == 1) {
            addOnBestSellerList.add(_addOnsBloc.addOnList[i]);
          }
        }
        if (addOnBestSellerList.length > 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: CarouselSlider.builder(
              carouselController: _bestSellerController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              itemCount: addOnBestSellerList.length,
              itemBuilder: (BuildContext context, int itemIndex) => Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _bestSellerController.previousPage();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green,
                            height: 200,
                            child: addOnBestSellerList[itemIndex].imageLink ==
                                        null ||
                                    addOnBestSellerList[itemIndex]
                                        .imageLink
                                        .isEmpty
                                ? Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image: addOnBestSellerList[itemIndex]
                                        .imageLink,
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            _bestSellerController.nextPage();
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    addOnBestSellerList[itemIndex].name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: textColorDarkPrimary, fontWeightDelta: 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Price: ${ClubApp.currencyLbl} ${addOnBestSellerList[itemIndex].cost}',
                    style: Theme.of(context).textTheme.subtitle1.apply(
                          color: textColorDarkPrimary,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlineButton(
                    onPressed: () {
                      /*setState(() {
                        bool isClaimed =
                            addOnBestSellerList[itemIndex].isAddedToCart;
                        if (isClaimed) {
                          totalAmount -= addOnBestSellerList[itemIndex].cost;
                          cartAddOn.remove(addOnBestSellerList[itemIndex]);
                        } else {
                          totalAmount += addOnBestSellerList[itemIndex].cost;
                          cartAddOn.add(addOnBestSellerList[itemIndex]);
                        }
                        addOnBestSellerList[itemIndex].isAddedToCart =
                            !isClaimed;
                      });*/
                      print("Table cart");
                      print(_addOnsBloc.tableCart);
                      print("Event cart");
                      print(_addOnsBloc.eventCart);
                      if (_addOnsBloc.tableCart.isNotEmpty ||
                          _addOnsBloc.eventCart.isNotEmpty) {
                        //bool isClaimed =
                        //  addOnBestSellerList[itemIndex].isAddedToCart;
                        bool isClaimed = false;
                        if (isClaimed) {
                          for (TableCartModel blocTableModel
                              in _addOnsBloc.tableCart) {
                            if (blocTableModel.addons
                                .contains(addOnBestSellerList[itemIndex])) {
                              debugPrint(
                                  'Add on contains in ${blocTableModel.tableName}');
                              blocTableModel.addons
                                  .remove(addOnBestSellerList[itemIndex]);
                              totalAmount -=
                                  addOnBestSellerList[itemIndex].cost;
                            }
                          }
                          setState(() {
                            addOnBestSellerList[itemIndex].isAddedToCart =
                                !isClaimed;
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddOnDialog(
                                  tables: _addOnsBloc.tableCart,
                                  events: _addOnsBloc.eventCart,
                                  selectedTables: const <TableCartModel>[],
                                  selectedEvents: const <EventCartModel>[],
                                  onSelectedTablesChanged:
                                      (List<TableCartModel> tables) {},
                                );
                              }).then((value) {
                            dynamic tables = value["table"];
                            dynamic events = value["events"];
                            if (tables.length > 0) {
                              String tableUnitIds = "";
                              if ((tables as List<TableCartModel>).isNotEmpty) {
                                for (final TableCartModel tableModel
                                    in tables) {
                                  for (TableCartModel blocTableModel
                                      in _addOnsBloc.tableCart) {
                                    if (tableModel.id == blocTableModel.id) {
                                      // debugPrint(
                                      //     'Add on added in ${blocTableModel.tableName}');
                                      if (tableUnitIds == "") {
                                        tableUnitIds =
                                            blocTableModel.id.toString();
                                      } else {
                                        tableUnitIds = tableUnitIds +
                                            "," +
                                            blocTableModel.id.toString();
                                      }

                                      setState(() {
                                        addonID =
                                            addOnBestSellerList[itemIndex].id;
                                      });

                                      // debugPrint(
                                      //     'Add on id ${cartAddOn[0].id}');

                                      // debugPrint(
                                      //     'table unit ids $tableUnitIds');

                                      // blocTableModel.addons.add(
                                      //     addOnBestSellerList[itemIndex]);
                                      // totalAmount +=
                                      //     addOnBestSellerList[itemIndex].cost;
                                      break;
                                    }
                                  }
                                }
                                setState(() {
                                  addOnBestSellerList[itemIndex].isAddedToCart =
                                      !isClaimed;
                                });
                              } else {
                                Utility.showSnackBarMessage(_scaffoldKey,
                                    'Please select at least one table');
                              }

                              _addAddonToCartBloc.addAddon(
                                  addonID, tableUnitIds, 1, "table", context);
                            }
                            if (events.length > 0) {
                              String eventUnitIds = "";
                              if ((events as List<EventCartModel>).isNotEmpty) {
                                for (final EventCartModel eventCartModel
                                    in events) {
                                  print(
                                      "eventCartModel ${eventCartModel.eventId}");

                                  for (EventCartModel blocEventModel
                                      in _addOnsBloc.eventCart) {
                                    print(
                                        "blocEventModel ${blocEventModel.eventId}");
                                    if (eventCartModel.eventId ==
                                        blocEventModel.eventId) {
                                      // debugPrint(
                                      //     'Add on added in ${blocTableModel.tableName}');
                                      if (eventUnitIds == "") {
                                        eventUnitIds =
                                            blocEventModel.id.toString();
                                      } else {
                                        eventUnitIds = eventUnitIds +
                                            "," +
                                            blocEventModel.id.toString();
                                      }

                                      setState(() {
                                        addonID =
                                            addOnBestSellerList[itemIndex].id;
                                      });

                                      break;
                                    }
                                  }
                                }
                                setState(() {
                                  addOnBestSellerList[itemIndex].isAddedToCart =
                                      !isClaimed;
                                });
                              } else {
                                Utility.showSnackBarMessage(_scaffoldKey,
                                    'Please select at least one event');
                              }

                              _addAddonToCartBloc.addAddon(
                                  addonID, eventUnitIds, 1, "event", context);
                            }
                          });
                        }
                      } else {
                        Utility.showSnackBarMessage(_scaffoldKey,
                            'Please add table before adding add ons');
                      }
                    },
                    borderSide: const BorderSide(color: colorPrimaryText
                        /*addOnBestSellerList[itemIndex].isAddedToCart
                          ? unClaimButtonColor
                          : claimButtonColor,*/
                        ),
                    child: Text(
                      addOnBestSellerList[itemIndex].isAddedToCart
                          ? 'Add to cart'
                          : 'Add to cart',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .apply(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }
      },
    );
  }

  Widget getFoodPackages() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        debugPrint('In oad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In oad ons list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == AddOnState.NoData) {
          debugPrint('In oad ons list controller snapshot no data ');
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }

        if (addOnFoodPackagesList == null) {
          addOnFoodPackagesList = <AddOnModel>[];
        } else {
          addOnFoodPackagesList.clear();
        }
        for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
          if (_addOnsBloc.addOnList[i].addOnType == 2) {
            addOnFoodPackagesList.add(_addOnsBloc.addOnList[i]);
          }
        }
        if (addOnFoodPackagesList.length > 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: CarouselSlider.builder(
              carouselController: _foodPackagesController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              itemCount: addOnFoodPackagesList.length,
              itemBuilder: (BuildContext context, int itemIndex) => Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _foodPackagesController.previousPage();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green,
                            height: 200,
                            child: addOnFoodPackagesList[itemIndex].imageLink ==
                                        null ||
                                    addOnFoodPackagesList[itemIndex]
                                        .imageLink
                                        .isEmpty
                                ? Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image: addOnFoodPackagesList[itemIndex]
                                        .imageLink,
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            _foodPackagesController.nextPage();
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    addOnFoodPackagesList[itemIndex].name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: textColorDarkPrimary, fontWeightDelta: 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Price: ${ClubApp.currencyLbl} ${addOnFoodPackagesList[itemIndex].cost}',
                    style: Theme.of(context).textTheme.subtitle1.apply(
                          color: textColorDarkPrimary,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlineButton(
                    onPressed: () {
                      /*setState(() {
                        bool isClaimed =
                            addOnFoodPackagesList[itemIndex].isAddedToCart;
                        if (isClaimed) {
                          totalAmount -= addOnFoodPackagesList[itemIndex].cost;
                          cartAddOn.remove(addOnFoodPackagesList[itemIndex]);
                        } else {
                          totalAmount += addOnFoodPackagesList[itemIndex].cost;
                          cartAddOn.add(addOnFoodPackagesList[itemIndex]);
                        }
                        addOnFoodPackagesList[itemIndex].isAddedToCart =
                            !isClaimed;
                      });*/

                      if (_addOnsBloc.tableCart.isNotEmpty ||
                          _addOnsBloc.eventCart.isNotEmpty) {
                        bool isClaimed =
                            addOnFoodPackagesList[itemIndex].isAddedToCart;

                        if (isClaimed) {
                          for (TableCartModel blocTableModel
                              in _addOnsBloc.tableCart) {
                            if (blocTableModel.addons
                                .contains(addOnFoodPackagesList[itemIndex])) {
                              debugPrint(
                                  'Add on food package contains in ${blocTableModel.tableName}');
                              blocTableModel.addons
                                  .remove(addOnFoodPackagesList[itemIndex]);
                              totalAmount -=
                                  addOnFoodPackagesList[itemIndex].cost;
                            }
                          }
                          setState(() {
                            addOnFoodPackagesList[itemIndex].isAddedToCart =
                                !isClaimed;
                          });
                        } else {
                          if (_addOnsBloc.tableCart.length == 1) {
                            // _addOnsBloc.tableCart[0].addons
                            //     .add(addOnFoodPackagesList[itemIndex]);
                            totalAmount +=
                                addOnFoodPackagesList[itemIndex].cost;

                            setState(() {
                              addOnFoodPackagesList[itemIndex].isAddedToCart =
                                  !isClaimed;
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AddOnDialog(
                                    tables: _addOnsBloc.tableCart,
                                    events: _addOnsBloc.eventCart,
                                    selectedTables: const <TableCartModel>[],
                                    selectedEvents: const <EventCartModel>[],
                                    onSelectedTablesChanged:
                                        (List<TableCartModel> tables) {},
                                  );
                                }).then((value) {
                              dynamic tables = value["table"];
                              dynamic events = value["events"];
                              if (tables.length > 0) {
                                String tableUnitIds = "";
                                if ((tables as List<TableCartModel>)
                                    .isNotEmpty) {
                                  for (final TableCartModel tableModel
                                      in tables) {
                                    for (TableCartModel blocTableModel
                                        in _addOnsBloc.tableCart) {
                                      if (tableModel.id == blocTableModel.id) {
                                        // debugPrint(
                                        //     'Add on added in ${blocTableModel.tableName}');
                                        if (tableUnitIds == "") {
                                          tableUnitIds =
                                              blocTableModel.id.toString();
                                        } else {
                                          tableUnitIds = tableUnitIds +
                                              "," +
                                              blocTableModel.id.toString();
                                        }

                                        setState(() {
                                          addonID =
                                              addOnFoodPackagesList[itemIndex]
                                                  .id;
                                        });

                                        break;
                                      }
                                    }
                                  }
                                  setState(() {
                                    addOnBestSellerList[itemIndex]
                                        .isAddedToCart = !isClaimed;
                                  });
                                } else {
                                  Utility.showSnackBarMessage(_scaffoldKey,
                                      'Please select at least one table');
                                }

                                _addAddonToCartBloc.addAddon(
                                    addonID, tableUnitIds, 1, "table", context);
                              }
                              if (events.length > 0) {
                                String eventUnitIds = "";
                                if ((events as List<EventCartModel>)
                                    .isNotEmpty) {
                                  for (final EventCartModel eventCartModel
                                      in events) {
                                    print(
                                        "eventCartModel ${eventCartModel.id}");

                                    for (EventCartModel blocEventModel
                                        in _addOnsBloc.eventCart) {
                                      print(
                                          "blocEventModel ${blocEventModel.id}");
                                      if (eventCartModel.eventId ==
                                          blocEventModel.eventId) {
                                        if (eventUnitIds == "") {
                                          eventUnitIds =
                                              blocEventModel.id.toString();
                                        } else {
                                          eventUnitIds = eventUnitIds +
                                              "," +
                                              blocEventModel.id.toString();
                                        }

                                        setState(() {
                                          addonID =
                                              addOnFoodPackagesList[itemIndex]
                                                  .id;
                                        });

                                        break;
                                      }
                                    }
                                  }
                                  setState(() {
                                    addOnBestSellerList[itemIndex]
                                        .isAddedToCart = !isClaimed;
                                  });
                                } else {
                                  Utility.showSnackBarMessage(_scaffoldKey,
                                      'Please select at least one table');
                                }

                                _addAddonToCartBloc.addAddon(
                                    addonID, eventUnitIds, 1, "event", context);
                              }
                            });
                          }
                        }
                      } else {
                        Utility.showSnackBarMessage(_scaffoldKey,
                            'Please add table before adding add ons');
                      }
                    },
                    borderSide: const BorderSide(color: colorPrimaryText
                        /*addOnFoodPackagesList[itemIndex].isAddedToCart
                          ? unClaimButtonColor
                          : claimButtonColor,*/
                        ),
                    child: Text(
                      addOnFoodPackagesList[itemIndex].isAddedToCart
                          ? 'Remove from cart'
                          : 'Add to cart',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .apply(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }
      },
    );
  }

  Widget getDrinks() {
    return StreamBuilder<AddOnState>(
      stream: _addOnsBloc.addOnListController.stream,
      builder: (BuildContext context, AsyncSnapshot<AddOnState> snapshot) {
        debugPrint('In oad ons list controller stream builder ');
        if (snapshot.hasError || !snapshot.hasData) {
          debugPrint(
              'In oad ons list controller snapshot has error or has not data ');
          return Container();
        }
        if (snapshot.data == AddOnState.NoData) {
          debugPrint('In oad ons list controller snapshot no data ');
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }

        if (addOnDrinksList == null) {
          addOnDrinksList = <AddOnModel>[];
        } else {
          addOnDrinksList.clear();
        }
        for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
          if (_addOnsBloc.addOnList[i].addOnType == 3) {
            addOnDrinksList.add(_addOnsBloc.addOnList[i]);
          }
        }
        if (addOnDrinksList.length > 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: CarouselSlider.builder(
              carouselController: _drinksController,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height,
                autoPlay: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              itemCount: addOnDrinksList.length,
              itemBuilder: (BuildContext context, int itemIndex) => Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            _drinksController.previousPage();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.green,
                            height: 200,
                            child: addOnDrinksList[itemIndex].imageLink ==
                                        null ||
                                    addOnDrinksList[itemIndex].imageLink.isEmpty
                                ? Image.asset(
                                    'assets/images/placeholder.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image: addOnDrinksList[itemIndex].imageLink,
                                    fadeInDuration:
                                        const Duration(milliseconds: 300),
                                    fit: BoxFit.fill,
                                    alignment: Alignment.center,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            _drinksController.nextPage();
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: textColorDarkPrimary,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    addOnDrinksList[itemIndex].name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .apply(color: textColorDarkPrimary, fontWeightDelta: 1),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Price: ${ClubApp.currencyLbl} ${addOnDrinksList[itemIndex].cost}',
                    style: Theme.of(context).textTheme.subtitle1.apply(
                          color: textColorDarkPrimary,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlineButton(
                    onPressed: () {
                      /*setState(() {
                        bool isClaimed =
                            addOnDrinksList[itemIndex].isAddedToCart;
                        if (isClaimed) {
                          totalAmount -= addOnDrinksList[itemIndex].cost;
                          cartAddOn.remove(addOnDrinksList[itemIndex]);
                        } else {
                          totalAmount += addOnDrinksList[itemIndex].cost;
                          cartAddOn.add(addOnDrinksList[itemIndex]);
                        }
                        addOnDrinksList[itemIndex].isAddedToCart = !isClaimed;
                      });*/

                      if (_addOnsBloc.tableCart.isNotEmpty ||
                          _addOnsBloc.eventCart.isNotEmpty) {
                        bool isClaimed =
                            addOnDrinksList[itemIndex].isAddedToCart;

                        if (isClaimed) {
                          for (TableCartModel blocTableModel
                              in _addOnsBloc.tableCart) {
                            if (blocTableModel.addons
                                .contains(addOnDrinksList[itemIndex])) {
                              debugPrint(
                                  'Add on drinks contains in ${blocTableModel.tableName}');
                              blocTableModel.addons
                                  .remove(addOnDrinksList[itemIndex]);
                              totalAmount -= addOnDrinksList[itemIndex].cost;
                            }
                          }
                          setState(() {
                            addOnDrinksList[itemIndex].isAddedToCart =
                                !isClaimed;
                          });
                        } else {
                          if (_addOnsBloc.tableCart.length == 1) {
                            // _addOnsBloc.tableCart[0].addons
                            //     .add(addOnDrinksList[itemIndex]);
                            totalAmount += addOnDrinksList[itemIndex].cost;

                            setState(() {
                              addOnDrinksList[itemIndex].isAddedToCart =
                                  !isClaimed;
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AddOnDialog(
                                    tables: _addOnsBloc.tableCart,
                                    events: _addOnsBloc.eventCart,
                                    selectedTables: const <TableCartModel>[],
                                    selectedEvents: const <EventCartModel>[],
                                    onSelectedTablesChanged:
                                        (List<TableCartModel> tables) {},
                                  );
                                }).then((value) {
                              dynamic tables = value["table"];
                              dynamic events = value["events"];
                              if (tables.length > 0) {
                                String tableUnitIds = "";
                                if ((tables as List<TableCartModel>)
                                    .isNotEmpty) {
                                  for (final TableCartModel tableModel
                                      in tables) {
                                    for (TableCartModel blocTableModel
                                        in _addOnsBloc.tableCart) {
                                      if (tableModel.id == blocTableModel.id) {
                                        // debugPrint(
                                        //     'Add on added in ${blocTableModel.tableName}');
                                        if (tableUnitIds == "") {
                                          tableUnitIds =
                                              blocTableModel.id.toString();
                                        } else {
                                          tableUnitIds = tableUnitIds +
                                              "," +
                                              blocTableModel.id.toString();
                                        }

                                        setState(() {
                                          addonID =
                                              addOnDrinksList[itemIndex].id;
                                        });

                                        // debugPrint(
                                        //     'Add on id ${cartAddOn[0].id}');

                                        // debugPrint(
                                        //     'table unit ids $tableUnitIds');

                                        // blocTableModel.addons.add(
                                        //     addOnBestSellerList[itemIndex]);
                                        // totalAmount +=
                                        //     addOnBestSellerList[itemIndex].cost;
                                        break;
                                      }
                                    }
                                  }
                                  setState(() {
                                    addOnBestSellerList[itemIndex]
                                        .isAddedToCart = !isClaimed;
                                  });
                                } else {
                                  Utility.showSnackBarMessage(_scaffoldKey,
                                      'Please select at least one table');
                                }

                                _addAddonToCartBloc.addAddon(
                                    addonID, tableUnitIds, 1, "table", context);
                              }
                              if (events.length > 0) {
                                String eventUnitIds = "";
                                if ((events as List<EventCartModel>)
                                    .isNotEmpty) {
                                  for (final EventCartModel eventCartModel
                                      in events) {
                                    print(
                                        "eventCartModel ${eventCartModel.eventId}");

                                    for (EventCartModel blocEventModel
                                        in _addOnsBloc.eventCart) {
                                      print(
                                          "blocEventModel ${blocEventModel.eventId}");
                                      if (eventCartModel.eventId ==
                                          blocEventModel.eventId) {
                                        // debugPrint(
                                        //     'Add on added in ${blocTableModel.tableName}');
                                        if (eventUnitIds == "") {
                                          eventUnitIds =
                                              blocEventModel.id.toString();
                                        } else {
                                          eventUnitIds = eventUnitIds +
                                              "," +
                                              blocEventModel.id.toString();
                                        }

                                        setState(() {
                                          addonID =
                                              addOnDrinksList[itemIndex].id;
                                        });

                                        break;
                                      }
                                    }
                                  }
                                  setState(() {
                                    addOnBestSellerList[itemIndex]
                                        .isAddedToCart = !isClaimed;
                                  });
                                } else {
                                  Utility.showSnackBarMessage(_scaffoldKey,
                                      'Please select at least one table');
                                }

                                _addAddonToCartBloc.addAddon(
                                    addonID, eventUnitIds, 1, "event", context);
                              }
                            });
                          }
                        }
                      } else {
                        Utility.showSnackBarMessage(_scaffoldKey,
                            'Please add table before adding add ons');
                      }
                    },
                    borderSide: BorderSide(color: colorPrimaryText
                        /*addOnDrinksList[itemIndex].isAddedToCart
                          ? unClaimButtonColor
                          : claimButtonColor,*/
                        ),
                    child: Text(
                      addOnDrinksList[itemIndex].isAddedToCart
                          ? 'Remove from cart'
                          : 'Add to cart',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .apply(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No Data',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .apply(color: textColorDarkPrimary),
            ),
          );
        }
      },
    );
  }

  @override
  void removeAddOn(int addOnId, int tableId) {
    /*for(TableModel tableModel in _addOnsBloc.tableCarts){
      if(tableModel.tableId == tableId){
        for(AddOnModel addOnModel in tableModel.addOns){
          if(addOnModel.id == addOnId){
            totalAmount -= addOnModel.cost;
            tableModel.addOns.remove(addOnModel);
            setState(() {
            });
            break;
          }
        }
        break;
      }
    }*/
    for (int i = 0; i < _addOnsBloc.addOnList.length; i++) {
      if (_addOnsBloc.addOnList[i].id == addOnId) {
        bool isPresent = false;
        int presentCount = 0;
        for (int j = 0; j < _addOnsBloc.tableCart.length; j++) {
          if (_addOnsBloc.tableCart[j].addons
              .contains(_addOnsBloc.addOnList[i])) {
            debugPrint(
                'Add On is Present in carts ${_addOnsBloc.addOnList[i].isAddedToCart}');
            presentCount++;
          }
        }
        if (presentCount > 1) {
          isPresent = true;
        }
        setState(() {
          _addOnsBloc.addOnList[i].isAddedToCart = isPresent;
          totalAmount -= _addOnsBloc.addOnList[i].cost;
          debugPrint(
              'Add On is Present ${_addOnsBloc.addOnList[i].isAddedToCart}');
          _addOnsBloc.addOnListController.add(AddOnState.ListRetrieved);
        });
        break;
      }
    }
  }
}
