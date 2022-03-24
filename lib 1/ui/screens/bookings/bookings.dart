import 'package:club_app/constants/navigator.dart';
import 'package:club_app/constants/strings.dart';
import 'package:club_app/logic/bloc/bookings_bloc.dart';
import 'package:club_app/logic/models/booking_event.dart';
import 'package:club_app/logic/models/booking_guest_list.dart';
import 'package:club_app/logic/models/booking_model.dart';
import 'package:club_app/logic/models/booking_table.dart';
import 'package:club_app/logic/models/booking_vouchers.dart';
import 'package:club_app/ui/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:club_app/constants/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:expandable/expandable.dart';

class BookingScreen extends StatefulWidget {
  @override
  _bookingScreenState createState() => _bookingScreenState();
}

class _bookingScreenState extends State<BookingScreen> {
  BookingBloc _bookingBloc;
  List<Booking> allBookingList;
  List<BookingTable> tableBookingList;
  List<BookingGuestList> guestBookingList;
  List<BookingVouchers> voucherBookingList;
  List<BookingEvent> ticketBookingList;
  ScrollController _scrollController = ScrollController();
  bool allBookingsFetched = false;
  var globalIndex = 0;
  @override
  void initState() {
    super.initState();
    _bookingBloc = BookingBloc();
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: AppBar(
          title: Text('Bookings'),
          leading: IconButton(
            onPressed: () {
              AppNavigator.gotoLanding(context);
            },
            icon: Icon(Icons.arrow_back),
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
              isScrollable: true,
              dragStartBehavior: DragStartBehavior.start,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: Colors.white,
              tabs: [
                // Tab(
                //   child: Text(ClubApp.tickets),
                // ),
                Tab(
                  child: Text(ClubApp.tablesEvents),
                ),
                // Tab(
                //   child: Text(ClubApp.guest_list),
                // ),
              ],
            ),
            preferredSize: Size.fromHeight(56.0),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<bool>(
            stream: _bookingBloc.loaderController.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              debugPrint('In loader controller stream builder');
              bool isLoading = false;
              if (snapshot.hasData) {
                isLoading = snapshot.data;
              }

              return ModalProgressHUD(
                inAsyncCall: isLoading,
                //color: dividerColor,
                progressIndicator: CircularProgressIndicator(
                  backgroundColor: dividerColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          // getTicketsTabView(context),
                          getTablesTabView(context),
                          //getGuestListTabView(context),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  getTablesTabView(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _bookingBloc
          .loaderController.stream, //_tableCartBloc.isLoadingController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        bool isLoading = false;
        if (snapshot.hasData) {
          isLoading = snapshot.data;
        }

        return ModalProgressHUD(
            inAsyncCall: isLoading,
            color: Colors.black,
            progressIndicator: CircularProgressIndicator(),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [bookingData()])));
      },
    );
  }

  Widget bookingData() {
    return ListView.builder(
      shrinkWrap: true,
      //padding: const EdgeInsets.only(top: 8.0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: _bookingBloc.bookingModel != null
          ? _bookingBloc.bookingModel.result.length
          : 0,
      itemBuilder: generateEventExpandableCart,
    );
  }

