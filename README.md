# ☕ Café del Sur - MVP Desplegado en la Nube (Hito 2)

Este repositorio contiene el Producto Mínimo Viable (MVP) de la plataforma web **Café del Sur**, desplegado de manera automatizada y reproducible en **AWS** utilizando **Terraform** como herramienta de Infraestructura como Código (IaC).

El proyecto consta de una aplicación web interactiva en Node.js, con catálogo de productos y simulación de pasarela de pagos, montada sobre una arquitectura de contenedores altamente disponible y resiliente.

---

## 🏗️ Arquitectura en la Nube (AWS)

La infraestructura diseñada e implementada se compone de los siguientes servicios integrados:

* **VPC (Virtual Private Cloud):** Red lógica aislada con un bloque CIDR dedicado para garantizar el control y seguridad del tráfico.
* **Subredes Públicas (Multi-AZ):** Despliegue distribuido en dos zonas de disponibilidad de `us-east-1`, Subred A y Subred B, para asegurar alta disponibilidad.
* **Application Load Balancer (ALB):** Balanceador de carga que recibe las peticiones externas en el puerto 80 HTTP y distribuye el tráfico de manera equitativa entre los contenedores.
* **AWS ECS Fargate (Serverless Containers):** Orquestador de contenedores que ejecuta 2 réplicas de la imagen Docker sin necesidad de administrar servidores EC2.
* **AWS ECR (Elastic Container Registry):** Repositorio privado donde se almacena la imagen Docker de producción `cafe-del-sur:2.0`.
* **Security Groups:** Cortafuegos virtuales que limitan el acceso entrante únicamente a través del balanceador mediante el puerto HTTP estándar.

---

## ⚙️ Características Implementadas

1. **Aprovisionamiento Automatizado (IaC):**  
   Toda la red y los servicios de cómputo están declarados en archivos de Terraform `.tf`, permitiendo destruir y replicar el entorno con comandos simples.

2. **Resiliencia (Auto-Healing):**  
   Se configuró un **Health Check** activo en el Target Group del ALB que interroga la raíz de la aplicación cada 30 segundos. Si una tarea de ECS falla, el tráfico se redirige y Fargate aprovisiona un nuevo contenedor de manera automática.

3. **Seguridad y Mínimo Privilegio:**  
   * Uso de roles IAM específicos para la ejecución de tareas de ECS.
   * Exclusión estricta de credenciales, binarios locales `.terraform/` y archivos de estado `.tfstate` en el control de versiones usando un archivo `.gitignore` optimizado.

4. **Gestión de Costos:**  
   Dimensionamiento responsable de recursos en Fargate, utilizando 0.25 vCPU y 512 MB de RAM por contenedor, además de etiquetado sistemático `tags` en los recursos para seguimiento financiero.

---

## 🌐 URL del Proyecto

La aplicación se encuentra disponible en:

http://cafe-del-sur-alb-685753372.us-east-1.elb.amazonaws.com/

---

## 👥 Integrantes

* Alonso Duarte
* Joaquín González