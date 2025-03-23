import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safekids/utils/assets_path.dart';
import 'package:sizer/sizer.dart';
import 'auth_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? selectedRole;

  void navigateToNextScreen() {
    if (selectedRole == 'parent') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen(role: "parent")),
      );
    } else if (selectedRole == 'child') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen(role: "child")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text("Who's Going to use \n this device?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,),),
              const SizedBox(height: 32),
              Container(
                width: 82.w,
                height: 60.h,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = 'parent';
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        width: 80.0.w,
                        height: selectedRole == 'parent' ? 38.0.h : 12.0.h,
                        decoration: BoxDecoration(
                          color: selectedRole == 'parent' ? Colors.lightBlueAccent : Colors.grey.shade500,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Parent",
                                      style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold)),
                                  Text("Monitor & Manage Child Devices",
                                      style: TextStyle(color: Colors.black, fontSize: 16)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: SvgPicture.asset(AssetsPath.parentSvg,height: 200,),
                                  ),
                                ],
                              ),
                            ),
                            if (selectedRole == 'parent')
                              Positioned(
                                right: 20,
                                top: 20,
                                child: Icon(Icons.check_circle, color: Colors.white, size: 35),

                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height:5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = 'child';
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn,
                        width: 80.0.w,
                        height: selectedRole == 'child' ? 38.0.h : 12.0.h,
                        decoration: BoxDecoration(
                          color: selectedRole == 'child' ? Colors.orange : Colors.purpleAccent,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Child's",
                                      style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold)),
                                  Text("Stay Protected & Use Safe Apps",
                                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 45),
                                    child: SvgPicture.asset(AssetsPath.childSvg,height: 200,),
                                  ),
                                ],
                              ),
                            ),
                            // SvgPicture.asset(
                            //   AssetsPath.childSvg,
                            //   width: 280,height: 220,),

                            if (selectedRole == 'child')
                              Positioned(
                                right: 20,
                                top: 20,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedRole = 'child';
                                    });
                                  },
                                  child: Icon(
                                    Icons.check_circle,
                                    color: selectedRole == 'child'? Colors.white : Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30,right: 30),
                  child: ElevatedButton(
                    onPressed: selectedRole != null ? navigateToNextScreen : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: selectedRole != null ? Colors.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text("Continue", style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



