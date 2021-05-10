const functions = require('firebase-functions')
const {
  onCallNotification,
} = require('./onCallNotification/onCallNotification.js')
const {
  createCallsWithTokens,
} = require('./createCallsWithTokens/createCallsWithTokens.js')
const { adminInitApp } = require('./adminInitApp.js')
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
adminInitApp()

module.exports = {
  onCallNotification,
  createCallsWithTokens,
}
