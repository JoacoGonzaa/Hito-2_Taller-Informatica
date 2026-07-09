const express = require('express');
const path = require('path');
const app = express();
const PORT = 80;

// Permitir que el backend entienda datos enviados desde formularios web
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir tus archivos estáticos (el HTML y CSS que ya tienes)
app.use(express.static(path.join(__dirname, 'public')));

// RUTA DEL BACKEND: Simulación de la sección de pago
app.post('/api/pagar', (req, res) => {
    const { nombre, tarjeta, total } = req.body;

    // Simulación de validación simple
    if (!nombre || !tarjeta) {
        return res.status(400).json({ 
            status: "error", 
            mensaje: "Faltan datos para procesar el pago." 
        });
    }

    // Respuesta ficticia de éxito
    res.json({
        status: "aprobado",
        transaccion_id: "TX-" + Math.floor(Math.random() * 1000000),
        mensaje: `¡Gracias ${nombre}! Tu pago de $${total} por el mejor Café del Sur fue procesado con éxito.`
    });
});

app.listen(PORT, () => {
    console.log(`Servidor de Café del Sur corriendo en el puerto ${PORT}`);
});