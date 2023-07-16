// ignore_for_file: unused_import, curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localbiz1/models/auto_complete_result.dart';
import 'package:localbiz1/providers/search_places.dart';
import 'package:localbiz1/screens/signin.dart';
import 'package:localbiz1/services/map_services.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/authentication.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  bool isDrawerOpen = false;
  String userEmail = ''; // Variable to store the user's email

  // Add a GlobalKey to access the Scaffold's state.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Debounce to throttle async calls during search
  Timer? _debounce;

  //Toggling UI as we need;
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

  //Markers set
  Set<Marker> _markers = <Marker>{};
  Set<Marker> _markersDupe = <Marker>{};
  Set<Polyline> _polylines = <Polyline>{};
  //Circle
  Set<Circle> _circles = Set<Circle>();
  int markerIdCounter = 1;
  int polylineIdCounter = 1;
  var radiusValue = 3000.0;
  var tappedPoint;
  List allFavoritePlaces = [];

  String tokenKey = '';

  //Page controller for the nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;
  String placeImg = '';
  var photoGalleryIndex = 0;
  bool showBlankCard = false;
  bool isReviews = true;
  bool isPhotos = false;

  final key = 'AIzaSyBuD_taQ5FNMp3NjLi3S6V2pHRwL0LmD28';

  var selectedPlaceDetails;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  Future<void> getUserEmail() async {
    // Retrieve the user's email from Firebase
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? ''; // Update the userEmail variable
      });
    }
  }

  //Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

