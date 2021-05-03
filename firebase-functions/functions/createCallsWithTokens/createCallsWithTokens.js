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
    const appCertificate = '3381071b1dde451daa52ee197de81478'
    const role = RtcRole.PUBLISHER
    const expirationTimeInSeconds = 3600
    const currentTimestamp = Math.floor(Date.now() / 1000)
    const privilegeExpired = currentTimestamp + expirationTimeInSeconds
    const uid = 0
    const channelName = Math.floor(Math.random() * 101)

    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      uid,
      role,
      privilegeExpired
    )
    console.log(token)
    return context.auth.uid
  } catch (error) {
    throw new functions.https.HttpsError('eroor white')
  }
})

module.exports = {
  createCallsWithTokens,
}
