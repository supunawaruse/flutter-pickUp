const functions = require('firebase-functions')
const admin = require('firebase-admin')
const { adminInitApp } = require('../adminInitApp')
// admin.initializeApp()

const { RtcTokenBuilder, RtcRole } = require('agora-access-token')

const defaultApp = adminInitApp()

const db = admin.firestore()

const onCallNotification = functions.firestore
  .document('call/{callerId}')
  .onCreate(async (snap, context) => {
    const value = snap.data()
    const id = value.caller_id
    const owner = await admin.firestore().collection('users').doc(id).get()

    const dialerId = context.params.callerId

    const appId = '64b69ba11ab340679b6bcd0a3cb3823e'
    const appCertificate = '3381071b1dde451daa52ee197de81478'
    const role = RtcRole.PUBLISHER

    const channelName = value.channel_id
    const expirationTimeInSeconds = 3600
    const currentTimestamp = Math.floor(Date.now() / 1000)
    const privilegeExpired = currentTimestamp + expirationTimeInSeconds
    const uid = 0

    const token = RtcTokenBuilder.buildTokenWithAccount(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpired
    )

    if (token !== null) {
      await admin
        .firestore()
        .collection('call')
        .doc(value.caller_id)
        .update({ token: token })

      await admin
        .firestore()
        .collection('call')
        .doc(value.receiver_id)
        .update({ token: token })
    }

    if (dialerId === id) {
      await admin.messaging().sendToDevice(
        owner.data().tokens[0], // ['token_1', 'token_2', ...]
        {
          data: {
            title: 'supuna',
            body: 'hey',
          },
          notification: {
            title: 'supunaqweqwe',
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
    }
  })

module.exports = {
  onCallNotification,
}
