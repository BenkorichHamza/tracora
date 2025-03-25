import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracora/app/core/error_handler.dart';
import 'package:tracora/app/data/models/employee_model.dart';
import 'package:tracora/app/data/models/user_model.dart';
import 'package:tracora/app/modules/home/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(bool value) => this._loading.value = value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  googleLogin() async {
    try {
      loading = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var u = await FirebaseAuth.instance.signInWithCredential(credential);
      var user = u.user;
      if (user == null) throw ('null_user');
      var e = EmployeeModel(
        id: user.uid,
        email: user.email,
        img: user.photoURL,
      );
      var doc =
          await FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser?.uid ?? 'default')
              .doc("2025")
              .collection('employees')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        e = EmployeeModel.fromMap(doc.data() ?? {});
      } else {
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(user.uid)
            .set(e.toMap());
      }
      var pref = await SharedPreferences.getInstance();
      pref.setString("employee", e.toJson());
      Get.find<HomeController>().employee = e;
    } on Exception catch (e) {
      ErrorHandler.handleError(e);
    } finally {
      loading = false;
    }
  }
}
