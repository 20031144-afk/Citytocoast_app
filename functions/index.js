require('dotenv').config();
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const Stripe = require('stripe');

admin.initializeApp();

const stripeSecret =
  process.env.STRIPE_SECRET_KEY || functions.config().stripe?.secret_key;

const db = admin.firestore();

async function getOrCreateCustomerId(uid, stripe) {
  const userRef = db.collection('users').doc(uid);
  const userSnap = await userRef.get();
  const existingId = userSnap.exists ? userSnap.data().stripeCustomerId : null;
  if (existingId) {
    return existingId;
  }

  const customer = await stripe.customers.create({
    metadata: { uid },
  });
  await userRef.set({ stripeCustomerId: customer.id }, { merge: true });
  return customer.id;
}

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated.'
    );
  }
  if (!stripeSecret) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Stripe secret key is not configured.'
    );
  }

  const stripe = new Stripe(stripeSecret, { apiVersion: '2024-06-20' });

  const rawAmount = Number(data.amount);
  const amount = Math.round(rawAmount);
  const currency = String(data.currency || 'aud').toLowerCase();

  if (!Number.isFinite(rawAmount) || amount <= 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Invalid amount.');
  }

  const uid = context.auth.uid;
  const requestedPaymentMethodId = data.paymentMethodId || null;

  try {
    const customerId = await getOrCreateCustomerId(uid, stripe);

    // 2) Create ephemeral key for PaymentSheet
    const ephKey = await stripe.ephemeralKeys.create(
      { customer: customerId },
      { apiVersion: '2024-06-20' }
    );

    // 3) Create payment intent
    const intent = await stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency,
      customer: customerId,
      automatic_payment_methods: { enabled: true },
      payment_method: requestedPaymentMethodId || undefined,
      metadata: {
        uid,
        sitterId: data.sitterId || '',
        date: data.date || '',
        time: data.time || '',
      },
    });

    return {
      clientSecret: intent.client_secret,
      paymentIntentId: intent.id,
      customerId,
      ephemeralKey: ephKey.secret,
    };
  } catch (err) {
    console.error('createPaymentIntent error', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Unable to create payment intent.'
    );
  }
});

exports.createSetupIntent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated.'
    );
  }
  if (!stripeSecret) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Stripe secret key is not configured.'
    );
  }

  const stripe = new Stripe(stripeSecret, { apiVersion: '2024-06-20' });
  const uid = context.auth.uid;

  try {
    const customerId = await getOrCreateCustomerId(uid, stripe);

    const ephKey = await stripe.ephemeralKeys.create(
      { customer: customerId },
      { apiVersion: '2024-06-20' }
    );

    const setupIntent = await stripe.setupIntents.create({
      customer: customerId,
      payment_method_types: ['card'],
      usage: 'off_session',
      metadata: { uid },
    });

    return {
      setupIntentClientSecret: setupIntent.client_secret,
      customerId,
      ephemeralKey: ephKey.secret,
    };
  } catch (err) {
    console.error('createSetupIntent error', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Unable to create setup intent.'
    );
  }
});

// Emulator-only helper for fetching a saved card summary after SetupIntent.
exports.getSavedCardSummary = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated.'
    );
  }
  if (!stripeSecret) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Stripe secret key is not configured.'
    );
  }

  const stripe = new Stripe(stripeSecret, { apiVersion: '2024-06-20' });
  const customerId = data.customerId;
  if (!customerId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'customerId is required.'
    );
  }

  try {
    const paymentMethods = await stripe.paymentMethods.list({
      customer: customerId,
      type: 'card',
      limit: 1,
    });

    const card = paymentMethods.data[0]?.card;
    if (!card) {
      return { brand: 'Card', last4: '****' };
    }

    return {
      brand: card.brand || 'Card',
      last4: card.last4 || '****',
    };
  } catch (err) {
    console.error('getSavedCardSummary error', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Unable to fetch saved card.'
    );
  }
});

exports.listPaymentMethods = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated.'
    );
  }
  if (!stripeSecret) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Stripe secret key is not configured.'
    );
  }

  const stripe = new Stripe(stripeSecret, { apiVersion: '2024-06-20' });
  const customerId = data.customerId;
  if (!customerId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'customerId is required.'
    );
  }

  try {
    const paymentMethods = await stripe.paymentMethods.list({
      customer: customerId,
      type: 'card',
      limit: 10,
    });

    return paymentMethods.data.map((pm) => ({
      paymentMethodId: pm.id,
      brand: pm.card?.brand || 'card',
      last4: pm.card?.last4 || '****',
      expMonth: pm.card?.exp_month || 0,
      expYear: pm.card?.exp_year || 0,
    }));
  } catch (err) {
    console.error('listPaymentMethods error', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Unable to list payment methods.'
    );
  }
});

exports.detachPaymentMethod = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated.'
    );
  }
  if (!stripeSecret) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'Stripe secret key is not configured.'
    );
  }

  const stripe = new Stripe(stripeSecret, { apiVersion: '2024-06-20' });
  const paymentMethodId = data.paymentMethodId;
  if (!paymentMethodId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'paymentMethodId is required.'
    );
  }

  try {
    await stripe.paymentMethods.detach(paymentMethodId);
    return { ok: true };
  } catch (err) {
    console.error('detachPaymentMethod error', err);
    throw new functions.https.HttpsError(
      'internal',
      err.message || 'Unable to detach payment method.'
    );
  }
});
