import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';

class AuthServices {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user
  static Future<(User?,String)> signUp(UserModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      var userResult = userCredential.user;
      user = user.copyWith(id: userResult!.uid);
      await _userCollection.doc(user.id).set(user.toMap());
      return (userResult,'User created successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return (null,'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return (null,'The account already exists for that email.');
      }else{
        return (null,'An error occurred');
      }
    }
    catch (e) {
      return (null,'An error occurred');
    }
  }

  //sign in
  static Future<(UserModel?,String)> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return (null,'No user found for that email.');
      }
      var user = await _userCollection.doc(userCredential.user!.uid).get();
      if(user.exists) {
        return (UserModel.fromMap(user.data() as Map<String,dynamic>), 'User signed in successfully');
      }else{
        //sign out user
        await _auth.signOut();
        return (null,'No user found for that email.');
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return (null,'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return (null,'Wrong password provided for that user.');
      }else if(e.code == 'invalid-credential'){
        return (null,'Invalid user credential');
      }else{
        return (null,'An error occurred');
      }
    }
    catch (e) {
      return (null,'An error occurred');
    }
  }

  //sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<UserModel?>getUser({required String userId})async {
    try{
      var user = await _userCollection.doc(userId).get();
      if(user.exists) {
        return UserModel.fromMap(user.data() as Map<String,dynamic>);
      }else{
        return null;
      }
    }catch(e){
      return null;
    }
  }

  static Stream<List<UserModel>>streamUsers() {
    return _userCollection.snapshots().map((event) => event.docs.map((e) => UserModel.fromMap(e.data() as Map<String,dynamic>)).toList());
  }

  static Future<bool>updateUser({required UserModel user})async {
    try{
      await _userCollection.doc(user.id).update(user.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  static Future<String> uploadImage({required Uint8List image,required String id})async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref('profile').child('$id.jpg');
    UploadTask uploadTask = ref.putData(image, SettableMetadata(contentType: 'image/jpeg'));
    await uploadTask.whenComplete(() => null);
    return await ref.getDownloadURL();
  }

}
