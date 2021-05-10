const functions = require('firebase-functions')
const admin = require('firebase-admin')
const {
  RtcTokenBuilder,
  RtcRole,
  RtmTokenBuilder,
} = require('agora-access-token')
const { adminInitApp } = require('../adminInitApp.js')

const defaultApp = adminInitApp()

const db = admin.firestore()

const createCallsWithTokens = functions.https.onCall(async (data, context) => {
  try {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'Unauthorized',
        'The user is not authenticated'
      )
    }

    const appId = '64b69ba11ab340679b6bcd0a3cb3823e'
    const appCertificate = 'b0c3c9df72ae45069e65c33e2e2618ee'
    const role = RtcRole.PUBLISHER
    const expirationTimeInSeconds = 3600
    const currentTimestamp = Math.floor(Date.now() / 1000)
    const privilegeExpired = currentTimestamp + expirationTimeInSeconds
    const uid = 0
    const channelName = Math.floor(Math.random() * 100).toString()

    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpired
    )

    const isCallerBusy = db.collection('call').doc(data.callerId).get()
    const isReceiverBusy = db.collection('call').doc(data.receiverId).get()

    if ((await isCallerBusy).exists || (await isReceiverBusy).exists) {
      return {
        data: {
          token: '',
          channelId: '',
        },
      }
    } else {
      const res = await admin
        .firestore()
        .collection('call')
        .doc(data.callerId)
        .set({
          callerId: data.callerId,
          callerName: data.callerName,
          callerPic: data.callerPic,
          receiverId: data.receiverId,
          receiverName: data.receiverName,
          receiverPic: data.receiverPic,
          type: data.type,
          channelId: channelName,
          hasDialed: true,
          token: token,
        })

      await admin.firestore().collection('call').doc(data.receiverId).set({
        callerId: data.callerId,
        callerName: data.callerName,
        callerPic: data.callerPic,
        receiverId: data.receiverId,
        receiverName: data.receiverName,
        receiverPic: data.receiverPic,
        type: data.type,
        channelId: channelName,
        hasDialed: false,
        token: token,
      })

      return {
        data: {
          token: token,
          channelId: channelName,
        },
      }
    }
  } catch (error) {
    console.log(error)
  }
})

module.exports = {
  createCallsWithTokens,
}
