const { initializeApp, cert } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

const serviceAccount = require("./serviceAccountKey.json");

initializeApp({
  credential: cert(serviceAccount),
});

const db = getFirestore();

async function migrateAppointments() {

  const salons = await db.collection("salons").get();

  let migrated = 0;

  for (const salon of salons.docs) {
    console.log(`\nSalon: ${salon.id}`);

    const appointments =
        await salon.ref.collection("appointments").get();

    for (const appointment of appointments.docs) {

      const data = appointment.data();

      await db
          .collection("appointments")
          .doc(appointment.id)
          .set(data);

      migrated++;

      console.log(
          `✔ ${appointment.id}`
      );
    }
  }

  console.log("\n===========================");
  console.log(`Migrati ${migrated} appuntamenti`);
  console.log("===========================");
}

migrateAppointments()
    .then(() => {
      console.log("FINE");
      process.exit();
    })
    .catch((e) => {
      console.error(e);
      process.exit(1);
    });