// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:prodev/user/registration_user.dart';
// import 'firebase_options.dart';

// void main() async{
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
     
// );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home:RegisterScreen(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prodev/admin/admin_company.dart';
import 'package:prodev/admin/admin_content.dart';
import 'package:prodev/admin/admin_jobmanagement.dart';
import 'package:prodev/admin/admin_user.dart';
import 'package:prodev/admin/dashboard_admin.dart';
import 'package:prodev/authority/companyHomepage.dart';
import 'package:prodev/authority/company_candidates.dart';
import 'package:prodev/authority/company_jobs.dart';
import 'package:prodev/authority/company_registration.dart';
import 'package:prodev/authority/companyprofile.dart';
import 'package:prodev/logoscreen.dart';
import 'package:prodev/splashscreen.dart';
import 'package:prodev/user/chatbot.dart';
import 'package:prodev/user/companychat.dart';
import 'package:prodev/user/ielts.dart';
import 'package:prodev/user/ielts_listening.dart';
import 'package:prodev/user/ielts_reading.dart';
import 'package:prodev/user/ielts_speaking.dart';
import 'package:prodev/user/ielts_writing.dart';
import 'package:prodev/user/jobapplication.dart';
import 'package:prodev/user/jobdetails.dart';
import 'package:prodev/user/jobs.dart';
import 'package:prodev/user/mocktest.dart';
import 'package:prodev/user/registration_user.dart';
import 'package:prodev/login.dart';
import 'package:prodev/user/tips&strategies.dart';
import 'package:prodev/user/user_homepage.dart'; // Ensure this exists
import 'package:prodev/user/userprofile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProDev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Logoscreen(),
      routes: {
        '/splashscreen':(context)=> SplashScreen(),
        '/register': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/userHomepage': (context) => UserHomepage(),
        '/CompanyRegistration': (context) => CompanyRegistration(),
        '/companyhomepage':(context)=> CompanyHomepage(),
        '/RegistrationUser': (context) => RegistrationUser(),
        '/UserProfile':(context)=> UserProfile(),
        '/CompanyProfile':(context)=> CompanyProfile(),
        '/Logoscreen':( context)=>Logoscreen(),
         '/IeltsPage': (context) => IeltsPage(),
        '/JobsPages': (context) => JobsPage(),
        '/IELTSListeningPage': (context) => ListeningPage(),
        '/IELTSReadingPage': (context) => IELTSReadingPage(),
        '/IELTSWritingPage': (context) => IELTSWritingPage(),
        '/IELTSSpeakingPage': (context) => IELTSSpeakingPage(),
        '/MockTestsPage': (context) => MockTestsPage(),
        '/TipsPage': (context) => TipsPage(),
        '/AdminDashboard':(context)=>AdminDashboard(),
        '/adminUsers': (context) => AdminUserManagementScreen(),
        '/adminCompanies': (context) => AdminCompanyManagementScreen(),
        '/adminJobs': (context) => AdminJobManagementScreen(),
        '/adminContent': (context) => AdminContentPage(),
        '/CompanyJobsPage':(context)=>CompanyJobsPage(), 
        '/CandidatesPage':(context)=>CandidatesPage(),
        '/aichatbot':(context)=>userchatbot(),
  
        
       
        

        

      },
    );
  }
}
