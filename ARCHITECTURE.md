# 🏗️ SYSTEM ARCHITECTURE & DEVELOPER GUIDE

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER (Frontend)                     │
│  ├─ HTML5 (index.html, login.html, signup.html, dashboard)    │
│  ├─ CSS3 (Glassmorphism, Dark theme, Responsive)              │
│  └─ JavaScript (ES6+, Fetch API, DOM Manipulation)            │
└──────────────────────┬──────────────────────────────────────────┘
                       │ HTTP/AJAX (Bearer Token)
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│              API LAYER (Spring Boot Controllers)                │
│  ├─ AuthController    (Login, Signup, User Management)         │
│  ├─ TicketController  (CRUD Operations)                        │
│  ├─ CommentController (Add/View/Delete Comments)               │
│  └─ AdminController   (Dashboard, User Management)             │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│            SERVICE LAYER (Business Logic)                       │
│  ├─ AuthService       (Authentication, Authorization)          │
│  ├─ TicketService     (Ticket Operations, Status Updates)      │
│  ├─ CommentService    (Comment Management)                      │
│  ├─ EmailService      (Notifications)                          │
│  └─ AnalyticsService  (Statistics)                             │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│        PERSISTENCE LAYER (Spring Data JPA)                      │
│  ├─ UserRepository                                              │
│  ├─ TicketRepository                                            │
│  ├─ CommentRepository                                           │
│  ├─ AttachmentRepository                                        │
│  ├─ ActivityLogRepository                                       │
│  └─ EmailNotificationRepository                                │
└──────────────────────┬──────────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────┐
│            DATA LAYER (MySQL Database)                          │
│  ├─ users table                                                 │
│  ├─ tickets table                                               │
│  ├─ ticket_comments table                                       │
│  ├─ ticket_attachments table                                    │
│  ├─ ticket_activity_logs table                                  │
│  └─ email_notifications table                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔐 Security Architecture

```
Request Flow with Security:
┌─────────────────────┐
│  HTTP Request       │
│  Authorization:     │
│  Bearer <TOKEN>     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  JwtAuthenticationFilter                │
│  ├─ Extract token from header           │
│  ├─ Validate token signature            │
│  └─ Check token expiration              │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  CustomUserDetailsService               │
│  ├─ Load user from database             │
│  ├─ Get user roles                      │
│  └─ Build UserDetails object            │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Authorization Check                    │
│  @PreAuthorize("hasRole('ADMIN')")      │
│  ├─ Check user role                     │
│  ├─ Verify permissions                  │
│  └─ Allow/Deny access                   │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Business Logic Execution               │
│  (Service methods)                      │
└──────────┬──────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Response (ApiResponse wrapper)         │
│  ├─ success: boolean                    │
│  ├─ message: String                     │
│  └─ data: Object                        │
└─────────────────────────────────────────┘
```

---

## 📦 Entity Relationships

```sql
User (1) ──────── (N) Ticket
 │                      │
 │                      ├──── (N) TicketComment
 │                      │
 │                      ├──── (N) TicketAttachment
 │                      │
 │                      └──── (N) TicketActivityLog
 │
 └──────── (N) TicketComment
 
 └──────── (N) TicketActivityLog
```

### Detailed Relationships

**User → Ticket**
- One user creates many tickets (as CLIENT)
- One user assigned many tickets (as DEVELOPER)

**Ticket → TicketComment**
- One ticket has many comments
- Each comment belongs to one user

**Ticket → TicketAttachment**
- One ticket has many file attachments
- Metadata stored in database

**Ticket → TicketActivityLog**
- One ticket has many activity logs
- Tracks all status and property changes

---

## 🔄 Request-Response Lifecycle

### Example: Create Ticket Request

