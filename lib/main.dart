
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
import 'package:prodev/forgot.dart';
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
  '/forgotPassword':(context)=>ForgotPasswordScreen(),
        
       
        

        

      },
    );
  }
}
