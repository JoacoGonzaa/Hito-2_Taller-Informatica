const express = require('express');
const path = require('path');
const app = express();
const PORT = 80;

// Permitir que el backend entienda datos en formato JSON y formularios
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Servir los archivos estáticos de la carpeta public (index.html, pago.html, styles.css, etc.)
app.use(express.static(path.join(__dirname, 'public')));

// RUTA DEL BACKEND: Simulación de la sección de pago
app.post('/api/pagar', (req, res) => {
    // Ahora también recibimos el arreglo de 'items' desde el frontend
    const { nombre, tarjeta, total, items } = req.body;

    // Validación simple de datos obligatorios
    if (!nombre || !tarjeta || !total) {
        return res.status(400).json({ 
            status: "error", 
            mensaje: "Faltan datos obligatorios para procesar el pago." 
        });
    }

    // Opcional: Mostrar en los logs de AWS (CloudWatch) el pedido que acaba de entrar
    console.log(`=== NUEVA ORDEN RECIBIDA ===`);
    console.log(`Cliente: ${nombre}`);
    console.log(`Monto: $${parseInt(total).toLocaleString("es-CL")}`);
    if (items && items.length > 0) {
        console.log("Detalle del pedido:");
        items.forEach(item => {
            console.log(` - ${item.nombre} x${item.cantidad} ($${(item.precio * item.cantidad).toLocaleString("es-CL")})`);
        });
    } else {
        console.log("Detalle del pedido: No especificado.");
    }
    console.log(`============================`);

    // Respuesta ficticia de éxito de Transbank
    res.json({
        status: "aprobado",
        transaccion_id: "TX-" + Math.floor(Math.random() * 1000000),
        mensaje: `¡Gracias ${nombre}! Tu pago de $${parseInt(total).toLocaleString("es-CL")} por tu pedido de Café del Sur fue procesado con éxito.`
    });
});

app.listen(PORT, () => {
    console.log(`Servidor de Café del Sur corriendo en el puerto ${PORT}`);
});