```
1. Frontend (dashboard.js)
   │
   ├─ User clicks "Create Ticket"
   ├─ Form data collected
   └─ POST /api/tickets with Bearer token
   
2. Backend (JwtAuthenticationFilter)
   │
   ├─ Extract JWT from Authorization header
   ├─ Validate signature
   └─ Set SecurityContext
   
3. Backend (TicketController)
   │
   ├─ Receive CreateTicketRequest DTO
   ├─ Extract user from @AuthenticationPrincipal
   └─ Call ticketService.createTicket()
   
4. Backend (TicketService)
   │
   ├─ Generate ticket ID (TKT-timestamp-random)
   ├─ Create Ticket entity
   ├─ Set status to OPEN
   ├─ Log activity (NEW_TICKET)
   ├─ Send email notification
   ├─ Save to repository
   └─ Return TicketDTO
   
5. Backend (TicketRepository)
   │
   ├─ Execute INSERT SQL
   ├─ Update ticket_activity_logs
   └─ Return saved entity
   
6. Backend (Controller)
   │
   ├─ Wrap response in ApiResponse
   └─ Return 201 Created + JSON
   
7. Frontend (dashboard.js)
   │
   ├─ Receive response (201 status)
   ├─ Check response.success
   ├─ Update UI (show success message)
   ├─ Refresh tickets list
   └─ Clear form
```

---

## 🗄️ Database Schema Quick Reference

### Users Table
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DEVELOPER', 'CLIENT') NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    department VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Tickets Table
```sql
CREATE TABLE tickets (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ticket_id VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('CRITICAL', 'HIGH', 'MEDIUM', 'LOW') DEFAULT 'MEDIUM',
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'ON_HOLD') DEFAULT 'OPEN',
    category VARCHAR(50),
    client_id BIGINT NOT NULL,
    assigned_to_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (client_id) REFERENCES users(id),
    FOREIGN KEY (assigned_to_id) REFERENCES users(id),
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_created_at (created_at)
);
```

---

## 💻 Code Structure Examples

### Entity Example (User.java)
```java
@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Enumerated(EnumType.STRING)
    private UserRole role;
    
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL)
    private Set<Ticket> createdTickets;
}
```

### DTO Example (TicketDTO.java)
```java
@Data
@Builder
public class TicketDTO {
    private Long id;
    private String ticketId;
    private String title;
    private String description;
    private TicketStatus status;
    private TicketPriority priority;
    private Long clientId;
    private Long assignedToId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
```

### Repository Example (TicketRepository.java)
```java
public interface TicketRepository extends JpaRepository<Ticket, Long> {
    Optional<Ticket> findByTicketId(String ticketId);
    List<Ticket> findByClientId(Long clientId);
    List<Ticket> findByAssignedToId(Long developerId);
    List<Ticket> findByStatus(TicketStatus status);
}
```

### Service Example (TicketService.java)
```java
@Service
@Transactional
public class TicketService {
    public TicketDTO createTicket(Long clientId, CreateTicketRequest request) {
        Ticket ticket = new Ticket();
        ticket.setTicketId(TicketIdGenerator.generateTicketId());
        ticket.setTitle(request.getTitle());
        ticket.setStatus(TicketStatus.OPEN);
        
        // Save and return
        Ticket saved = ticketRepository.save(ticket);
        return mapToDTO(saved);
    }
}
```

### Controller Example (TicketController.java)
```java
@RestController
@RequestMapping("/api/tickets")
public class TicketController {
    
    @PostMapping
    public ResponseEntity<ApiResponse> createTicket(
            @RequestBody CreateTicketRequest request,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        TicketDTO ticketDTO = ticketService.createTicket(
            userDetails.getUser().getId(), 
            request
        );
        
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.builder()
                .success(true)
                .message("Ticket created successfully")
                .data(ticketDTO)
                .build());
    }
}
```

---

## 🔌 Frontend Integration Points

### Authentication Flow (auth.js)
```javascript
1. User enters credentials
2. Send POST /api/auth/login
3. Receive JWT token
4. Store token in localStorage
5. Redirect to dashboard.html

// Token usage in subsequent requests:
Authorization: Bearer <TOKEN>
```

