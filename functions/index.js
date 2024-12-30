/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

exports.sendTodoNotification = functions.firestore
  .document("todos/{todoId}")
  .onCreate(async (snapshot, context) => {
    const todo = snapshot.data();
    const userId = todo.userId;

    // Lấy FCM token của người dùng từ Firestore hoặc từ nơi lưu trữ
    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .get();
    const token = userDoc.data()?.fcmToken;

    if (token) {
      const message = {
        notification: {
          title: "Todo Created",
          body: `Your todo "${todo.task}" has been created successfully!`,
        },
        token: token,
      };

      await admin.messaging().send(message);
    }
  });
