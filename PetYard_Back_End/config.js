const { initializeApp } = require('firebase/app');
const { getStorage } = require('firebase/storage');

const firebaseConfig = {
    apiKey: "AIzaSyDzYwPN17vzaVcOaYIqgwVRMiuRudlBsC8",
    authDomain: "petyard-9709b.firebaseapp.com",
    projectId: "petyard-9709b",
    storageBucket: "petyard-9709b.appspot.com",
    messagingSenderId: "135618688624",
    appId: "1:135618688624:web:3d1a99f0f09d91a4c066b5",
    measurementId: "G-62HHQL997K"
};

if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig);
}

const storage = firebase.storage();

module.exports = { storage };