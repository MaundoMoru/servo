import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/success.jfif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Job Successfully Applied',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Note that you successfully applied for this job. Once your bid has been accepted you will be notified',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuccessScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Apply More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(onPressed: () {}, child: const Text('Cancel Bid'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
