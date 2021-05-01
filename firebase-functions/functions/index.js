const functions = require('firebase-functions')
const onCallNotification = require('./onCallNotification/onCallNotification.js')
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
module.exports = {
  onCallNotification,
}
