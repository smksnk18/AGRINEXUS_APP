import 'package:flutter/material.dart';
import '../../../services/health_profile_service.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() =>
      _HealthProfileScreenState();
}
class _HealthProfileScreenState
    extends State<HealthProfileScreen> {
  bool diabetes = false;

  bool hypertension = false;

  bool kidneyDisease = false;

  bool heartDisease = false;

  bool obesity = false;

  bool pregnancy = false;

  bool milkAllergy = false;

  bool peanutAllergy = false;

  bool eggAllergy = false;

  bool shellfishAllergy = false;

  @override
  void initState() {
    super.initState();
    diabetes =
        HealthProfileService.profile.diabetes;

    hypertension =
        HealthProfileService.profile.hypertension;

    kidneyDisease =
        HealthProfileService.profile.kidneyDisease;

    heartDisease =
        HealthProfileService.profile.heartDisease;

    obesity =
        HealthProfileService.profile.obesity;

    pregnancy =
        HealthProfileService.profile.pregnancy;

    milkAllergy =
        HealthProfileService.profile.milkAllergy;

    peanutAllergy =
        HealthProfileService.profile.peanutAllergy;

    eggAllergy =
        HealthProfileService.profile.eggAllergy;

    shellfishAllergy =
        HealthProfileService.profile.shellfishAllergy;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage Health Condition",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CheckboxListTile(
                  title: Text(
                    "Diabetes",
                  ),
                  value: diabetes,
                  onChanged: (value) {
                    setState(() {
                      diabetes = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Hypertension",
                  ),
                  value: hypertension,
                  onChanged: (value) {
                    setState(() {
                      hypertension = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Kidney Disease",
                  ),
                  value: kidneyDisease,
                  onChanged: (value) {
                    setState(() {
                      kidneyDisease = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Heart Disease",
                  ),
                  value: heartDisease,
                  onChanged: (value) {
                    setState(() {
                      heartDisease = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Obesity",
                  ),
                  value: obesity,
                  onChanged: (value) {
                    setState(() {
                      obesity = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Pregnancy",
                  ),
                  value: pregnancy,
                  onChanged: (value) {
                    setState(() {
                      pregnancy = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Milk Allergy",
                  ),
                  value: milkAllergy,
                  onChanged: (value) {
                    setState(() {
                      milkAllergy = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Peanut Allergy",
                  ),
                  value: peanutAllergy,
                  onChanged: (value) {
                    setState(() {
                      peanutAllergy = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Egg Allergy",
                  ),
                  value: eggAllergy,
                  onChanged: (value) {
                    setState(() {
                      eggAllergy = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text(
                    "Shellfish Allergy",
                  ),
                  value: shellfishAllergy,
                  onChanged: (value) {
                    setState(() {
                      shellfishAllergy = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HealthProfileService.profile.diabetes =
                          diabetes;

                      HealthProfileService.profile.hypertension =
                          hypertension;

                      HealthProfileService.profile.kidneyDisease =
                          kidneyDisease;

                      HealthProfileService.profile.heartDisease =
                          heartDisease;

                      HealthProfileService.profile.obesity =
                          obesity;

                      HealthProfileService.profile.pregnancy =
                          pregnancy;

                      HealthProfileService.profile.milkAllergy =
                          milkAllergy;

                      HealthProfileService.profile.peanutAllergy =
                          peanutAllergy;

                      HealthProfileService.profile.eggAllergy =
                          eggAllergy;

                      HealthProfileService.profile.shellfishAllergy =
                          shellfishAllergy;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Profile saved successfully",
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text(
                        "Save Profile",
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}