const functions = require("firebase-functions/v1");
const {getFirestore} = require("firebase-admin/firestore");

// ERROR: Error: Cannot set CPU on the functions
//        createAdminDocument because they are GCF gen 1.

exports.createAdminDocument = functions.auth.user().onCreate(async (user) => {
  const {uid, email} = user;

  try {
    // Add a document to the "admins" collection
    await getFirestore().collection("admins").doc(uid).set({
      email: email || "",
      uid: uid,
      id: uid,
      name: "",
      socialSecurityNumber: "",
      role: "guest", // Default role
    });

    console.log(`Admin document created for user: ${uid}`);
  } catch (error) {
    console.error("Error creating admin document:", error);
  }
});
