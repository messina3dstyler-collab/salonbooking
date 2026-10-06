const {
  HttpsError,
} = require('firebase-functions/v2/https');

const {
  FieldValue,
  Timestamp,
} = require('firebase-admin/firestore');

const SLOT_MINUTES = 30;

const APPOINTMENT_STATUS_PENDING = 'Prenotata';

/**
 * =========================================================
 * VALIDAZIONE BASE
 * =========================================================
 */

function requireString(value, fieldName) {
  if (
    typeof value !== 'string' ||
    value.trim() === ''
  ) {
    throw new HttpsError(
      'invalid-argument',
      `${fieldName} is required.`,
    );
  }

  return value.trim();
}

function requireInteger(value, fieldName) {
  if (!Number.isInteger(value)) {
    throw new HttpsError(
      'invalid-argument',
      `${fieldName} must be an integer.`,
    );
  }

  return value;
}

/**
 * =========================================================
 * TEMPORAL CONTRACT - OPTION A
 * =========================================================
 *
 * Il client propone:
 *
 * - localDate: YYYY-MM-DD
 * - localTime: HH:mm
 * - timezoneOffsetMinutes: offset locale rispetto a UTC
 * - timestampMillis: istante UTC corrispondente
 *
 * Il backend NON introduce una timezone geografica.
 *
 * localDate/localTime rappresentano il tempo commerciale
 * dell'appuntamento.
 *
 * timestampMillis viene utilizzato per verificare che
 * l'istante inviato sia coerente con data/ora locale
 * + offset dichiarato.
 *
 * Il canonical slot ID viene costruito utilizzando
 * esclusivamente localDate/localTime.
 */

/**
 * Valida localDate e restituisce anche i componenti
 * numerici necessari al resto del workflow.
 */
function validateLocalDate(value) {
  const localDate = requireString(
    value,
    'localDate',
  );

  if (
    !/^\d{4}-\d{2}-\d{2}$/.test(
      localDate,
    )
  ) {
    throw new HttpsError(
      'invalid-argument',
      'localDate must use YYYY-MM-DD format.',
    );
  }

  const [
    year,
    month,
    day,
  ] = localDate
    .split('-')
    .map(Number);

  if (
    month < 1 ||
    month > 12 ||
    day < 1 ||
    day > 31
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid localDate.',
    );
  }

  const probe = new Date(
    Date.UTC(
      year,
      month - 1,
      day,
    ),
  );

  if (
    probe.getUTCFullYear() !== year ||
    probe.getUTCMonth() !== month - 1 ||
    probe.getUTCDate() !== day
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid localDate.',
    );
  }

  return {
    value: localDate,
    year,
    month,
    day,
  };
}

/**
 * Valida localTime.
 *
 * Il sistema utilizza slot da 30 minuti.
 */
function validateLocalTime(value) {
  const localTime = requireString(
    value,
    'localTime',
  );

  if (
    !/^\d{2}:\d{2}$/.test(
      localTime,
    )
  ) {
    throw new HttpsError(
      'invalid-argument',
      'localTime must use HH:mm format.',
    );
  }

  const [
    hour,
    minute,
  ] = localTime
    .split(':')
    .map(Number);

  if (
    hour < 0 ||
    hour > 23 ||
    minute < 0 ||
    minute > 59
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid localTime.',
    );
  }

  if (
    minute % SLOT_MINUTES !== 0
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Appointment time must use 30-minute slots.',
    );
  }

  return {
    value: localTime,
    hour,
    minute,
  };
}

/**
 * Valida l'offset rispetto a UTC.
 *
 * L'offset è un ponte temporale per mantenere la
 * compatibilità con l'attuale semantica locale.
 *
 * Non viene interpretato come timezone geografica.
 */
function validateTimezoneOffsetMinutes(value) {
  if (!Number.isInteger(value)) {
    throw new HttpsError(
      'invalid-argument',
      'timezoneOffsetMinutes must be an integer.',
    );
  }

  if (
    value < -14 * 60 ||
    value > 14 * 60
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Invalid timezoneOffsetMinutes.',
    );
  }

  return value;
}

