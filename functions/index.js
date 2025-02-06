const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.recordTapAndRedirect = functions.https.onRequest(async (req, res) => {
  // Extract the UID from the request URL
  const uid = req.path.split('/')[2]; // Assuming /profile/<uid>

  if (!uid) {
    res.status(400).send('Missing userId');
    return;
  }

  try {
    // Reference the user's document in Firestore
    const userRef = admin.firestore().collection('users').doc(uid);

    // Check if the document exists, create it if not
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      // If the document does not exist, initialize it with tapCount
      await userRef.set({ tapCount: 1 }, { merge: true });
    } else {
      // Increment the tap count if the document already exists
      await userRef.update({
        tapCount: admin.firestore.FieldValue.increment(1),
      });
    }

    // Redirect to the actual profile page (replace with your profile URL)
    res.redirect(`https://website.myabsher.com/#/profile/${uid}`);
  } catch (error) {
    console.error('Error recording tap:', error);
    res.status(500).send('Internal Server Error');
  }
});
