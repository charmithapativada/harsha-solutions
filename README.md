# HARSHA PERFECT SOLUTIONS Ticket Raising & Management System

## Overview
A modern enterprise‑grade web application that allows **Clients** to raise support tickets, **Admins** to manage and assign tickets, and **Developers** to track progress. The system uses:
- **Frontend**: HTML5, CSS3, JavaScript (responsive UI with dark theme, glassmorphism, animations)
- **Backend**: Java Spring Boot (REST APIs)
- **Database**: MySQL
- **Security**: JWT based authentication with role‑based access control

## Features
- Beautiful landing, login and signup pages
- Role‑based dashboards (Admin / Client / Developer)
- Ticket creation with rich form (including screenshot upload)
- Admin ticket assignment, status workflow, analytics
- Developer ticket view, progress updates, comments
- Responsive design, dark theme, charts (Chart.js)

## Getting Started
1. **Prerequisites**: JDK 17+, Maven, MySQL
2. Clone / copy this project folder.
3. Create a MySQL DB `ticket_system` and run `src/main/resources/schema.sql`.
4. Update `src/main/resources/application.properties` with your DB credentials.
5. Build and run:
   ```bash
   cd harsha-ticket-system
   mvn spring-boot:run
   ```
6. Open `http://localhost:8080` in a browser.

---
*All source files are placed under the `harsha-ticket-system` directory as described in the project structure.*
