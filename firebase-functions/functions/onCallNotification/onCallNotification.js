const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

const db = admin.firestore()

const onCallNotification = functions.firestore
  .document('call/{callerId}')
  .onCreate(async (snap, context) => {
    const value = snap.data()
    const id = value.caller_id
    const owner = await admin.firestore().collection('users').doc(id).get()

    await admin.messaging().sendToDevice(
      owner.data().tokens, // ['token_1', 'token_2', ...]
      {
        data: {
          title: 'supuna',
          body: 'hey',
        },
        notification: {
          title: 'supuna',
          body: 'hey',
        },
      },
      {
        // Required for background/quit data-only messages on iOS
        contentAvailable: true,
        // Required for background/quit data-only messages on Android
        priority: 'high',
      }
    )
  })

module.exports = {
  onCallNotification,
}
