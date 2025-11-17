# Pasos para iniciar Jenkins

## Iniciar Docker

## Crear la imagen

```bash
docker build -t jenkins-ansible:v1 .
```

## Crear en contenedor
```bash
docker run -d --name jenkins -p 8081:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -v ~/jenkins_home:/var/jenkins_home jenkins-ansible:v1
```

## Iniciar el contenedor de Jenkins

```bash
docker start jenkins
docker ps
```

## Conectandonos a Jenkins

```bash
docker exec -it jenkins bash
```
### Obteniendo el password
```bash
cat /var/jenkins_home/secrets/initialAdminPassword
```
## Agregando el archivo *.pem en Jenkins

- Nos dirigimos a: http://localhost:8081/manage/credentials/
- Clic en Nueva credencial
- En tipo elegimos: Secret file
- Para el nombre ponemos: clasesdevops-pem
- clic en el botón "Seleccionar archivo" y elegimos nuestro *.pem

### Autenticándonos en Jenkins

### 1. Ingresdamos el usuario: admin
### 2. Ingresamos el password rescatado

## Creando Tool Terraform en Jenkins
Nos vamos a la siguiente dirección
```
http://localhost:8081/manage/configureTools/
```
Nos vamos a la sección: instalaciones de Terraform
- Clic en "+ Añadir Terraform"
- En "name" ponemos: Terraform_1.13
- Nos aseguramos que esté marcado: Instalar automáticamente
- En el selplegable, elegimos: Terraform 1.13.4 (amd64)
- clic en: Save

# Creando nueva tarea en Jenkins

- Desde la página principal clic en "+ Nueva Tarea"
- Como nombre lo dejamos en: ProySpring-CICD
- Seleccionamos "Pipeline"
- Clic en OK

- En Definition elegimos: Pipeline script from SCM
- En SCM elegimos: Git
- En Repository URL agregamos: https://github.com/WinTux/20251105.git
- En Script path lo dejamos en: Jenkinsfile
- Clic en Save

## La estructura de este proyecto se vería así
```bash
.
├── ansible.cfg
├── clasesdevops.pem
├── Dockerfile
├── generar_inventario_3er_ejemplo.sh
├── generar_inventario_ini.sh
├── inventory2.ini
├── inventory.ini
├── Jenkinsfile
├── main.tf
├── main.yml
├── network.tf
├── outputs.tf
├── ProySpring
│   ├── mvnw
│   ├── mvnw.cmd
│   ├── pom.xml
│   └── src
│       ├── main
│       │   ├── java
│       │   │   └── com
│       │   │       └── pepe
│       │   │           └── ProySpring
│       │   │               ├── Controllers
│       │   │               │   └── UnicoController.java
│       │   │               └── ProySpringApplication.java
│       │   └── resources
│       │       └── application.properties
│       └── test
│           └── java
│               └── com
│                   └── pepe
│                       └── ProySpring
│                           └── ProySpringApplicationTests.java
├── README.md
├── roles
│   └── springboot
│       ├── files
│       │   └── ProySpring.jar
│       ├── handlers
│       │   └── main.yml
│       ├── tasks
│       │   └── main.yml
│       └── templates
│           └── springboot.service.j2
├── terraform.tfstate.d
│   └── prod
│       ├── terraform.tfstate
│       └── terraform.tfstate.backup
└── variables.tf
```
