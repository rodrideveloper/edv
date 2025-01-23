import { MercadoPagoConfig, Preference, Payment } from 'mercadopago';
import mercadopago from 'mercadopago';

import { fileURLToPath } from 'url';
import express from 'express';
import cors from 'cors';
import admin from 'firebase-admin';
import path from 'path';

import serviceAccount from './security-fb.json' assert { type: 'json' };
import dotenv from 'dotenv';
dotenv.config();


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const API_MERCADOPAGO_TOKEN = process.env.API_MERCADOPAGO_TOKEN;
const client = new MercadoPagoConfig({ accessToken: API_MERCADOPAGO_TOKEN });
const paymentApi = new Payment(client);

const PORT = process.env.PORT || 3000;
const BASE_URL = process.env.URL;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const buildPath = path.join(__dirname, 'web');



var app = express()

app.use(cors())
app.use(express.json());

app.use('/.well-known', express.static(path.join(__dirname, '.well-known')));
app.use('/privacypolicy', express.static(path.join(__dirname, 'privacypolicy.html')));
app.use('/deleteuser', express.static(path.join(__dirname, 'deleteuser.html')));


app.use(express.static(path.join(__dirname)));


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'welcome.html'));
});





app.use('/adminedv', express.static(buildPath));

app.get('/adminedv/*', (req, res) => {
    res.sendFile(path.join(buildPath, 'index.html'));
});

app.post('/create_preference', async (req, res) => {
    const preference = new Preference(client);

    const itemId = req.body.itemId;
    const title = req.body.title;
    const unitPrice = req.body.unitPrice;

    const userId = req.body.userId;
    const packId = req.body.packId;
    const lessons = req.body.lessons;
    const dueDays = req.body.dueDays;



    try {


        const response = await preference.create({
            body: {
                items: [
                    {
                        id: itemId,
                        title: title,
                        quantity: 1,
                        unit_price: unitPrice
                    },

                ],
                notification_url: 'https://estilodevidamdp.com.ar/webhook',
                back_urls: {
                    success: 'https://estilodevidamdp.com.ar/success',
                    failure: 'https://estilodevidamdp.com.ar/error',
                    pending: 'https://estilodevidamdp.com.ar/pending',
                },
                metadata: {
                    user_id: userId,
                    pack_id: packId,
                    lessons: lessons,
                    due_days: dueDays,
                },
                auto_return: 'approved',
            }
        })

        res.json({
            init_point: response.init_point,
        }

        );
    } catch (error) {
        console.log('error al crear preferencia')
        console.error(error);
        res.status(500).send('Error al crear la preferencia');
    }
});




app.post('/webhook', async (req, res) => {

    try {

        const notification = req.query;

        if (notification.type === 'payment.created') {

            res.status(200).send('Notificación payment.created procesada.');
            return;
        }


        if (notification.type === 'payment') {

            const paymentId = notification['data.id'];


            const paymentData = await paymentApi.get({
                id: paymentId,
            });


            if (paymentData.status === 'approved') {
                await updateClientState(paymentData);

                res.status(200).send('Pago procesado y estado actualizado en Firebase.');
            } else {
                res.status(200).send('Pago no aprobado, no se actualizó el estado.');
            }
        } else {
            res.status(400).send('Notificación no manejada.');
        }
    } catch (error) {
        console.error('Error al procesar el webhook:', error);
        res.status(500).send('Error interno del servidor.');
    }
});

