# 📡 API DOCUMENTATION - HARSHA TICKET MANAGEMENT SYSTEM

## Base URL
```
http://localhost:8080/api
```

## Authentication
All endpoints (except `/auth/*`) require JWT token in header:
```
Authorization: Bearer <JWT_TOKEN>
```

---

## 🔐 AUTH ENDPOINTS

### 1. Login
```
POST /auth/login
Content-Type: application/json

Request:
{
  "username": "admin",
  "password": "admin123"
}

Response (200 OK):
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@harshaperfect.com",
    "role": "ADMIN",
    "firstName": "Admin",
    "lastName": "User",
    "isActive": true
  },
  "message": "Login successful"
}

Error (401 Unauthorized):
{
  "success": false,
  "message": "Invalid username or password"
}
```

### 2. Signup (User Registration)
```
POST /auth/signup
Content-Type: application/json

Request:
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "username": "johndoe",
  "password": "password123",
  "phone": "+91-XXXXXXXXXX",
  "department": "Engineering"
}

Response (201 Created):
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "user": {
    "id": 4,
    "username": "johndoe",
    "email": "john@example.com",
    "role": "CLIENT",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+91-XXXXXXXXXX",
    "department": "Engineering",
    "isActive": true
  },
  "message": "Signup successful"
}

Error (400 Bad Request):
{
  "success": false,
  "message": "Email already exists"
}
```

---

## 🎫 TICKET ENDPOINTS

### 1. Create Ticket
```
POST /tickets
Authorization: Bearer <TOKEN>
Content-Type: application/json

Request:
{
  "title": "Login page not loading",
  "description": "The login page shows a blank screen when accessed",
  "category": "Bug",
  "priority": "HIGH"
}

Response (201 Created):
{
  "success": true,
  "message": "Ticket created successfully",
  "data": {
    "id": 1,
    "ticketId": "TKT-1716805600-5421",
    "title": "Login page not loading",
    "description": "The login page shows a blank screen when accessed",
    "priority": "HIGH",
    "status": "OPEN",
    "category": "Bug",
    "createdAt": "2024-05-27 10:30:00",
    "updatedAt": "2024-05-27 10:30:00",
    "resolvedAt": null
  }
}
```

### 2. Get All Tickets
```
GET /tickets
Authorization: Bearer <TOKEN>

Response (200 OK):
{
  "success": true,
  "message": "Tickets retrieved successfully",
  "data": [
    {
      "id": 1,
      "ticketId": "TKT-1716805600-5421",
      "title": "Login page not loading",
      "status": "OPEN",
      "priority": "HIGH",
      ...
    },
    ...
  ]
}
```

### 3. Get Ticket by ID
```
GET /tickets/{ticketId}
Authorization: Bearer <TOKEN>

Response (200 OK):
{
  "success": true,
  "message": "Ticket retrieved successfully",
  "data": {
    "id": 1,
    "ticketId": "TKT-1716805600-5421",
    "title": "Login page not loading",
    ...
  }
}
```

### 4. Get Ticket by Ticket Number
```
GET /tickets/number/{ticketNumber}
Authorization: Bearer <TOKEN>

Example: GET /tickets/number/TKT-1716805600-5421
```

### 5. Get My Tickets (Client)
```
GET /tickets/my-tickets
Authorization: Bearer <TOKEN>

Returns only tickets created by the authenticated user
```

### 6. Get Assigned Tickets (Developer)
```
GET /tickets/assigned
Authorization: Bearer <TOKEN>

Returns only tickets assigned to the authenticated developer
```

### 7. Get Open Tickets
```
GET /tickets/open
Authorization: Bearer <TOKEN>

Returns all tickets with status OPEN
```

### 8. Update Ticket
```
PUT /tickets/{ticketId}
Authorization: Bearer <TOKEN>
Content-Type: application/json

Request:
{
  "title": "Updated title",
  "description": "Updated description",
  "status": "IN_PROGRESS",
  "assignedToId": 2,
  "category": "Bug"
}

Response (200 OK):
{
  "success": true,
  "message": "Ticket updated successfully",
  "data": {
    "id": 1,
    "ticketId": "TKT-1716805600-5421",
    "title": "Updated title",
    "status": "IN_PROGRESS",
    ...
  }
}
```

### 9. Delete Ticket
```
DELETE /tickets/{ticketId}
Authorization: Bearer <TOKEN>

Response (200 OK):
{
  "success": true,
  "message": "Ticket deleted successfully"
}
```

---

## 💬 TICKET COMMENT ENDPOINTS

