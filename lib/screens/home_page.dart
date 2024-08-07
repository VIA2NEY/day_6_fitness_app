import 'package:day_6_fitness_app/animations/fade_animations.dart';
import 'package:day_6_fitness_app/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;

  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0
    );

    rippleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    );

    scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1)
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Dashboard()));
      }
    });

    rippleAnimation = Tween<double>(
      begin: 80.0,
      end: 90.0
    ).animate(rippleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rippleController.reverse();
      } else if(status == AnimationStatus.dismissed) {
        rippleController.forward();
      }
    });

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 30.0
    ).animate(scaleController);

    rippleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          makePage(image: 'assets/two.jpg'),
          makePage(image: 'assets/one.jpg'),
          makePage(image: 'assets/three.jpg'),
        ],
      ),
    );
  }

  Widget makePage({image}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover
        )
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(.3),
              Colors.black.withOpacity(.2),
            ]
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60,),
                  FadeAnimation(1.5, Text('Bonjour\nhealth body', style: TextStyle(color: Color.fromARGB(255, 200, 224, 229), fontSize: 45, fontWeight: FontWeight.w900),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.5, Text('Avec cette application vous pouvez essayer different activité \net choisir ceux que vous apprecier le plus.', style: TextStyle(color: Color.fromARGB(255, 185, 202, 206), fontSize: 18, height: 1.4, fontWeight: FontWeight.w300),)),
                  SizedBox(height: 40,),
                ],
              ),
              
              FadeAnimation(1, Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: rippleAnimation,
                  builder: (context, child) => Container(
                    width: rippleAnimation.value,
                    height: rippleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.4)
                      ),
                      child: InkWell(
                        onTap: () {
                          scaleController.forward();
                        },
                        child: AnimatedBuilder(
                          animation: scaleAnimation,
                          builder: (context, child) => Transform.scale(
                            scale: scaleAnimation.value,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                              ),
                              child: scaleController.status == AnimationStatus.forward || scaleController.status == AnimationStatus.completed ? null : Center(
                                child: Icon(Icons.fingerprint, size: 40,)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      )
    );
  }
}