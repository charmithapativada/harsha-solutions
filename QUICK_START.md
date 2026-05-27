# ⚡ QUICK START GUIDE - 5 MINUTES TO RUNNING SYSTEM

## Prerequisites Check
```bash
# Check Java
java -version
# Should be Java 17+

# Check MySQL
mysql --version
# Should be MySQL 8.0+

# Check Maven
mvn --version
# Should be Maven 3.8+
```

---

## 🚀 STEP-BY-STEP QUICK START

### Step 1: Setup Database (2 minutes)
```bash
# Open MySQL and create database
mysql -u root -p

# In MySQL client:
CREATE DATABASE harsha_ticket_db;
USE harsha_ticket_db;

# Import schema
source /path/to/database/harsha_ticket_db.sql;

# Verify (should show 6 tables)
SHOW TABLES;
```

### Step 2: Configure Backend (1 minute)
```bash
# Edit backend/src/main/resources/application.properties
# Update only these lines:

spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD
```

### Step 3: Start Backend (1 minute)
```bash
cd backend
mvn spring-boot:run

# Wait for message: "Tomcat started on port(s): 8080"
```

### Step 4: Start Frontend (1 minute)
```bash
# In a new terminal:
cd frontend

# Option 1: Python
python -m http.server 5500

# Option 2: Node
npx http-server . -p 5500
```

### Step 5: Access Application
```
Landing: http://localhost:5500
Login:   http://localhost:5500/login.html
Dashboard: http://localhost:5500/dashboard.html
```

### Step 6: Test with Demo Credentials
```
Admin Login:
Username: admin
Password: admin123

Developer Login:
Username: developer
Password: dev123

Client Login:
Username: client
Password: client123
```

---

## ✅ Verification Checklist

After startup, verify:

- [ ] Backend running on http://localhost:8080 (check terminal)
- [ ] Frontend accessible on http://localhost:5500
- [ ] Can login with admin credentials
- [ ] Dashboard loads without errors
- [ ] Can see "Tickets" in sidebar
- [ ] Profile shows logged-in user name

---

## 🐛 Quick Troubleshooting

| Problem | Fix |
|---------|-----|
| "Connection refused" | Start MySQL: `mysql.server start` |
| Port 8080 in use | `lsof -i :8080` then `kill <PID>` |
| Maven build fails | Delete `backend/.m2` folder, retry |
| Blank login page | Check browser console (F12) for errors |
| Can't login | Verify database imported correctly |
| CORS error | Backend might not be running |

---

## 📱 Features to Test

1. **Login** - Use admin/admin123
2. **Create Ticket** - Click "Raise Ticket" button
3. **View Tickets** - See dashboard tickets table
4. **Assign Ticket** - Click ticket, assign to developer
5. **Add Comment** - Click ticket, add comment
6. **View Profile** - Click profile icon in top-right
7. **Logout** - Click logout button

---

## 📊 System URLs

| Component | URL |
|-----------|-----|
| Landing Page | http://localhost:5500 |
| Login | http://localhost:5500/login.html |
| Dashboard | http://localhost:5500/dashboard.html |
| Backend API | http://localhost:8080/api |
| MySQL | localhost:3306 |

---

## 🔐 Demo Credentials Summary

| Role | User | Pass | Access |
|------|------|------|--------|
| Admin | admin | admin123 | All features |
| Developer | developer | dev123 | Assigned tickets |
| Client | client | client123 | Own tickets |

---

## 📁 Key File Locations

- **Database Schema:** `database/harsha_ticket_db.sql`
- **Backend Config:** `backend/src/main/resources/application.properties`
- **Frontend Files:** `frontend/` (HTML, CSS, JS)
- **API Docs:** `API_DOCUMENTATION.md` (in root)
- **Setup Guide:** `SETUP_GUIDE.md` (in root)

---

## 🎯 What's Included

✅ Full MySQL database with 6 tables  
✅ Spring Boot backend with 15+ API endpoints  
✅ JWT authentication and role-based access control  
✅ Modern UI with glassmorphism design  
✅ Ticket creation and management  
✅ Developer assignment system  
✅ Comments and activity tracking  
✅ Admin dashboard and analytics  
✅ Email notification infrastructure  
✅ File upload capabilities  

---

## 🚀 Production Checklist

- [ ] Change JWT secret in `application.properties`
- [ ] Use cloud MySQL database (AWS RDS, etc.)
- [ ] Deploy backend to cloud (Heroku, AWS, Google Cloud)
- [ ] Deploy frontend to CDN (Netlify, Vercel)
- [ ] Update CORS origins in backend
- [ ] Configure real SMTP for emails
- [ ] Set up HTTPS/SSL
- [ ] Configure database backups
- [ ] Add monitoring and logging

---

## 📞 Need Help?

Check these files:
1. **For full setup:** `SETUP_GUIDE.md`
2. **For API details:** `API_DOCUMENTATION.md`
3. **For errors:** Check `backend/logs/` directory

---

**You're all set! Happy coding! 🎉**

---

*Version 1.0.0 | HARSHA PERFECT SOLUTIONS | May 2024*
