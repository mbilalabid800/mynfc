const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.recordTapAndRedirect = functions.https.onRequest(async (req, res) => {
  // Extract the UID from the request URL
  const uid = req.path.split('/')[2]; // Assuming /connection-profile-preview/<uid>

  if (!uid) {
    res.status(400).send('Missing userId');
    return;
  }

  try {
    // Increment the tap count in Firestore
    const userRef = admin.firestore().collection('users').doc(uid);
    await userRef.update({
      tapCount: admin.firestore.FieldValue.increment(1),
      // Optionally, you can record other data such as the timestamp
    });

    // Redirect to the actual profile page (replace with your profile URL)
    res.redirect(`https://nfcapp.com/connection-profile-preview/${uid}`);
  } catch (error) {
    console.error('Error recording tap:', error);
    res.status(500).send('Internal Server Error');
  }
});
