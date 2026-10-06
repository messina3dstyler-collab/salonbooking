const path = require('path');
const { createRequire } = require('module');

const functionsRequire = createRequire(
  path.resolve(__dirname, 'functions/package.json'),
);

const { initializeApp } =
  functionsRequire('firebase-admin/app');

const { getAuth } =
  functionsRequire('firebase-admin/auth');

const { getFirestore, Timestamp } =
  functionsRequire('firebase-admin/firestore');

const PROJECT_ID = 'salonbooking-af1df';

const AUTH_EMULATOR =
  'http://127.0.0.1:9099';

const FIRESTORE_EMULATOR =
  'http://127.0.0.1:8080';

const suffix = Date.now().toString();

const SALON_ID =
  `bh3_salon_${suffix}`;

const CUSTOMER_EMAIL =
  `bh3-customer-${suffix}@example.com`;

const OTHER_EMAIL =
  `bh3-other-${suffix}@example.com`;

const PASSWORD =
  'Test1234!';

initializeApp({
  projectId: PROJECT_ID,
});

const db = getFirestore();
const auth = getAuth();

function assert(condition, message) {
  if (!condition) {
    throw new Error(
      `ASSERTION FAILED: ${message}`,
    );
  }
}

async function signIn(
  email,
  password,
) {
  const response = await fetch(
    `${AUTH_EMULATOR}/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=fake-api-key`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email,
        password,
        returnSecureToken: true,
      }),
    },
  );

  const body = await response.json();

  if (!response.ok) {
    throw new Error(
      `AUTH SIGN-IN FAILED: ${JSON.stringify(body)}`,
    );
  }

  return body.idToken;
}

function firestoreValue(value) {
  if (typeof value === 'string') {
    return {
      stringValue: value,
    };
  }

  if (typeof value === 'boolean') {
    return {
      booleanValue: value,
    };
  }

  if (typeof value === 'number') {
    return {
      integerValue: String(value),
    };
  }

  if (value instanceof Date) {
    return {
      timestampValue: value.toISOString(),
    };
  }

  throw new Error(
    `Unsupported Firestore value: ${value}`,
  );
}

async function createRequest(
  idToken,
  requestId,
  appointmentId,
  customerId,
  appointmentDate,
) {
  //--------------------------------------------------
  // FIRESTORE ATOMIC COMMIT
  //--------------------------------------------------

  // IMPORTANT:
  //
  // Il path corretto dell'endpoint Firestore REST è:
  //
  // /databases/(default)/documents:commit
  //
  // e NON:
  //
  // /databases/(default):commit
  //
  //--------------------------------------------------

  const url =
    `${FIRESTORE_EMULATOR}/v1/projects/${PROJECT_ID}/databases/(default)/documents:commit`;

  const now = new Date();

  const timelineEventId =
    `bh3_timeline_created_${suffix}_${Date.now()}`;

  const requestName =
    `projects/${PROJECT_ID}/databases/(default)/documents/appointment_requests/${requestId}`;

  const lockName =
    `projects/${PROJECT_ID}/databases/(default)/documents/appointment_cancellation_locks/${appointmentId}`;

  const timelineName =
    `projects/${PROJECT_ID}/databases/(default)/documents/appointment_requests/${requestId}/timeline/${timelineEventId}`;

  //--------------------------------------------------
  // REQUEST
  //--------------------------------------------------

  const requestFields = {
    id:
      firestoreValue(requestId),

    appointmentId:
      firestoreValue(appointmentId),

    salonId:
      firestoreValue(SALON_ID),

    salonName:
      firestoreValue('BH3 Test Salon'),

    customerId:
      firestoreValue(customerId),

    customerName:
      firestoreValue('BH3 Customer'),

    customerPhone:
      firestoreValue('+390000000000'),

    createdBy:
      firestoreValue('customer'),

    createdByName:
      firestoreValue('BH3 Customer'),

    priority:
      firestoreValue('high'),

    type:
      firestoreValue('cancelAppointment'),

    status:
      firestoreValue('pendingSalon'),

    createdAt:
      firestoreValue(now),

    updatedAt:
      firestoreValue(now),

    payload: {
      mapValue: {
        fields: {
          appointmentStart:
            firestoreValue(
              appointmentDate,
            ),

          appointmentEnd:
            firestoreValue(
              new Date(
                appointmentDate.getTime() +
                  60 * 60 * 1000,
              ),
            ),

          reason:
            firestoreValue(
              'BH3 test cancellation',
            ),
        },
      },
    },
  };

  //--------------------------------------------------
  // CANCELLATION LOCK
  //--------------------------------------------------

  const lockFields = {
    appointmentId:
      firestoreValue(appointmentId),

    requestId:
      firestoreValue(requestId),

    customerId:
      firestoreValue(customerId),

    salonId:
      firestoreValue(SALON_ID),

    createdAt:
      firestoreValue(now),
  };

  //--------------------------------------------------
  // INITIAL TIMELINE EVENT
  //--------------------------------------------------

  const timelineFields = {
    id:
      firestoreValue(timelineEventId),

    requestId:
      firestoreValue(requestId),

    type:
      firestoreValue('created'),

    createdAt:
      firestoreValue(now),

    author:
      firestoreValue('customer'),

    message:
      firestoreValue('Richiesta creata.'),
  };

  //--------------------------------------------------
  // ATOMIC COMMIT
  //--------------------------------------------------

  const payload = {
    writes: [
      {
        update: {
          name: requestName,
          fields: requestFields,
        },
      },
      {
        update: {
          name: lockName,
          fields: lockFields,
        },
      },
      {
        update: {
          name: timelineName,
          fields: timelineFields,
        },
      },
    ],
  };

  const response = await fetch(
    url,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization:
          `Bearer ${idToken}`,
      },
      body: JSON.stringify(payload),
    },
  );

  const rawBody =
    await response.text();

  let body;

  try {
    body =
      rawBody
        ? JSON.parse(rawBody)
        : {};
  } catch (_) {
    body = {
      raw: rawBody,
    };
  }

  return {
    status: response.status,
    body,
  };
}