//Initial map position on load
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.309211, 36.812743),
    zoom: 14.4746,
  );

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList()));
  }

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('raj'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;

    final Uint8List markerIcon;

    String iconName;
    int iconSize = 75;

    if (types.contains('accountancy'))
      iconName = 'accountancy.png';
    else if (types.contains('arts') ||
        types.contains('crafts') ||
        types.contains('gallery'))
      iconName = 'arts-crafts.png';
    else if (types.contains('astrology'))
      iconName = 'astrology.png';
    else if (types.contains('automotive'))
      iconName = 'automotive.png';
    else if (types.contains('bars') ||
        types.contains('clubs') ||
        types.contains('entertainment') ||
        types.contains('pub'))
      iconName = 'bars.png';
    else if (types.contains('birds'))
      iconName = 'birds.png';
    else if (types.contains('books'))
      iconName = 'books-media.png';
    else if (types.contains('brunch'))
      iconName = 'breakfast-n-brunch.png';
    else if (types.contains('business'))
      iconName = 'business.png';
    else if (types.contains('cake') || types.contains('bakery'))
      iconName = 'cake-shop.png';
    else if (types.contains('clothes'))
      iconName = 'clothings.png';
    else if (types.contains('breakfast'))
      iconName = 'coffee-n-tea.png';
    else if (types.contains('commercial-places'))
      iconName = 'commercial-places.png';
    else if (types.contains('community'))
      iconName = 'community.png';
    else if (types.contains('computer') ||
        types.contains('cyber') ||
        types.contains('internet') ||
        types.contains('printing'))
      iconName = 'computers.png';
    else if (types.contains('concerts'))
      iconName = 'concerts.png';
    else if (types.contains('cookbooks'))
      iconName = 'cookbooks.png';
    else if (types.contains('default'))
      iconName = 'default.png';
    else if (types.contains('dental') || types.contains('dentist'))
      iconName = 'dental.png';
    else if (types.contains('doctor') || types.contains('clinic'))
      iconName = 'doctors.png';
    else if (types.contains('education') ||
        types.contains('school') ||
        types.contains('university') ||
        types.contains('college'))
      iconName = 'education.png';
    else if (types.contains('electronics'))
      iconName = 'electronics.png';
    else if (types.contains('employment'))
      iconName = 'employment.png';
    else if (types.contains('engineering'))
      iconName = 'engineering.png';
    else if (types.contains('event'))
      iconName = 'event.png';
    else if (types.contains('exhibitions'))
      iconName = 'exhibitions.png';
    else if (types.contains('fashion') || types.contains('shoe'))
      iconName = 'fashion.png';
    else if (types.contains('festivals'))
      iconName = 'festivals.png';
    else if (types.contains('financial-services') ||
        types.contains('finance') ||
        types.contains('bank') ||
        types.contains('ATM'))
      iconName = 'financial-services.png';
    else if (types.contains('food') ||
        types.contains('restaurant') ||
        types.contains('fast-food') ||
        types.contains('grill'))
      iconName = 'food.png';
    else if (types.contains('furniture-stores'))
      iconName = 'furniture-stores.png';
    else if (types.contains('games'))
      iconName = 'games.png';
    else if (types.contains('gift') || types.contains('flowers'))
      iconName = 'gifts-flowers.png';
    else if (types.contains('government'))
      iconName = 'government.png';
    else if (types.contains('halloween'))
      iconName = 'halloween.png';
    else if (types.contains('health-medical') || types.contains('hospital'))
      iconName = 'health-medical.png';
    else if (types.contains('home-services') || types.contains('plumbing'))
      iconName = 'home-services.png';
    else if (types.contains('hotel'))
      iconName = 'hotels.png';
    else if (types.contains('industries'))
      iconName = 'industries.png';
    else if (types.contains('jewelry'))
      iconName = 'jewelry.png';
    else if (types.contains('jobs'))
      iconName = 'jobs.png';
    else if (types.contains('karaoke'))
      iconName = 'karaoke.png';
    else if (types.contains('law') || types.contains('court'))
      iconName = 'law.png';
    else if (types.contains('library'))
      iconName = 'libraries.png';
    else if (types.contains('local-services') || types.contains('garage'))
      iconName = 'local-services.png';
    else if (types.contains('lounge') || types.contains('lodging'))
      iconName = 'lounges.png';
    else if (types.contains('magazine') || types.contains('newspaper'))
      iconName = 'magazines.png';
    else if (types.contains('manufacturing'))
      iconName = 'manufacturing.png';
    else if (types.contains('marker-new1_12'))
      iconName = 'marker-new1_12.png';
    else if (types.contains('mass-media'))
      iconName = 'mass-media.png';
    else if (types.contains('massage-therapy'))
      iconName = 'massage-therapy.png';
    else if (types.contains('matrimonial'))
      iconName = 'matrimonial.png';
    else if (types.contains('medical') || types.contains('chemist'))
      iconName = 'medical.png';
    else if (types.contains('meetups'))
      iconName = 'meetups.png';
    else if (types.contains('miscellaneous-for-sale'))
      iconName = 'miscellaneous-for-sale.png';
    else if (types.contains('mobile-phones'))
      iconName = 'mobile-phones.png';
    else if (types.contains('movies') || types.contains('cinema'))
      iconName = 'movies.png';
    else if (types.contains('museum'))
      iconName = 'museums.png';
    else if (types.contains('musical-instruments'))
      iconName = 'musical-instruments.png';
    else if (types.contains('musical'))
      iconName = 'musical.png';
    else if (types.contains('nightlife'))
      iconName = 'nightlife.png';
    else if (types.contains('parks') ||
        types.contains('garden') ||
        types.contains('lawn'))
      iconName = 'parks.png';
    else if (types.contains('parties'))
      iconName = 'parties.png';
    else if (types.contains('pets') || types.contains('veterinary'))
      iconName = 'pets.png';
    else if (types.contains('photography'))
      iconName = 'photography.png';
    else if (types.contains('pizza'))
      iconName = 'pizza.png';
    else if (types.contains('play-schools'))
      iconName = 'play-schools.png';
    else if (types.contains('playgrounds'))
      iconName = 'playgrounds.png';
    else if (types.contains('pool-halls'))
      iconName = 'pool-halls.png';
    else if (types.contains('professional'))
      iconName = 'professional.png';
    else if (types.contains('real-estate'))
      iconName = 'real-estate.png';
    else if (types.contains('religious-organizations'))
      iconName = 'religious-organizations.png';
    else if (types.contains('residential-places') ||
        types.contains('estate') ||
        types.contains('apartments'))
      iconName = 'residential-places.png';
    else if (types.contains('retail-stores') ||
        types.contains('supermarkert') ||
        types.contains('market') ||
        types.contains('store'))
      iconName = 'retail-stores.png';
    else if (types.contains('saloon') ||
        types.contains('barber')) // Include 'barber'
      iconName = 'saloon.png';
    else if (types.contains('science'))
      iconName = 'science.png';
    else if (types.contains('shopping') || types.contains('grocery'))
      iconName = 'shopping.png';
    else if (types.contains('sporting-goods'))
      iconName = 'sporting-goods.png';
    else if (types.contains('sports'))
      iconName = 'sports.png';
    else if (types.contains('swimming-pool'))
      iconName = 'swimming-pools.png';
    else if (types.contains('telemarketing'))
      iconName = 'telemarketing.png';
    else if (types.contains('tickets'))
      iconName = 'tickets.png';
    else if (types.contains('tiffin-services'))
      iconName = 'tiffin-services.png';
    else if (types.contains('tires-accessories') ||
        types.contains('tires') ||
        types.contains('tyres'))
      iconName = 'tires-accessories.png';
    else if (types.contains('tools-hardware') || types.contains('hardware'))
      iconName = 'tools-hardware.png';
    else if (types.contains('tours'))
      iconName = 'tours.png';
    else if (types.contains('toys-store'))
      iconName = 'toys-store.png';
    else if (types.contains('transport'))
      iconName = 'transport.png';
    else if (types.contains('travel'))
      iconName = 'travel.png';
    else if (types.contains('tutors'))
      iconName = 'tutors.png';
    else if (types.contains('vacant-land'))
      iconName = 'vacant-land.png';
    else
      iconName = 'default.png';

    markerIcon = await getBytesFromAsset('assets/mapicons/$iconName', iconSize);

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    super.initState();
    getUserEmail(); // Call getUserEmail() method to retrieve the user's email
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      goToTappedPlace();
      fetchImage();
    }
  }

  //Fetch image to place inside the tile in the pageView
  void fetchImage() async {
    if (_pageController.page !=
        null) if (allFavoritePlaces[_pageController.page!.toInt()]
            ['photos'] !=
        null) {
      setState(() {
        placeImg = allFavoritePlaces[_pageController.page!.toInt()]['photos'][0]
            ['photo_reference'];
      });
    } else {
      placeImg = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                /*AppBar(
                  title: const Text('User: Local Business Search'),
                ),*/
                // Local Businesses
                SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal, // <-- Changed this line
                    markers: _markers,
                    polylines: _polylines,
                    circles: _circles,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (point) {
                      tappedPoint = point;
                      _setCircle(point);
                    },
                  ),
                ),
                searchToggle
                    ? Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                        child: Column(children: [
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          searchToggle = false;

                                          searchController.text = '';
                                          _markers = {};
                                          if (searchFlag.searchToggle) {
                                            searchFlag.toggleSearch();
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.close))),
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) {
                                  _debounce?.cancel();
                                }
                                _debounce =
                                    Timer(const Duration(milliseconds: 700),
                                        () async {
                                  if (value.length > 2) {
                                    if (!searchFlag.searchToggle) {
                                      searchFlag.toggleSearch();
                                      _markers = {};
                                    }

                                    List<AutoCompleteResult> searchResults =
                                        await MapServices().searchPlaces(value);

                                    allSearchResults.setResults(searchResults);
                                  } else {
                                    List<AutoCompleteResult> emptyList = [];
                                    allSearchResults.setResults(emptyList);
                                  }
                                });
                              },
                            ),
                          )
                        ]),
                      )
                    : Container(),
                searchFlag.searchToggle
                    ? allSearchResults.allReturnedResults.isNotEmpty
                        ? Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: ListView(
                                children: [
                                  ...allSearchResults.allReturnedResults
                                      .map((e) => buildListItem(e, searchFlag))
                                ],
                              ),
                            ))
                        : Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: Container(
                              height: 200.0,
                              width: screenWidth - 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Column(children: [
                                  const Text('No results to show',
                                      style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          fontWeight: FontWeight.w400)),
                                  const SizedBox(height: 5.0),
                                  SizedBox(
                                    width: 125.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        searchFlag.toggleSearch();
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Close this',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ))
                    : Container(),
                getDirections
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5),
                        child: Column(children: [
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _originController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  border: InputBorder.none,
                                  hintText: 'Origin'),
                            ),
                          ),
                          SizedBox(height: 3.0),
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _destinationController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  border: InputBorder.none,
                                  hintText: 'Destination',
                                  suffixIcon: Container(
                                      width: 96.0,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                var directions =
                                                    await MapServices()
                                                        .getDirections(
                                                            _originController
                                                                .text,
                                                            _destinationController
                                                                .text);
                                                _markers = {};
                                                _polylines = {};
                                                gotoPlace(
                                                    directions['start_location']
                                                        ['lat'],
                                                    directions['start_location']
                                                        ['lng'],
                                                    directions['end_location']
                                                        ['lat'],
                                                    directions['end_location']
                                                        ['lng'],
                                                    directions['bounds_ne'],
                                                    directions['bounds_sw']);
                                                _setPolyline(directions[
                                                    'polyline_decoded']);
                                              },
                                              icon: Icon(Icons.search)),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  getDirections = false;
                                                  _originController.text = '';
                                                  _destinationController.text =
                                                      '';
                                                  _markers = {};
                                                  _polylines = {};
                                                });
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ))),
                            ),
                          )
                        ]),
                      )
                    : Container(),
                radiusSlider
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                        child: Container(
                          height: 50.0,
                          color: Colors.black.withOpacity(0.2),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Slider(
                                      max: 7000.0,
                                      min: 1000.0,
                                      value: radiusValue,
                                      onChanged: (newVal) {
                                        radiusValue = newVal;
                                        pressedNear = false;
                                        _setCircle(tappedPoint);
                                      })),
                              !pressedNear
                                  ? IconButton(
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(Duration(seconds: 2),
                                            () async {
                                          var placesResult = await MapServices()
                                              .getPlaceDetails(tappedPoint,
                                                  radiusValue.toInt());

                                          List<dynamic> placesWithin =
                                              placesResult['results'] as List;

                                          allFavoritePlaces = placesWithin;

                                          tokenKey =
                                              placesResult['next_page_token'] ??
                                                  'none';
                                          _markers = {};
                                          placesWithin.forEach((element) {
                                            _setNearMarker(
                                              LatLng(
                                                  element['geometry']
                                                      ['location']['lat'],
                                                  element['geometry']
                                                      ['location']['lng']),
                                              element['name'],
                                              element['types'],
                                              element['business_status'] ??
                                                  'not available',
                                            );
                                          });
                                          _markersDupe = _markers;
                                          pressedNear = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.near_me,
                                        color: Colors.blue,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        if (_debounce?.isActive ?? false)
                                          _debounce?.cancel();
                                        _debounce = Timer(Duration(seconds: 2),
                                            () async {
                                          if (tokenKey != 'none') {
                                            var placesResult =
                                                await MapServices()
                                                    .getMorePlaceDetails(
                                                        tokenKey);

                                            List<dynamic> placesWithin =
                                                placesResult['results'] as List;

                                            allFavoritePlaces
                                                .addAll(placesWithin);

                                            tokenKey = placesResult[
                                                    'next_page_token'] ??
                                                'none';

                                            placesWithin.forEach((element) {
                                              _setNearMarker(
                                                LatLng(
                                                    element['geometry']
                                                        ['location']['lat'],
                                                    element['geometry']
                                                        ['location']['lng']),
                                                element['name'],
                                                element['types'],
                                                element['business_status'] ??
                                                    'not available',
                                              );
                                            });
                                          } else {
                                            print('Thats all folks!!');
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.more_time,
                                          color: Colors.blue)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      radiusSlider = false;
                                      pressedNear = false;
                                      cardTapped = false;
                                      radiusValue = 3000.0;
                                      _circles = {};
                                      _markers = {};
                                      allFavoritePlaces = [];
                                    });
                                  },
                                  icon: Icon(Icons.close, color: Colors.red))
                            ],
                          ),
                        ),
                      )
                    : Container(),
                pressedNear
                    ? Positioned(
                        bottom: 20.0,
                        child: Container(
                          height: 200.0,
                          width: MediaQuery.of(context).size.width,
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: allFavoritePlaces.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _nearbyPlacesList(index);
                              }),
                        ))
                    : Container(),
                cardTapped
                    ? Positioned(
                        top: 100.0,
                        left: 15.0,
                        child: FlipCard(
                          front: Container(
                            height: 250.0,
                            width: 175.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Container(
                                  height: 150.0,
                                  width: 175.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(7.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Address: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                          width: 105.0,
                                          child: Text(
                                            tappedPlaceDetail[
                                                    'formatted_address'] ??
                                                'none given',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                                  width: 175.0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contact: ',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                          width: 105.0,
                                          child: Text(
                                            tappedPlaceDetail[
                                                    'formatted_phone_number'] ??
                                                'none given',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400),
                                          ))
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          back: Container(
                            height: 300.0,
                            width: 225.0,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isReviews = true;
                                            isPhotos = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeIn,
                                          padding: EdgeInsets.fromLTRB(
                                              7.0, 4.0, 7.0, 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              color: isReviews
                                                  ? Colors.green.shade300
                                                  : Colors.white),
                                          child: Text(
                                            'Reviews',
                                            style: TextStyle(
                                                color: isReviews
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isReviews = false;
                                            isPhotos = true;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 700),
                                          curve: Curves.easeIn,
                                          padding: EdgeInsets.fromLTRB(
                                              7.0, 4.0, 7.0, 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              color: isPhotos
                                                  ? Colors.green.shade300
                                                  : Colors.white),
                                          child: Text(
                                            'Photos',
                                            style: TextStyle(
                                                color: isPhotos
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 250.0,
                                  child: isReviews
                                      ? ListView(
                                          children: [
                                            if (isReviews &&
                                                tappedPlaceDetail['reviews'] !=
                                                    null)
                                              ...tappedPlaceDetail['reviews']!
                                                  .map((e) {
                                                return _buildReviewItem(e);
                                              })
                                          ],
                                        )
                                      : _buildPhotoGallery(
                                          tappedPlaceDetail['photos'] ?? []),
                                )
                              ],
                            ),
                          ),
                        ))
                    : Container()
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue.shade50,
          fabOpenColor: Colors.red.shade100,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: Colors.blue.shade50,
          fabSize: 60.0,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = true;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = false;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = true;
                  });
                },
                icon: Icon(Icons.navigation)),
            // Add the additional floating action button for the drawer.
            IconButton(
              onPressed: () {
                // Show the drawer when the button is pressed.
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'User Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userEmail, // Display the user's email retrieved from Firebase
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Update Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: '',
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Saved Businesses'),
              onTap: () {
                // TODO: Implement the navigation to the saved businesses screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Payments'),
              onTap: () {
                // TODO: Implement the navigation to the saved businesses screen
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              onTap: () {
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  Authentication.signout(context: context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Signin(),
                  ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildReviewItem(review) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Row(
            children: [
              Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(review['profile_photo_url']),
                        fit: BoxFit.cover)),
              ),
              SizedBox(width: 4.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 160.0,
                  child: Text(
                    review['author_name'],
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 3.0),
                RatingStars(
                  value: review['rating'] * 1.0,
                  starCount: 5,
                  starSize: 7,
                  valueLabelColor: const Color(0xff9b9b9b),
                  valueLabelTextStyle: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 9.0),
                  valueLabelRadius: 7,
                  maxValue: 5,
                  starSpacing: 2,
                  maxValueVisibility: false,
                  valueLabelVisibility: true,
                  animationDuration: Duration(milliseconds: 1000),
                  valueLabelPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                  valueLabelMargin: const EdgeInsets.only(right: 4),
                  starOffColor: const Color(0xffe7e8ea),
                  starColor: Colors.yellow,
                )
              ])
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              review['text'],
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }

  _buildPhotoGallery(photoElement) {
    if (photoElement == null || photoElement.length == 0) {
      showBlankCard = true;
      return Container(
        child: Center(
          child: Text(
            'No Photos',
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 12.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      var placeImg = photoElement[photoGalleryIndex]['photo_reference'];
      var maxWidth = photoElement[photoGalleryIndex]['width'];
      var maxHeight = photoElement[photoGalleryIndex]['height'];
      var tempDisplayIndex = photoGalleryIndex + 1;

      return Column(
        children: [
          SizedBox(height: 10.0),
          Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&maxheight=$maxHeight&photo_reference=$placeImg&key=$key'),
                      fit: BoxFit.cover))),
          SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != 0)
                    photoGalleryIndex = photoGalleryIndex - 1;
                  else
                    photoGalleryIndex = 0;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != 0
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Prev',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Text(
              '$tempDisplayIndex/' + photoElement.length.toString(),
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (photoGalleryIndex != photoElement.length - 1)
                    photoGalleryIndex = photoGalleryIndex + 1;
                  else
                    photoGalleryIndex = photoElement.length - 1;
                });
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9.0),
                    color: photoGalleryIndex != photoElement.length - 1
                        ? Colors.green.shade500
                        : Colors.grey.shade500),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ])
        ],
      );
    }
  }

  gotoPlace(double lat, double lng, double endLat, double endLng,
      Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng'])),
        25));

    _setMarker(LatLng(lat, lng));
    _setMarker(LatLng(endLat, endLng));
  }

  Future<void> moveCameraSlightly() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lat'] +
                0.0125,
            allFavoritePlaces[_pageController.page!.toInt()]['geometry']
                    ['location']['lng'] +
                0.005),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  _nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allFavoritePlaces[index]['place_id']);
            setState(() {});
          }
          moveCameraSlightly();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      _pageController.position.haveDimensions
                          ? _pageController.page!.toInt() == index
                              ? Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(placeImg != ''
                                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$placeImg&key=$key'
                                              : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 90.0,
                                  width: 20.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        topLeft: Radius.circular(10.0),
                                      ),
                                      color: Colors.blue),
                                )
                          : Container(),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 170.0,
                            child: Text(allFavoritePlaces[index]['name'],
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold)),
                          ),
                          RatingStars(
                            value: allFavoritePlaces[index]['rating']
                                        .runtimeType ==
                                    int
                                ? allFavoritePlaces[index]['rating'] * 1.0
                                : allFavoritePlaces[index]['rating'] ?? 0.0,
                            starCount: 5,
                            starSize: 10,
                            valueLabelColor: const Color(0xff9b9b9b),
                            valueLabelTextStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            valueLabelRadius: 10,
                            maxValue: 5,
                            starSpacing: 2,
                            maxValueVisibility: false,
                            valueLabelVisibility: true,
                            animationDuration: Duration(milliseconds: 1000),
                            valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
                          ),
                          Container(
                            width: 170.0,
                            child: Text(
                              allFavoritePlaces[index]['business_status'] ??
                                  'none',
                              style: TextStyle(
                                  color: allFavoritePlaces[index]
                                              ['business_status'] ==
                                          'OPERATIONAL'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

    _setNearMarker(
        LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        selectedPlace['name'] ?? 'no name',
        selectedPlace['types'],
        selectedPlace['business_status'] ?? 'none');

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(selectedPlace['geometry']['location']['lat'],
            selectedPlace['geometry']['location']['lng']),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _phonenoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _phonenoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Retrieve user details from Firestore using the provided userId
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final user = snapshot.data() as Map<String, dynamic>;
        final String fname = user['fname'];
        final String lname = user['lname'];
        final String phoneno = user['phoneno'];
        final String email = user['email'];

        setState(() {
          _fnameController.text = fname;
          _lnameController.text = lname;
          _phonenoController.text = phoneno;
          _emailController.text = email;
        });
      }
    }
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      final String fname = _fnameController.text;
      final String lname = _lnameController.text;
      final String phoneno = _phonenoController.text;
      final String email = _emailController.text;

      // TODO: Implement user update logic using Firestore
      updateUserInFirestore(fname, lname, phoneno, email);

      // Navigate back to the user screen
      Navigator.pop(context);
    }
  }

  void updateUserInFirestore(
      String fname, String lname, String phoneno, String email) {
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'fname': fname,
      'lname': lname,
      'phoneno': phoneno,
      'email': email,
    });
    print('User updated: email=$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _fnameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _lnameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _phonenoController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50, // Replace with your desired height
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, save the profile data
                        // Implement the logic to update the profile data in your Firebase database
                        // You can access the values using _firstNameController.text, _lastNameController.text, _phoneNumberController.text
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully'),
                          ),
                        );
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
