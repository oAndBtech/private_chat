importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");


const firebaseConfig = {
    apiKey: "AIzaSyDArjZsX03S14zghN7bfIV2OTdFQjz4Uz4",
    authDomain: "chat-app-oandb.firebaseapp.com",
    projectId: "chat-app-oandb",
    storageBucket: "chat-app-oandb.appspot.com",
    messagingSenderId: "369697723634",
    appId: "1:369697723634:web:1efc983a13c28a5835ec6b",
    measurementId: "G-VJB49DLFN2"
};


firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});