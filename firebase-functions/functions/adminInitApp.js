// import * as admin from 'firebase-admin';
// import { logger } from 'firebase-functions';
// import serviceAccount from './popomates.json';

const admin = require('firebase-admin')
// const logger = require('firebase-functions')
const serviceAccount = require('./skype-clone-bb342-firebase-adminsdk-ocmyg-9bc4f43326.json')

// export const adminInitApp = () => {
// 	let defaultApp: admin.app.App;

// 	if (!admin.apps.length) {
// 		defaultApp = admin.initializeApp({
// 			credential: admin.credential.cert(serviceAccount as any),
// 			databaseURL: 'https://popomates.firebaseio.com'
// 		});
// 		logger.info('Default app initialized');
// 	} else {
// 		defaultApp = admin.app();
// 	}

// 	return defaultApp;
// }

const adminInitApp = () => {
  let defaultApp

  if (!admin.apps.length) {
    defaultApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    })
  } else {
    defaultApp = admin.app()
  }

  return defaultApp
}

module.exports = {
  adminInitApp,
}
