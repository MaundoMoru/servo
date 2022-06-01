import 'package:flutter/material.dart';

class JobApplicantsScreen extends StatefulWidget {
  const JobApplicantsScreen({Key? key}) : super(key: key);

  @override
  State<JobApplicantsScreen> createState() => _JobApplicantsScreenState();
}

class _JobApplicantsScreenState extends State<JobApplicantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue.shade100,
            ),
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: const TabBar(tabs: [
                      Tab(text: "Home"),
                      Tab(text: "Articles"),
                      Tab(text: "User"),
                    ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(children: [
                      Container(
                        child: const Text(
                            "Over recent years, things have drastically changed in the recruitment industry. Owing to the advent of technology, companies no longer use newspapers and leaflets to advertise about the vacancies in their firm. Instead, they rely on digital platforms like job search mobile app or web portals to recruit the best talent for their organization. On the other hand, job seekers are relieved of running from one company to another for dropping their resume.Over recent years, things have drastically changed in the recruitment industry. Owing to the advent of technology, companies no longer use newspapers and leaflets to advertise about the vacancies in their firm. Instead, they rely on digital platforms like job search mobile app or web portals to recruit the best talent for their organization. On the other hand, job seekers are relieved of running from one company to another for dropping their resume.Over recent years, things have drastically changed in the recruitment industry. Owing to the advent of technology, companies no longer use newspapers and leaflets to advertise about the vacancies in their firm. Instead, they rely on digital platforms like job search mobile app or web portals to recruit the best talent for their organization. On the other hand, job seekers are relieved of running from one company to another for dropping their resume."),
                      ),
                      Container(
                        child: Text("Articles Body"),
                      ),
                      Container(
                        child: Text("User Body"),
                      ),
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
