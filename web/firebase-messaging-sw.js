importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCsnjca_d89TRxgU1c_xpYZ7sdDhlnN3MY",
  authDomain: "salonbooking-af1df.firebaseapp.com",
  projectId: "salonbooking-af1df",
  storageBucket: "salonbooking-af1df.firebasestorage.app",
  messagingSenderId: "1059928848546",
  appId: "1:1059928848546:web:37a0dc3298abc32a3a7ffb",
});

const messaging = firebase.messaging();