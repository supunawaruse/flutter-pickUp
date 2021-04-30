const functions = require('firebase-functions')

exports.testFunction = functions.https.onRequest((req, res) => {
  functions.logger.info('Hello logs!', { structuredData: true })
  res.send('welcome supuna')
})