app.post('/registerLesson', async (req, res) => {
    try {
        const userId = req.body.userId;
        const userName = req.body.userName;
        const userPhoto = req.body.userPhoto;
        const lesson = req.body.lesson;

        if (!userId) {
            return res.status(400).json({ message: 'userId es requerido.' });
        }

        const usersRef = admin.firestore().collection('users');
        const packsRef = usersRef.doc(userId).collection('packs');

        // Obtener la fecha y hora actuales
        const now = admin.firestore.Timestamp.now();

        // Obtener todos los packs del usuario
        const packsSnapshot = await packsRef.get();

        // Filtrar los packs activos con clases disponibles
        const activePacks = packsSnapshot.docs.filter(doc => {
            const data = doc.data();
            const dueDate = data.dueDate.toDate();
            const usedLessons = data.usedLessons || 0;
            const totalLessons = data.totalLessons || 0;

            return dueDate > now.toDate() && usedLessons < totalLessons;
        });

        if (activePacks.length === 0) {
            return res.status(400).json({ error: 'No hay packs activos con clases disponibles.' });
        }

        // Ordenar los packs por buyDate ascendente (más antiguo primero)
        activePacks.sort((a, b) => {
            return a.data().buyDate.toDate() - b.data().buyDate.toDate();
        });

        // Seleccionar el pack más antiguo
        const packDoc = activePacks[0];
        const packData = packDoc.data();
        const lessons = packData.totalLessons;
        const packId = packDoc.id;


        const packRef = packsRef.doc(packId);

        // Iniciar la transacción
        await admin.firestore().runTransaction(async (transaction) => {
            const packSnapshot = await transaction.get(packRef);

            if (!packSnapshot.exists) {
                throw new Error('El pack seleccionado no existe.');
            }

            const pack = packSnapshot.data();
            const usedLessons = pack.usedLessons || 0;
            const totalLessons = pack.totalLessons || 0;

            // Verificar que el pack no haya expirado
            if (pack.dueDate.toDate() <= now.toDate()) {
                throw new Error('El pack ha expirado.');
            }

            // Verificar que el usuario tenga clases disponibles
            if (usedLessons >= totalLessons) {
                throw new Error('No quedan clases disponibles en este pack.');
            }

            // Incrementar usedLessons en 1
            transaction.update(packRef, {
                usedLessons: admin.firestore.FieldValue.increment(1),
            });

            // Registrar la clase en la colección 'register_lesson'
            const registerLessonRef = admin.firestore().collection('register_lessons').doc();
            transaction.set(registerLessonRef, {
                userId: userId,
                packId: packId,
                userName: userName,
                userPhoto: userPhoto,
                lessons: lessons,
                register: lesson,
                date: admin.firestore.FieldValue.serverTimestamp(),
            });
        });

        // Enviar respuesta exitosa al cliente
        res.status(200).json({ message: 'Clase registrada exitosamente.', packId: packId });
    } catch (error) {
        console.error('Error al registrar la clase:', error.message);

        // Enviar respuesta de error al cliente
        if (error.message === 'El pack ha expirado.' ||
            error.message === 'No quedan clases disponibles en este pack.' ||
            error.message === 'No hay packs activos con clases disponibles.' ||
            error.message === 'El pack seleccionado no existe.') {
            res.status(400).json({ error: error.message });
        } else {
            res.status(500).json({ error: 'Error interno del servidor.' });
        }
    }
});


async function updateClientState(paymentData) {
    const userId = paymentData.metadata.user_id;
    const packId = paymentData.metadata.pack_id;
    const lessons = paymentData.metadata.lessons;
    const dueDays = paymentData.metadata.due_days;


    const purchaseDate = new Date();
    const expirationDate = new Date(purchaseDate);

    expirationDate.setDate(expirationDate.getDate() + dueDays);

    if (!userId) {
        throw new Error('userId not found.');
    }

    if (!packId) {
        throw new Error('packId not found.');
    }

    if (!lessons) {
        throw new Error('userId not found.');
    }
    if (!dueDays) {
        throw new Error('dueDays not found.');
    }
    try {
        const usersRef = admin.firestore().collection('users');
        const packRef = usersRef.doc(userId).collection('packs');


        await packRef.add({
            buyDate: admin.firestore.Timestamp.fromDate(purchaseDate),
            dueDate: admin.firestore.Timestamp.fromDate(expirationDate),
            packId: packId,
            totalLessons: lessons,
        });
    } catch (err) {
        console.log('Error upadted method')
        throw new Error(' Update pack error');

    }


}




app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});