### Dashboard Initialization (dashboard.js)
```javascript
1. On page load: checkAuth()
   ├─ Verify token exists
   ├─ Load user info from localStorage
   ├─ Show role-specific menu
   
2. Initialize dashboard: initializeDashboard()
   ├─ Load ticket statistics
   ├─ Render tickets table
   ├─ Setup event listeners
```

---

## 🚀 Deployment Topology

### Development Environment
```
Local Machine (All-in-one)
├─ Frontend: http://localhost:5500
├─ Backend: http://localhost:8080
└─ MySQL: localhost:3306
```

### Production Environment
```
Cloud Infrastructure
├─ Frontend CDN (Netlify/Vercel)
│  └─ Static files distributed globally
├─ Backend (AWS EC2/Heroku)
│  └─ Spring Boot application
└─ Database (AWS RDS/Azure MySQL)
   └─ Managed MySQL database
```

---

## 📊 Performance Considerations

### Database Optimization
- **Indexes:** Created on `status`, `priority`, `created_at`
- **Query Optimization:** Using Spring Data JPA named queries
- **Connection Pooling:** HikariCP (default with Spring Boot)

### Backend Optimization
- **Pagination:** Implement for large ticket lists
- **Caching:** Consider Redis for frequently accessed data
- **Async Processing:** Use @Async for email sending

### Frontend Optimization
- **Lazy Loading:** Load tickets on-demand
- **Caching:** Store data in localStorage/sessionStorage
- **Compression:** Minify CSS/JS in production

---

## 🔧 Common Customizations

### Adding New Ticket Field
1. Add column to `tickets` table (migration)
2. Add property to `Ticket.java` entity
3. Add field to `TicketDTO` class
4. Update `TicketController` endpoint
5. Update `dashboard.html` form
6. Update `dashboard.js` submission

### Adding New User Role
1. Add to `UserRole` enum
2. Create role-specific controller methods
3. Add `@PreAuthorize("hasRole('NEW_ROLE')")` decorators
4. Update frontend menu visibility

### Adding New Status
1. Add to `TicketStatus` enum
2. Update database ENUM column
3. Add status-specific logic to `TicketService`
4. Update frontend status badge colors

---

## 🧪 Testing Strategy

### Unit Tests (Services)
```java
@Test
public void testCreateTicket() {
    // Arrange
    CreateTicketRequest request = new CreateTicketRequest(...);
    
    // Act
    TicketDTO result = ticketService.createTicket(userId, request);
    
    // Assert
    assertThat(result.getStatus()).isEqualTo(TicketStatus.OPEN);
}
```

### Integration Tests (Controllers)
```java
@SpringBootTest
public class TicketControllerTest {
    @Test
    public void testCreateTicketEndpoint() {
        // Test full request-response cycle
    }
}
```

### Frontend Tests (Selenium/Cypress)
```javascript
describe('Login Flow', () => {
    it('should login with valid credentials', () => {
        cy.visit('login.html');
        cy.get('[name="username"]').type('admin');
        cy.get('[name="password"]').type('admin123');
        cy.get('button').click();
        cy.url().should('include', 'dashboard.html');
    });
});
```

---

## 📝 Development Workflow

1. **Feature Planning** - Define requirements
2. **Backend Development** - Create entity → repository → service → controller
3. **Database Migration** - Update schema if needed
4. **API Testing** - Test endpoints with Postman/curl
5. **Frontend Development** - Create HTML/CSS/JS
6. **Integration Testing** - End-to-end testing
7. **Performance Testing** - Load testing with JMeter
8. **Security Review** - Check for vulnerabilities
9. **Deployment** - Push to production

---

## 🎓 Learning Resources

- **Spring Boot:** https://spring.io/projects/spring-boot
- **JPA/Hibernate:** https://www.baeldung.com/
- **JWT:** https://jwt.io/
- **MySQL:** https://dev.mysql.com/doc/
- **REST API Best Practices:** https://restfulapi.net/

---

**Version:** 1.0.0  
**Last Updated:** May 27, 2024  
**Author:** HARSHA Development Team
