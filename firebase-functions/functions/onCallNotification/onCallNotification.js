const functions = require('firebase-functions')
const admin = require('firebase-admin')
const { adminInitApp } = require('../adminInitApp')
// admin.initializeApp()

const { RtcTokenBuilder, RtcRole } = require('agora-access-token')

const defaultApp = adminInitApp()

const db = admin.firestore()

const onCallNotification = functions.firestore
  .document('call/{receiverId}')
  .onCreate(async (snap, context) => {
    const value = snap.data()
    const id = value.receiverId
    const owner = await admin.firestore().collection('users').doc(id).get()

    const receiverId = context.params.receiverId

    if (receiverId === id) {
      await admin.messaging().sendToDevice(
        owner.data().tokens[0], // ['token_1', 'token_2', ...]
        {
          data: {
            title: 'Someone is calling you',
            body: 'Go to pickup app can answer the call',
          },
          notification: {
            title: 'Someone is calling you',
            body: 'Go to pickup app can answer the call',
          },
        },
        {
          // Required for background/quit data-only messages on iOS
          contentAvailable: true,
          // Required for background/quit data-only messages on Android
          priority: 'high',
        }
      )
    }
  })

module.exports = {
  onCallNotification,
}
