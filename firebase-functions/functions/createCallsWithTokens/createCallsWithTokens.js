const functions = require('firebase-functions')
const admin = require('firebase-admin')
const { RtcTokenBuilder, RtcRole } = require('agora-access-token')
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
    const appCertificate = '3381071b1dde451daa52ee197de81478'
    const role = RtcRole.PUBLISHER
    const expirationTimeInSeconds = 3600
    const currentTimestamp = Math.floor(Date.now() / 1000)
    const privilegeExpired = currentTimestamp + expirationTimeInSeconds
    const uid = 0
    const channelName = Math.floor(Math.random() * 101).toString()

    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpired
    )

    await admin.firestore().collection('call').doc(data.receiverId).set({
      senderId: data.senderId,
      senderName: data.sederName,
      senderPic: data.senderPic,
      receiverId: data.receiverId,
      receiverName: data.receiverName,
      receiverPic: data.receiverPic,
      type: 'video',
      channelId: channelName,
      token: token,
    })

    await admin.firestore().collection('call').doc(data.senderId).set({
      senderId: data.senderId,
      senderName: data.sederName,
      senderPic: data.senderPic,
      receiverId: data.receiverId,
      receiverName: data.receiverName,
      receiverPic: data.receiverPic,
      type: 'video',
      channelId: channelName,
      token: token,
    })
  } catch (error) {
    console.log(error)
  }
})

module.exports = {
  createCallsWithTokens,
}
