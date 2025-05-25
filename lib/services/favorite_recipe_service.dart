import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRecipeService {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<List> getUserFavorites() async {
    var userDetails =
        await FirebaseFirestore.instance
            .collection('tbl_users')
            .doc(currentUser?.uid)
            .get();
    return userDetails['favorites'];
  }

  void addToFavorites(String recipeID) async {
    List userFavorites = await getUserFavorites();

    userFavorites.add(recipeID);

    await FirebaseFirestore.instance
        .collection('tbl_users')
        .doc(currentUser?.uid)
        .update({'favorites': userFavorites});
  }

  void removeFromFavorites(String recipeID) async {
    List userFavorites = await getUserFavorites();

    if (userFavorites.remove(recipeID)) {
      await FirebaseFirestore.instance
          .collection('tbl_users')
          .doc(currentUser?.uid)
          .update({'favorites': userFavorites});
    }
  }
}