/**
 * Valida l'istante UTC fornito dal client.
 */
function validateTimestampMillis(value) {
  if (
    !Number.isInteger(value) ||
    value <= 0
  ) {
    throw new HttpsError(
      'invalid-argument',
      'timestampMillis must be a positive integer.',
    );
  }

  return value;
}

/**
 * Costruisce l'istante UTC atteso partendo dalla
 * rappresentazione locale + offset.
 *
 * Esempio:
 *
 * 2026-09-30 10:00
 * offset +120
 *
 * =>
 * 2026-09-30T08:00:00.000Z
 */
function buildExpectedTimestampMillis({
  year,
  month,
  day,
  hour,
  minute,
  timezoneOffsetMinutes,
}) {
  const localAsUtcMillis = Date.UTC(
    year,
    month - 1,
    day,
    hour,
    minute,
    0,
    0,
  );

  return (
    localAsUtcMillis -
    timezoneOffsetMinutes *
      60 *
      1000
  );
}

/**
 * Valida l'intero contratto temporale.
 */
function validateTemporalContract(data) {
  const date = validateLocalDate(
    data.localDate,
  );

  const time = validateLocalTime(
    data.localTime,
  );

  const timezoneOffsetMinutes =
    validateTimezoneOffsetMinutes(
      data.timezoneOffsetMinutes,
    );

  const timestampMillis =
    validateTimestampMillis(
      data.timestampMillis,
    );

  const expectedTimestampMillis =
    buildExpectedTimestampMillis({
      year: date.year,
      month: date.month,
      day: date.day,
      hour: time.hour,
      minute: time.minute,
      timezoneOffsetMinutes,
    });

  if (
    timestampMillis !==
    expectedTimestampMillis
  ) {
    throw new HttpsError(
      'invalid-argument',
      'The temporal data is inconsistent.',
    );
  }

  return {
    localDate: date.value,
    localTime: time.value,
    year: date.year,
    month: date.month,
    day: date.day,
    hour: time.hour,
    minute: time.minute,
    timezoneOffsetMinutes,
    timestampMillis,
  };
}

/**
 * =========================================================
 * SLOT KEY
 * =========================================================
 *
 * Compatibile con AppointmentSlotKey.dart.
 *
 * Formato:
 *
 * <salon>_<employee>_YYYYMMDD_HHMM
 */
function sanitizeSlotPart(value) {
  return value
    .trim()
    .replaceAll('/', '_')
    .replaceAll(' ', '_');
}

function formatDateForSlotKey(
  year,
  month,
  day,
) {
  return (
    String(year).padStart(4, '0') +
    String(month).padStart(2, '0') +
    String(day).padStart(2, '0')
  );
}

function formatTimeForSlotKey(
  hour,
  minute,
) {
  return (
    String(hour).padStart(2, '0') +
    String(minute).padStart(2, '0')
  );
}

function buildSlotKey({
  salonId,
  employeeId,
  year,
  month,
  day,
  hour,
  minute,
}) {
  return (
    `${sanitizeSlotPart(salonId)}` +
    `_${sanitizeSlotPart(employeeId)}` +
    `_${formatDateForSlotKey(
      year,
      month,
      day,
    )}` +
    `_${formatTimeForSlotKey(
      hour,
      minute,
    )}`
  );
}

/**
 * =========================================================
 * SLOT GENERATION
 * =========================================================
 */

function buildSlotTimes({
  hour,
  minute,
  durationMinutes,
}) {
  if (
    !Number.isInteger(
      durationMinutes,
    ) ||
    durationMinutes <= 0
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The service duration is invalid.',
    );
  }

  const slotCount =
    Math.ceil(
      durationMinutes /
        SLOT_MINUTES,
    );

  const result = [];

  for (
    let index = 0;
    index < slotCount;
    index++
  ) {
    const totalMinutes =
      hour * 60 +
      minute +
      index * SLOT_MINUTES;

    const slotHour =
      Math.floor(
        totalMinutes / 60,
      );

    const slotMinute =
      totalMinutes % 60;

    /*
     * Una durata valida non deve produrre
     * uno slot oltre la mezzanotte.
     */
    if (
      slotHour > 23
    ) {
      throw new HttpsError(
        'failed-precondition',
        'The appointment cannot cross midnight.',
      );
    }

    result.push({
      hour: slotHour,
      minute: slotMinute,
    });
  }

  return result;
}

