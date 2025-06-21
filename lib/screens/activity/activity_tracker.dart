import 'package:fitnessapp/local_notification/awesome_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitnessapp/screens/activity/TodayTarget.dart';
import 'package:fitnessapp/screens/activity/latest_acitivity.dart';
import 'package:fitnessapp/screens/activity/color.dart';
import 'package:pedometer/pedometer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ActivityTracker extends StatefulWidget {
  const ActivityTracker({super.key});

  @override
  State<ActivityTracker> createState() => _ActivityTrackerState();
}

class _ActivityTrackerState extends State<ActivityTracker> {
  int touchedIndex = -1;
  late Map<String, dynamic> wObj;
  late Map<String, dynamic> vObj;

  List<Map<String, dynamic>> latestArr = [
    {
      "image": "assets/img/drink.webp",
      "title": "Drinking 300ml Water",
      "time": "About 1 minutes ago",
    },
    {
      "image": "assets/img/pic_5.png",
      "title": "Eat Snack (Fitbar)",
      "time": "3 hours ago"
    },
  ];
  List<Map<String, dynamic>> workouts = [
    {
      'title': 'Cardio',
      'exercises': '10 Exercises',
      'time': '50 Minutes',
      'image': 'assets/img/run.png',
      'tagi': '0'
    },
    {
      'title': 'Yoga',
      'exercises': '6 Exercises',
      'time': '36 Minutes',
      'image': 'assets/img/yoga.webp',
      'tagi': '1'
    },
    {
      'title': 'Meditation',
      'exercises': '8 Exercises',
      'time': '45 Minutes',
      'image': 'assets/img/meditation.png',
      'tagi': '2'
    },
  ];

  ///for pedometer concept/////////////////////////////////////////////////////
  /////stream handles asynchronous data its not a data type ok
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  String _calories = '0';
  //adjust thisif you know thw users weight
  //0.04 kcal = avergae per step for 65-70kg adult
  final double _calPerStep = 0.04;
  String? selectedValue;
  bool showMonthlyContainer = false;
  String selectedOption = 'Weekly';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _startListening();
  }

  void _requestPermission() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
  }

  void _startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
  }

  void _onStepCount(StepCount event) {
    final int stepCount = event.steps;
    final double calBurned = stepCount * _calPerStep;

    setState(() {
      _steps = stepCount.toString();
      _calories = calBurned.toStringAsFixed(2); // keep 2 decimals
    });
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
    setState(() {
      _steps = 'Not available';
    });
  }

  ///to here
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/img/black_btn.png'))),
        title: Text(
          "Activity ",
          style: TextStyle(
              color: TColor.black, fontSize: 26, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
              onTap: () {},
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/img/more_btn.png')))
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
          ),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////TODAY TARGET//
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today Target",
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.primaryG,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                height: 30,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                textColor: TColor.primaryColor1,
                                minWidth: double.maxFinite,
                                elevation: 0,
                                color: Colors.transparent,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //////TODAY TARGET SECTION/////
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AwesomeNotification notification =
                                  AwesomeNotification();
                              notification.sendNotification();
                            },
                            child: const TodayTargetCell(
                              icon: "assets/img/water.png",
                              value: "8L",
                              title: "Water Intake",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TodayTargetCell(
                            icon: "assets/img/walking.png",
                            value: _steps,
                            title: "Foot Steps",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ////////////steps walked///////////
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight,
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        child: CircularPercentIndicator(
                          lineWidth: 15,
                          progressColor: Colors.green,
                          percent: 0.7,
                          radius: 50,
                          center: Text(
                            _steps,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Text('Calories Burned',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_calories ',
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Icon(
                        //       Icons.timer,
                        //       color: Colors.blue,
                        //     ),
                        //     SizedBox(width: 4),
                        //     Text('12,000'),
                        //   ],
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  textAlign: TextAlign.center,
                  "Activity  Progress",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ]),

              ///////drop down option
              Column(
                children: [
                  // SizedBox(height: 20),
                  // Dropdown menu
                  DropdownButton<String>(
                    value: selectedOption,
                    items: ['Weekly', 'Progress Monthly', 'Yearly']
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Container based on selection
                  Center(
                    child: getSelectedContainer(),
                  ),
                ],
              ),

              SizedBox(
                height: media.width * 0.05,
              ),

              SizedBox(
                height: media.width * 0.05,
              ),
              ////////////LATEST WORKOUT///////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Latest Workout",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See More",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              ///////lists/
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: latestArr.length,
                  itemBuilder: (context, index) {
                    wObj = latestArr[index];
                    return LatestActivity(wObj: wObj);
                  }),
              SizedBox(
                height: media.width * 0.1,
              ),
              /////////////DISCOVER SECTION///////
              Text(
                'Discover New Workouts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //// dropdown
  ///// Returns container based on what is selected
  Widget getSelectedContainer() {
    if (selectedOption == 'Progress Monthly') {
      return Container(
        height: 190,
        width: 600,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)]),
        child: BarChart(BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.grey,
              tooltipHorizontalAlignment: FLHorizontalAlignment.right,
              tooltipMargin: 10,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay;
                switch (group.x) {
                  case 0:
                    weekDay = 'Monday';
                    break;
                  case 1:
                    weekDay = 'Tuesday';
                    break;
                  case 2:
                    weekDay = 'Wednesday';
                    break;
                  case 3:
                    weekDay = 'Thursday';
                    break;
                  case 4:
                    weekDay = 'Friday';
                    break;
                  case 5:
                    weekDay = 'Saturday';
                    break;
                  case 6:
                    weekDay = 'Sunday';
                    break;
                  default:
                    throw Error();
                }
                return BarTooltipItem(
                  '$weekDay\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: (rod.toY - 1).toString(),
                      style: TextStyle(
                        color: TColor.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
              });
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getTitles,
                reservedSize: 38,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingGroups(),
          gridData: const FlGridData(show: false),
        )),
      );
    } else if (selectedOption == 'Weekly') {
      return Container(
        color: const Color.fromARGB(255, 118, 30, 30),
        width: 100,
        height: 100,
        child: const Center(child: Text('weekly View')),
      );
    } else if (selectedOption == 'Yearly') {
      return Container(
        color: const Color.fromARGB(255, 118, 30, 30),
        width: 100,
        height: 100,
        child: const Center(child: Text('yearly View')),
      );
    } else {
      return Container();
    }
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.gray,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('Sun', style: style);
        break;
      case 1:
        text = Text('Mon', style: style);
        break;
      case 2:
        text = Text('Tue', style: style);
        break;
      case 3:
        text = Text('Wed', style: style);
        break;
      case 4:
        text = Text('Thu', style: style);
        break;
      case 5:
        text = Text('Fri', style: style);
        break;
      case 6:
        text = Text('Sat', style: style);
        break;
      default:
        text = const SizedBox.shrink(); // Empty widget for non-matching values
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0), // Adjust spacing as needed
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, TColor.primaryG,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 10.5, TColor.secondaryG,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, TColor.primaryG,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, TColor.secondaryG,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 15, TColor.primaryG,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 5.5, TColor.secondaryG,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 8.5, TColor.primaryG,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartGroupData makeGroupData(
    int x,
    double y,
    List<Color> barColor, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(
              colors: barColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.green)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: TColor.lightGray,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