  Widget generateEventExpandableCart(BuildContext context, int index) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: cardBackgroundColor,
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    iconSize: 28,
                    iconColor: Colors.white,
                    tapBodyToCollapse: true,
                  ),
                  header: generateEventChartsCard(context, index),
                  collapsed: Container(),
                  expanded: bookingDetails(index),
                  builder: (_, Widget collapsed, Widget expanded) {
                    return Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateEventChartsCard(BuildContext context, int index) {
    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Booking ${index + 1}",
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .apply(color: textColorDarkPrimary),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingDetails(index) {
    globalIndex = index;
    return ListView.builder(
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: _bookingBloc.bookingModel != null
            ? _bookingBloc.bookingModel.result[index].length
            : 0,
        itemBuilder: detailedExpandableCart);
  }

  Widget detailedExpandableCart(BuildContext context, int index) {
    return Container(
      child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 2, color: Colors.black),
              SizedBox(
                height: 20,
              ),
              Text(
                _bookingBloc.bookingModel.result[globalIndex][index].table ==
                        null
                    ? _bookingBloc.bookingModel.result[globalIndex][index]
                                .event ==
                            null
                        ? ""
                        : "Booking UID : " +
                            _bookingBloc.bookingModel.result[globalIndex][index]
                                .event.bookingUid
                    : "Name : " +
                        _bookingBloc.bookingModel.result[globalIndex][index]
                            .table.firstName +
                        " " +
                        _bookingBloc.bookingModel.result[globalIndex][index]
                            .table.lastName,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: textColorDarkPrimary),
              ),
              Text(
                _bookingBloc.bookingModel.result[globalIndex][index].table ==
                        null
                    ? _bookingBloc.bookingModel.result[globalIndex][index]
                                .event ==
                            null
                        ? ""
                        : "Date : " +
                            _bookingBloc.bookingModel.result[globalIndex][index]
                                .event.date
                                .toString()
                    : "Category : " +
                        _bookingBloc.bookingModel.result[globalIndex][index]
                            .table.category,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: textColorDarkPrimary),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                _bookingBloc.bookingModel.result[globalIndex][index].table ==
                        null
                    ? _bookingBloc.bookingModel.result[globalIndex][index]
                                .event ==
                            null
                        ? ""
                        : "Rate : " +
                            _bookingBloc.bookingModel.result[globalIndex][index]
                                .event.rate
                    : "Date : " +
                        (_bookingBloc.bookingModel.result[globalIndex][index]
                                .table.date)
                            .toString(),
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: textColorDarkPrimary),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                _bookingBloc.bookingModel.result[globalIndex][index].table ==
                        null
                    ? _bookingBloc.bookingModel.result[globalIndex][index]
                                .event ==
                            null
                        ? ""
                        : "Quantity : " +
                            _bookingBloc.bookingModel.result[globalIndex][index]
                                .event.quantity
                    : "Payment Id : " +
                        _bookingBloc.bookingModel.result[globalIndex][index]
                            .table.paymentId,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: textColorDarkPrimary),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                _bookingBloc.bookingModel.result[globalIndex][index].table ==
                        null
                    ? _bookingBloc.bookingModel.result[globalIndex][index]
                                .event ==
                            null
                        ? ""
                        : "Transaction Id : " +
                            _bookingBloc.bookingModel.result[globalIndex][index]
                                .event.transactionId
                    : "Email : " +
                        _bookingBloc.bookingModel.result[globalIndex][index]
                            .table.email,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: textColorDarkPrimary),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Future<void> fetchBookings({bool showInternetAlert = true}) async {
    final bool isInternetAvailable = await isNetworkAvailable();
    if (isInternetAvailable) {
      _bookingBloc.fetchBookings();
    } else {
      if (showInternetAlert) {
        ackAlert(context, ClubApp.no_internet_message);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bookingBloc.dispose();
    super.dispose();
  }

  Widget generateExpandableCart(BuildContext context, int index) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: cardBackgroundColor,
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  theme: ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      iconSize: 28,
                      iconColor: Colors.white,
                      tapBodyToCollapse: true,
                      /*hasIcon: (tableBookingList[index].tableAddOnList != null &&
                        tableBookingList[index].tableAddOnList.isNotEmpty)*/
                      iconPlacement: ExpandablePanelIconPlacement.left),
                  header: generateChartsCard(context, index),
                  collapsed: Container(),
                  expanded: (tableBookingList[index].tableAddOnList != null &&
                          tableBookingList[index].tableAddOnList.isNotEmpty)
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          color: backgroundColor,
                          child: generateAddOnCartList(
                              tableBookingList[index].tableAddOnList,
                              context,
                              tableBookingList[index].id),
                        )
                      : const SizedBox(),
                  builder: (_, Widget collapsed, Widget expanded) {
                    return Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateChartsCard(BuildContext context, int index) {
    BookingTable bookingTable = tableBookingList[index];
    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bookingTable.category + ' - ' + bookingTable.unit,
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle1.apply(
                    color: textColorDarkPrimary,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              'Rate: ${bookingTable.rate} ${bookingTable.currency}',
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: textColorDarkPrimary),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              'Booked for: ' +
                  getBookingDate(DateTime.parse(bookingTable.date)),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: textColorDarkPrimary),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booked on: ' +
                      getBookingDate(DateTime.parse(bookingTable.createdAt)),
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(color: textColorDarkPrimary),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    AppNavigator.gotoQrCodeScreen(context,
                        bookingUid: bookingTable.bookingUid,
                        appBarTitle: 'Table booking details',
                        bookingTitle:
                            bookingTable.category + ' - ' + bookingTable.unit);
                  },
                  icon: Image.asset(
                    'assets/images/qrcode.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget generateAddOnCartList(
      List<TableAddOn> addOns, BuildContext context, int tableId) {
    return ListView.builder(
        shrinkWrap: true,
        //padding: const EdgeInsets.only(top: 8.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: addOns.length,
        itemBuilder: (BuildContext context, int index) {
          return generateAddOnCard(addOns, index, tableId);
        });
  }

  Widget generateAddOnCard(List<TableAddOn> addOns, int index, int tableId) {
    TableAddOn tableAddOn = addOns[index];
    return Card(
      color: cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 1.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tableAddOn.name,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: textColorDarkSecondary),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              'RATE: ${tableAddOn.rate} ${tableAddOn.currency}',
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(color: textColorDarkPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