/**
 * =========================================================
 * EMPLOYEE VALIDATION
 * =========================================================
 */

function validateEmployeeBelongsToSalon({
  employee,
  salonId,
}) {
  const employeeSalonId =
    typeof employee.salonId === 'string'
      ? employee.salonId.trim()
      : '';

  if (
    employeeSalonId === '' ||
    employeeSalonId !== salonId
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The employee does not belong to the selected salon.',
    );
  }
}

function validateEmployeeIsActive(
  employee,
) {
  if (
    employee.active !== true
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The selected employee is not active.',
    );
  }
}

/**
 * =========================================================
 * EMPLOYEE SCHEDULE VALIDATION
 * =========================================================
 *
 * Replica la semantica di EmployeeModel:
 *
 * - workingDays
 * - startHour
 * - endHour
 * - breakStart
 * - breakEnd
 *
 * EmployeeModel.hasBreak è:
 *
 * breakEnd > breakStart
 */
function validateEmployeeSchedule({
  employee,
  year,
  month,
  day,
  hour,
  minute,
  durationMinutes,
}) {
  const workingDays =
    Array.isArray(
      employee.workingDays,
    )
      ? employee.workingDays
          .filter(
            (value) =>
              Number.isInteger(
                value,
              ),
          )
      : [];

  /*
   * JS:
   * 0 = Sunday
   *
   * Flutter DateTime.weekday:
   * 1 = Monday ... 7 = Sunday
   */
  const utcDate = new Date(
    Date.UTC(
      year,
      month - 1,
      day,
    ),
  );

  const jsDay =
    utcDate.getUTCDay();

  const flutterWeekday =
    jsDay === 0
      ? 7
      : jsDay;

  if (
    !workingDays.includes(
      flutterWeekday,
    )
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The employee does not work on the selected day.',
    );
  }

  const startHour =
    Number(employee.startHour);

  const endHour =
    Number(employee.endHour);

  if (
    !Number.isInteger(
      startHour,
    ) ||
    !Number.isInteger(
      endHour,
    ) ||
    startHour < 0 ||
    startHour > 23 ||
    endHour < 0 ||
    endHour > 23 ||
    endHour <= startHour
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The employee working hours are invalid.',
    );
  }

  const startMinutes =
    hour * 60 +
    minute;

  const endMinutes =
    startMinutes +
    durationMinutes;

  const openingMinutes =
    startHour * 60;

  const closingMinutes =
    endHour * 60;

  if (
    startMinutes <
      openingMinutes ||
    endMinutes >
      closingMinutes
  ) {
    throw new HttpsError(
      'failed-precondition',
      'The selected appointment is outside the employee working hours.',
    );
  }

  const breakStart =
    Number(employee.breakStart);

  const breakEnd =
    Number(employee.breakEnd);

  /*
   * EmployeeModel.hasBreak:
   *
   * breakEnd > breakStart
   *
   * Non assumiamo un campo Firestore "hasBreak",
   * perché tale campo non esiste nel modello persistito.
   */
  const hasBreak =
    Number.isInteger(
      breakStart,
    ) &&
    Number.isInteger(
      breakEnd,
    ) &&
    breakEnd > breakStart;

  if (!hasBreak) {
    return;
  }

  const overlapsBreak =
    startMinutes <
      breakEnd &&
    endMinutes >
      breakStart;

  if (overlapsBreak) {
    throw new HttpsError(
      'failed-precondition',
      'The selected appointment overlaps the employee break.',
    );
  }
}