async function main() {
  let customerUid = null;
  let otherUid = null;

  const appointmentId =
    `bh3_appointment_${suffix}`;

  const duplicateRequestId =
    `bh3_request_duplicate_${suffix}`;

  const validRequestId =
    `bh3_request_valid_${suffix}`;

  const tooSoonAppointmentId =
    `bh3_appointment_soon_${suffix}`;

  const tooSoonRequestId =
    `bh3_request_soon_${suffix}`;

  try {
    console.log(
      '\n=== BH3 CANCELLATION RULES TEST ===',
    );

    // ---------------------------------------------------------
    // 1. CUSTOMER
    // ---------------------------------------------------------

    const customer =
      await auth.createUser({
        email: CUSTOMER_EMAIL,
        password: PASSWORD,
        displayName: 'BH3 Customer',
        emailVerified: true,
      });

    customerUid =
      customer.uid;

    await db
      .collection('users')
      .doc(customerUid)
      .set({
        role: 'customer',
      });

    console.log(
      'CUSTOMER AUTH + USER DOC: OK',
    );

    // ---------------------------------------------------------
    // 2. SECOND CUSTOMER
    // ---------------------------------------------------------

    const other =
      await auth.createUser({
        email: OTHER_EMAIL,
        password: PASSWORD,
        displayName: 'BH3 Other Customer',
        emailVerified: true,
      });

    otherUid =
      other.uid;

    await db
      .collection('users')
      .doc(otherUid)
      .set({
        role: 'customer',
      });

    console.log(
      'SECOND CUSTOMER AUTH + USER DOC: OK',
    );

    // ---------------------------------------------------------
    // 3. VALID APPOINTMENT — 72 HOURS AHEAD
    // ---------------------------------------------------------

    const validAppointmentDate =
      new Date(
        Date.now() +
          72 * 60 * 60 * 1000,
      );

    await db
      .collection('appointments')
      .doc(appointmentId)
      .set({
        userId:
          customerUid,

        salonId:
          SALON_ID,

        employeeId:
          'bh3_employee',

        serviceId:
          'bh3_service',

        date:
          Timestamp.fromDate(
            validAppointmentDate,
          ),

        price:
          50,

        duration:
          60,

        serviceDuration:
          60,

        status:
          'Prenotata',
      });

    console.log(
      'VALID APPOINTMENT: OK',
    );

    // ---------------------------------------------------------
    // 4. AUTHENTICATE CUSTOMER
    // ---------------------------------------------------------

    const customerToken =
      await signIn(
        CUSTOMER_EMAIL,
        PASSWORD,
      );

    console.log(
      'CUSTOMER ID TOKEN: OK',
    );

    // ---------------------------------------------------------
    // 5. FIRST CANCELLATION REQUEST
    // ---------------------------------------------------------

    const first =
      await createRequest(
        customerToken,
        validRequestId,
        appointmentId,
        customerUid,
        validAppointmentDate,
      );

    assert(
      first.status === 200,
      `first valid request was rejected: ${JSON.stringify(first.body)}`,
    );

    console.log(
      'FIRST CANCELLATION REQUEST: ACCEPTED',
    );

    // ---------------------------------------------------------
    // 6. SECOND CANCELLATION REQUEST
    // ---------------------------------------------------------

    const duplicate =
      await createRequest(
        customerToken,
        duplicateRequestId,
        appointmentId,
        customerUid,
        validAppointmentDate,
      );

    console.log(
      `DUPLICATE REQUEST HTTP STATUS: ${duplicate.status}`,
    );

    console.log(
      `DUPLICATE REQUEST RESPONSE: ${JSON.stringify(duplicate.body)}`,
    );

    assert(
      duplicate.status !== 200,
      'DUPLICATE CANCELLATION REQUEST WAS ACCEPTED',
    );

    console.log(
      'DUPLICATE CANCELLATION REQUEST: REJECTED',
    );

    // ---------------------------------------------------------
    // 7. TOO-SOON APPOINTMENT — 47 HOURS
    // ---------------------------------------------------------

    const tooSoonAppointmentDate =
      new Date(
        Date.now() +
          47 * 60 * 60 * 1000,
      );

    await db
      .collection('appointments')
      .doc(tooSoonAppointmentId)
      .set({
        userId:
          customerUid,

        salonId:
          SALON_ID,

        employeeId:
          'bh3_employee',

        serviceId:
          'bh3_service',

        date:
          Timestamp.fromDate(
            tooSoonAppointmentDate,
          ),

        price:
          50,

        duration:
          60,

        serviceDuration:
          60,

        status:
          'Prenotata',
      });

    const tooSoon =
      await createRequest(
        customerToken,
        tooSoonRequestId,
        tooSoonAppointmentId,
        customerUid,
        tooSoonAppointmentDate,
      );

    console.log(
      `47H REQUEST HTTP STATUS: ${tooSoon.status}`,
    );

    assert(
      tooSoon.status !== 200,
      '47-hour cancellation request was accepted',
    );

    console.log(
      '48-HOUR RULE: OK',
    );

    // ---------------------------------------------------------
    // 8. WRONG CUSTOMER OWNERSHIP
    // ---------------------------------------------------------

    const otherToken =
      await signIn(
        OTHER_EMAIL,
        PASSWORD,
      );

    const wrongOwnerRequestId =
      `bh3_request_wrong_owner_${suffix}`;

    const wrongOwner =
      await createRequest(
        otherToken,
        wrongOwnerRequestId,
        appointmentId,
        otherUid,
        validAppointmentDate,
      );

    console.log(
      `WRONG OWNER HTTP STATUS: ${wrongOwner.status}`,
    );

    assert(
      wrongOwner.status !== 200,
      'wrong customer was allowed to cancel another customer appointment',
    );

    console.log(
      'CUSTOMER OWNERSHIP: OK',
    );

    // ---------------------------------------------------------
    // FINAL
    // ---------------------------------------------------------

    console.log(
      '\n==========================================',
    );

    console.log(
      'BH3 CANCELLATION RULES TEST: PASS',
    );

    console.log(
      '==========================================\n',
    );
  } finally {
    // ---------------------------------------------------------
    // CLEANUP
    // ---------------------------------------------------------

    console.log(
      '--- CLEANUP ---',
    );

    const requestIds = [
      validRequestId,
      duplicateRequestId,
      tooSoonRequestId,
      `bh3_request_wrong_owner_${suffix}`,
    ];

    for (const requestId of requestIds) {
      await db
        .collection('appointment_requests')
        .doc(requestId)
        .delete()
        .catch(() => {});

      // Timeline iniziale.
      // La collection padre viene eliminata dal test
      // tramite il documento request; eventuali subcollection
      // residue non interferiscono con il nuovo suffix.
    }

    await db
      .collection('appointment_cancellation_locks')
      .doc(appointmentId)
      .delete()
      .catch(() => {});

    await db
      .collection('appointment_cancellation_locks')
      .doc(tooSoonAppointmentId)
      .delete()
      .catch(() => {});

    await db
      .collection('appointments')
      .doc(appointmentId)
      .delete()
      .catch(() => {});

    await db
      .collection('appointments')
      .doc(tooSoonAppointmentId)
      .delete()
      .catch(() => {});

    if (customerUid) {
      await db
        .collection('users')
        .doc(customerUid)
        .delete()
        .catch(() => {});

      await auth
        .deleteUser(customerUid)
        .catch(() => {});
    }

    if (otherUid) {
      await db
        .collection('users')
        .doc(otherUid)
        .delete()
        .catch(() => {});

      await auth
        .deleteUser(otherUid)
        .catch(() => {});
    }

    console.log(
      'CLEANUP: OK',
    );
  }
}

main().catch((error) => {
  console.error(
    '\n==========================================',
  );

  console.error(
    'BH3 CANCELLATION RULES TEST: FAIL',
  );

  console.error(
    '==========================================',
  );

  console.error(error);

  process.exitCode = 1;
});