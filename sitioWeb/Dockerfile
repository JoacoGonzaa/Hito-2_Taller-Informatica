FROM node:18-alpine

WORKDIR /usr/src/app

# Copia los archivos de configuración de dependencias
COPY package*.json ./
RUN npm install express

# Copia el servidor de Node.js
COPY server.js ./

# Crea la carpeta public dentro del contenedor y copia tus archivos web
RUN mkdir public
COPY public/index.html ./public/
COPY public/styles.css ./public/
COPY public/pago.html ./public/

EXPOSE 80

CMD [ "node", "server.js" ]