const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { setGlobalOptions } = require('firebase-functions/v2');
const { initializeApp } = require('firebase-admin/app');
const {
  getAuth,
} = require('firebase-admin/auth');
const {
  getFirestore,
  FieldValue,
} = require('firebase-admin/firestore');

initializeApp();

setGlobalOptions({
  region: 'europe-west12',
});

const db = getFirestore();
const auth = getAuth();

const MIN_SALON_HOUR = 0;
const MAX_SALON_HOUR = 23;

function requireNonEmptyString(value, fieldName) {
  if (typeof value !== 'string' || value.trim() === '') {
    throw new HttpsError(
      'invalid-argument',
      `${fieldName} is required.`,
    );
  }

  return value.trim();
}

function validateRegistrationData(data) {
  if (
    data === null ||
    typeof data !== 'object' ||
    Array.isArray(data)
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Registration data is required.',
    );
  }

  const ownerName = requireNonEmptyString(
    data.ownerName,
    'ownerName',
  );

  const salonName = requireNonEmptyString(
    data.salonName,
    'salonName',
  );

  const email = requireNonEmptyString(
    data.email,
    'email',
  );

  const phone = requireNonEmptyString(
    data.phone,
    'phone',
  );

  const address = requireNonEmptyString(
    data.address,
    'address',
  );

  const city = requireNonEmptyString(
    data.city,
    'city',
  );

  const description =
    typeof data.description === 'string'
      ? data.description.trim()
      : '';

  const taxIdType = requireNonEmptyString(
    data.taxIdType,
    'taxIdType',
  );

  const taxId = requireNonEmptyString(
    data.taxId,
    'taxId',
  );

  const openingHour = data.openingHour;
  const closingHour = data.closingHour;

  if (
    !Number.isInteger(openingHour) ||
    openingHour < MIN_SALON_HOUR ||
    openingHour > MAX_SALON_HOUR
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid openingHour.',
    );
  }

  if (
    !Number.isInteger(closingHour) ||
    closingHour < MIN_SALON_HOUR ||
    closingHour > MAX_SALON_HOUR
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid closingHour.',
    );
  }

  if (closingHour <= openingHour) {
    throw new HttpsError(
      'invalid-argument',
      'closingHour must be later than openingHour.',
    );
  }

  if (
    taxIdType !== 'vat' &&
    taxIdType !== 'fiscalCode'
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid taxIdType.',
    );
  }

  if (!Array.isArray(data.closedWeekdays)) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid closedWeekdays.',
    );
  }

  if (
    data.closedWeekdays.some(
      (weekday) =>
        !Number.isInteger(weekday) ||
        weekday < 1 ||
        weekday > 7,
    )
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid closedWeekdays.',
    );
  }

  const closedWeekdays = [
    ...new Set(data.closedWeekdays),
  ].sort((a, b) => a - b);

  return {
    ownerName,
    salonName,
    email,
    phone,
    address,
    city,
    description,
    taxIdType,
    taxId,
    openingHour,
    closingHour,
    closedWeekdays,
  };
}

exports.healthCheck = onCall(() => {
  return {
    ok: true,
    service: 'salonbooking-functions',
  };
});

exports.registerSalon = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      'unauthenticated',
      'Authentication is required.',
    );
  }

  const uid = request.auth.uid;

  const data = validateRegistrationData(
    request.data,
  );

  let authenticatedEmail;

  try {
    const authenticatedUser = await auth.getUser(uid);

    authenticatedEmail =
      typeof authenticatedUser.email === 'string'
        ? authenticatedUser.email.trim()
        : '';

    if (authenticatedEmail === '') {
      throw new HttpsError(
        'failed-precondition',
        'The authenticated user must have an email address.',
      );
    }
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }

    console.error(
      'Unable to load authenticated user:',
      error,
    );

    throw new HttpsError(
      'internal',
      'Unable to verify authenticated user.',
    );
  }

  if (
    data.email.toLowerCase() !==
    authenticatedEmail.toLowerCase()
  ) {
    throw new HttpsError(
      'invalid-argument',
      'The registration email must match the authenticated account email.',
    );
  }

  const salonRef = db
    .collection('salons')
    .doc(uid);

  const privateSalonRef = db
    .collection('salon_private')
    .doc(uid);

  const userRef = db
    .collection('users')
    .doc(uid);

  try {
    await db.runTransaction(async (transaction) => {
      const salonSnapshot =
        await transaction.get(salonRef);

      const privateSalonSnapshot =
        await transaction.get(privateSalonRef);

      const userSnapshot =
        await transaction.get(userRef);

      if (
        salonSnapshot.exists ||
        privateSalonSnapshot.exists ||
        userSnapshot.exists
      ) {
        throw new HttpsError(
          'already-exists',
          'An account is already provisioned for this user.',
        );
      }

      transaction.create(salonRef, {
        name: data.salonName,
        address: data.address,
        city: data.city,
        imageUrl: '',
        rating: 0,
        reviewCount: 0,
        phone: data.phone,
        description: data.description,
        openingHour: data.openingHour,
        closingHour: data.closingHour,
        closedWeekdays: data.closedWeekdays,
        closedDates: [],
        active: true,
        createdAt: FieldValue.serverTimestamp(),
      });

      transaction.create(privateSalonRef, {
        taxIdType: data.taxIdType,
        taxId: data.taxId,
        createdAt: FieldValue.serverTimestamp(),
      });

      transaction.create(userRef, {
        id: uid,
        name: data.ownerName,
        email: authenticatedEmail,
        phone: data.phone,
        role: 'admin',
        salonId: uid,
        createdAt: FieldValue.serverTimestamp(),
      });
    });

    return {
      ok: true,
      salonId: uid,
    };
  } catch (error) {
    if (error instanceof HttpsError) {
      throw error;
    }

    console.error(
      'registerSalon failed:',
      error,
    );

    throw new HttpsError(
      'internal',
      'Unable to provision salon account.',
    );
  }
});