### 1. Add Comment
```
POST /tickets/{ticketId}/comments
Authorization: Bearer <TOKEN>
Content-Type: application/json

Request:
{
  "comment": "I've started working on this issue"
}

Response (201 Created):
{
  "success": true,
  "message": "Comment added successfully",
  "data": {
    "id": 1,
    "ticketId": 1,
    "user": {
      "id": 2,
      "username": "developer",
      ...
    },
    "comment": "I've started working on this issue",
    "createdAt": "2024-05-27 10:35:00"
  }
}
```

### 2. Get Comments
```
GET /tickets/{ticketId}/comments
Authorization: Bearer <TOKEN>

Response (200 OK):
{
  "success": true,
  "message": "Comments retrieved successfully",
  "data": [
    {
      "id": 1,
      "ticketId": 1,
      "user": {...},
      "comment": "I've started working on this issue",
      "createdAt": "2024-05-27 10:35:00"
    },
    ...
  ]
}
```

### 3. Delete Comment
```
DELETE /tickets/{ticketId}/comments/{commentId}
Authorization: Bearer <TOKEN>

Response (200 OK):
{
  "success": true,
  "message": "Comment deleted successfully"
}
```

---

## 👨‍💼 ADMIN ENDPOINTS

### 1. Get All Users
```
GET /admin/users
Authorization: Bearer <TOKEN>
Role: ADMIN only

Response (200 OK):
{
  "success": true,
  "message": "Users retrieved successfully",
  "data": [
    {
      "id": 1,
      "username": "admin",
      "email": "admin@harshaperfect.com",
      "role": "ADMIN",
      "firstName": "Admin",
      "lastName": "User",
      "phone": "...",
      "department": "Administration",
      "isActive": true
    },
    ...
  ]
}
```

### 2. Get All Developers
```
GET /admin/developers
Authorization: Bearer <TOKEN>
Role: ADMIN only

Response (200 OK):
{
  "success": true,
  "message": "Developers retrieved successfully",
  "data": [
    {
      "id": 2,
      "username": "developer",
      "email": "dev@harshaperfect.com",
      "role": "DEVELOPER",
      ...
    },
    ...
  ]
}
```

### 3. Get Dashboard Statistics
```
GET /admin/dashboard-stats
Authorization: Bearer <TOKEN>
Role: ADMIN only

Response (200 OK):
{
  "success": true,
  "message": "Dashboard statistics retrieved successfully",
  "data": {
    "totalTickets": 15,
    "totalUsers": 5,
    "totalAdmins": 1,
    "totalDevelopers": 2,
    "totalClients": 2,
    "activeUsers": 4
  }
}
```

---

## ⚠️ HTTP STATUS CODES

| Code | Meaning |
|------|---------|
| 200 | OK - Request successful |
| 201 | Created - Resource created successfully |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing or invalid token |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 500 | Internal Server Error - Server error |

---

## 🚨 ERROR RESPONSES

### Authentication Error
```json
{
  "success": false,
  "message": "User not found: username"
}
```

### Authorization Error
```json
{
  "success": false,
  "message": "Access Denied"
}
```

### Validation Error
```json
{
  "success": false,
  "message": "Invalid input data"
}
```

### Resource Not Found
```json
{
  "success": false,
  "message": "Ticket not found"
}
```

---

## 📝 TICKET PRIORITY LEVELS

```
CRITICAL - Needs immediate attention
HIGH     - Should be worked on soon
MEDIUM   - Standard priority (default)
LOW      - Can be deferred
```

---

## 📊 TICKET STATUS VALUES

```
OPEN         - Newly created ticket
IN_PROGRESS  - Being worked on by developer
RESOLVED     - Fixed by developer
CLOSED       - Confirmed and closed by client
ON_HOLD      - Paused for various reasons
```

---

## 🔑 USER ROLES

```
ADMIN     - Full system access
DEVELOPER - Can work on assigned tickets
CLIENT    - Can create and view own tickets
```

---

## 🧪 TESTING WITH CURL

### Login Example
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### Get Tickets Example
```bash
curl -X GET http://localhost:8080/api/tickets \
  -H "Authorization: Bearer <JWT_TOKEN>"
```

### Create Ticket Example
```bash
curl -X POST http://localhost:8080/api/tickets \
  -H "Authorization: Bearer <JWT_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "title":"Test Ticket",
    "description":"This is a test",
    "priority":"MEDIUM",
    "category":"Bug"
  }'
```

---

## 🔄 REQUEST/RESPONSE FLOW

```
1. Client sends login request
           ↓
2. Server validates credentials
           ↓
3. Server generates JWT token
           ↓
4. Client stores token in localStorage
           ↓
5. Client includes token in all subsequent requests
           ↓
6. Server validates token
           ↓
7. Server processes request and responds
           ↓
8. Client updates UI with response data
```

---

**API Version:** 1.0.0  
**Last Updated:** May 27, 2024  
**Created by:** HARSHA Development Team