/**
 * =========================================================
 * ATOMIC CUSTOMER APPOINTMENT CREATION
 * =========================================================
 *
 * Questo componente NON è ancora esportato da index.js.
 *
 * La callable verrà collegata in uno step successivo.
 *
 * Dipendenze passate dall'esterno:
 *
 * - db
 * - auth
 * - request
 */
async function createCustomerAppointment({
  db,
  auth,
  request,
}) {
  if (
    !request ||
    !request.auth
  ) {
    throw new HttpsError(
      'unauthenticated',
      'Authentication is required.',
    );
  }

  const uid =
    request.auth.uid;

  if (
    typeof uid !== 'string' ||
    uid.trim() === ''
  ) {
    throw new HttpsError(
      'unauthenticated',
      'Invalid authentication context.',
    );
  }

  const data =
    request.data;

  if (
    data === null ||
    typeof data !== 'object' ||
    Array.isArray(data)
  ) {
    throw new HttpsError(
      'invalid-argument',
      'Appointment data is required.',
    );
  }

  const salonId =
    requireString(
      data.salonId,
      'salonId',
    );

  const employeeId =
    requireString(
      data.employeeId,
      'employeeId',
    );

  const serviceId =
    requireString(
      data.serviceId,
      'serviceId',
    );

  const temporal =
    validateTemporalContract(
      data,
    );

  /**
   * -------------------------------------------------------
   * AUTH USER
   * -------------------------------------------------------
   */

  let authenticatedUser;

  try {
    authenticatedUser =
      await auth.getUser(
        uid,
      );
  } catch (error) {
    console.error(
      'Unable to load authenticated customer:',
      error,
    );

    throw new HttpsError(
      'internal',
      'Unable to verify authenticated user.',
    );
  }

  /**
   * -------------------------------------------------------
   * REFERENCES
   * -------------------------------------------------------
   */

  const salonRef =
    db
      .collection('salons')
      .doc(salonId);

  const employeeRef =
    salonRef
      .collection('employees')
      .doc(employeeId);

  const serviceRef =
    salonRef
      .collection('services')
      .doc(serviceId);

  /**
   * -------------------------------------------------------
   * TRANSACTION
   * -------------------------------------------------------
   */

  try {
    const result =
      await db.runTransaction(
        async (
          transaction,
        ) => {
          const salonSnapshot =
            await transaction.get(
              salonRef,
            );

          const employeeSnapshot =
            await transaction.get(
              employeeRef,
            );

          const serviceSnapshot =
            await transaction.get(
              serviceRef,
            );

          if (
            !salonSnapshot.exists
          ) {
            throw new HttpsError(
              'not-found',
              'Salon not found.',
            );
          }

          if (
            !employeeSnapshot.exists
          ) {
            throw new HttpsError(
              'not-found',
              'Employee not found.',
            );
          }

          if (
            !serviceSnapshot.exists
          ) {
            throw new HttpsError(
              'not-found',
              'Service not found.',
            );
          }

          const salon =
            salonSnapshot.data() ||
            {};

          const employee =
            employeeSnapshot.data() ||
            {};

          const service =
            serviceSnapshot.data() ||
            {};

          /**
           * -------------------------------------------------
           * EMPLOYEE OWNERSHIP / ACTIVE STATE
           * -------------------------------------------------
           */

          validateEmployeeBelongsToSalon({
            employee,
            salonId,
          });

          validateEmployeeIsActive(
            employee,
          );

          /**
           * -------------------------------------------------
           * SERVICE DATA IS AUTHORITATIVE
           * -------------------------------------------------
           */

          const duration =
            Number(
              service.duration,
            );

          const price =
            Number(
              service.price,
            );

          if (
            !Number.isInteger(
              duration,
            ) ||
            duration <= 0
          ) {
            throw new HttpsError(
              'failed-precondition',
              'The service duration is invalid.',
            );
          }

          if (
            duration >
            180
          ) {
            throw new HttpsError(
              'failed-precondition',
              'The service duration is too long.',
            );
          }

          if (
            !Number.isFinite(
              price,
            ) ||
            price < 0
          ) {
            throw new HttpsError(
              'failed-precondition',
              'The service price is invalid.',
            );
          }

          /**
           * -------------------------------------------------
           * EMPLOYEE SCHEDULE
           * -------------------------------------------------
           */

          validateEmployeeSchedule({
            employee,
            year:
              temporal.year,
            month:
              temporal.month,
            day:
              temporal.day,
            hour:
              temporal.hour,
            minute:
              temporal.minute,
            durationMinutes:
              duration,
          });

          /**
           * -------------------------------------------------
           * CANONICAL SLOT REFERENCES
           * -------------------------------------------------
           */

          const slotTimes =
            buildSlotTimes({
              hour:
                temporal.hour,
              minute:
                temporal.minute,
              durationMinutes:
                duration,
            });

          if (
            slotTimes.length ===
            0
          ) {
            throw new HttpsError(
              'failed-precondition',
              'No appointment slots were generated.',
            );
          }

          const slotRefs =
            slotTimes.map(
              (slot) => {
                const slotId =
                  buildSlotKey({
                    salonId,
                    employeeId,
                    year:
                      temporal.year,
                    month:
                      temporal.month,
                    day:
                      temporal.day,
                    hour:
                      slot.hour,
                    minute:
                      slot.minute,
                  });

                return {
                  id: slotId,
                  ref:
                    db
                      .collection(
                        'appointment_slots',
                      )
                      .doc(slotId),
                  hour:
                    slot.hour,
                  minute:
                    slot.minute,
                };
              },
            );

          /**
           * -------------------------------------------------
           * AVAILABILITY REFERENCES
           *
           * Devono avere lo stesso ID canonico
           * degli appointment_slots.
           * -------------------------------------------------
           */

          const availabilityRefs =
            slotRefs.map(
              (slot) => ({
                ...slot,
                ref:
                  db
                    .collection(
                      'appointment_availability',
                    )
                    .doc(
                      slot.id,
                    ),
              }),
            );

          /**
           * -------------------------------------------------
           * READ COLLISION STATE
           * -------------------------------------------------
           *
           * Tutte le letture avvengono prima delle scritture.
           */

          const slotSnapshots =
            await Promise.all(
              slotRefs.map(
                (slot) =>
                  transaction.get(
                    slot.ref,
                  ),
              ),
            );

          const availabilitySnapshots =
            await Promise.all(
              availabilityRefs.map(
                (slot) =>
                  transaction.get(
                    slot.ref,
                  ),
              ),
            );

          /**
           * -------------------------------------------------
           * COLLISION CHECK
           * -------------------------------------------------
           */

          const occupiedSlot =
            slotSnapshots.find(
              (
                snapshot,
              ) =>
                snapshot.exists,
            );

          if (
            occupiedSlot
          ) {
            throw new HttpsError(
              'already-exists',
              'The selected appointment time is no longer available.',
            );
          }

          const occupiedAvailability =
            availabilitySnapshots.find(
              (
                snapshot,
              ) =>
                snapshot.exists,
            );

          if (
            occupiedAvailability
          ) {
            throw new HttpsError(
              'already-exists',
              'The selected appointment time is no longer available.',
            );
          }

          /**
           * -------------------------------------------------
           * APPOINTMENT ID
           * -------------------------------------------------
           *
           * L'ID viene generato dal backend.
           */
          const appointmentRef =
            db
              .collection(
                'appointments',
              )
              .doc();

          /**
           * -------------------------------------------------
           * AUTHORITATIVE TIMESTAMP
           * -------------------------------------------------
           */

          const appointmentTimestamp =
            Timestamp.fromMillis(
              temporal.timestampMillis,
            );

          /**
           * -------------------------------------------------
           * APPOINTMENT DATA
           * -------------------------------------------------
           */

          const appointmentData = {
            userId:
              uid,

            salonId,

            salonName:
              typeof salon.name ===
              'string'
                ? salon.name
                : '',

            salonAddress:
              typeof salon.address ===
              'string'
                ? salon.address
                : '',

            customerName:
              typeof authenticatedUser
                .displayName ===
              'string'
                ? authenticatedUser
                    .displayName
                : '',

            customerPhone:
              typeof authenticatedUser
                .phoneNumber ===
              'string'
                ? authenticatedUser
                    .phoneNumber
                : '',

            employeeId,

            employeeName:
              typeof employee.name ===
              'string'
                ? employee.name
                : '',

            employeePhone:
              typeof employee.phone ===
              'string'
                ? employee.phone
                : '',

            employeeSpecialization:
              typeof employee
                .specialization ===
              'string'
                ? employee
                    .specialization
                : '',

            employeeRating:
              Number.isFinite(
                Number(
                  employee.rating,
                ),
              )
                ? Number(
                    employee.rating,
                  )
                : 0,

            serviceId,

            serviceName:
              typeof service.name ===
              'string'
                ? service.name
                : '',

            serviceDuration:
              duration,

            duration,

            price,

            date:
              appointmentTimestamp,

            /**
             * Temporal contract.
             *
             * Questi valori vengono scritti
             * dal backend dopo la validazione.
             */
            localDate:
              temporal.localDate,

            localTime:
              temporal.localTime,

            timezoneOffsetMinutes:
              temporal
                .timezoneOffsetMinutes,

            status:
              APPOINTMENT_STATUS_PENDING,

            createdAt:
              FieldValue
                .serverTimestamp(),

            updatedAt:
              FieldValue
                .serverTimestamp(),

            notes: '',

            reviewId: null,

            hasReview: false,

            acceptedRequestId:
              null,
          };

          /**
           * -------------------------------------------------
           * APPOINTMENT CREATE
           * -------------------------------------------------
           */

          transaction.create(
            appointmentRef,
            appointmentData,
          );

          /**
           * -------------------------------------------------
           * SLOT CREATE
           * -------------------------------------------------
           */

          for (
            let index = 0;
            index <
              slotRefs.length;
            index++
          ) {
            const slot =
              slotRefs[index];

            const slotTimestamp =
              Timestamp.fromMillis(
                buildExpectedTimestampMillis({
                  year:
                    temporal.year,
                  month:
                    temporal.month,
                  day:
                    temporal.day,
                  hour:
                    slot.hour,
                  minute:
                    slot.minute,
                  timezoneOffsetMinutes:
                    temporal
                      .timezoneOffsetMinutes,
                }),
              );

            transaction.create(
              slot.ref,
              {
                appointmentId:
                  appointmentRef.id,

                userId:
                  uid,

                salonId,

                employeeId,

                start:
                  slotTimestamp,

                createdAt:
                  FieldValue
                    .serverTimestamp(),
              },
            );
          }

          /**
           * -------------------------------------------------
           * AVAILABILITY CREATE
           * -------------------------------------------------
           */

          for (
            let index = 0;
            index <
              availabilityRefs.length;
            index++
          ) {
            const availability =
              availabilityRefs[
                index
              ];

            const slot =
              slotRefs[index];

            const slotTimestamp =
              Timestamp.fromMillis(
                buildExpectedTimestampMillis({
                  year:
                    temporal.year,
                  month:
                    temporal.month,
                  day:
                    temporal.day,
                  hour:
                    slot.hour,
                  minute:
                    slot.minute,
                  timezoneOffsetMinutes:
                    temporal
                      .timezoneOffsetMinutes,
                }),
              );

            transaction.create(
              availability.ref,
              {
                id:
                  availability.ref.id,

                salonId,

                employeeId,

                start:
                  slotTimestamp,
              },
            );
          }

          return {
            appointmentId:
              appointmentRef.id,

            slotIds:
              slotRefs.map(
                (slot) =>
                  slot.id,
              ),

            localDate:
              temporal.localDate,

            localTime:
              temporal.localTime,
          };
        },
      );

    return {
      ok: true,
      ...result,
    };
  } catch (error) {
    if (
      error instanceof HttpsError
    ) {
      throw error;
    }

    console.error(
      'createCustomerAppointment failed:',
      error,
    );

    throw new HttpsError(
      'internal',
      'Unable to create appointment.',
    );
  }
}

module.exports = {
  createCustomerAppointment,
};