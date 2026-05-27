// API Configuration
const API_BASE_URL = 'http://localhost:8080/api';

// Get Auth Token
const getAuthHeader = () => ({
    'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
    'Content-Type': 'application/json'
});

// Initialize Dashboard
document.addEventListener('DOMContentLoaded', function () {

    checkAuth();

    initializeDashboard();

    setupEventListeners();

});

// Check Authentication
function checkAuth() {

    let token = localStorage.getItem('authToken');

    let user = localStorage.getItem('user');

    // Temporary Demo Login
    if (!token || !user) {

        localStorage.setItem("authToken", "demo-token");

        localStorage.setItem("user", JSON.stringify({
            firstName: "Harsha",
            lastName: "User",
            role: "client"
        }));

        token = localStorage.getItem('authToken');

        user = localStorage.getItem('user');
    }

    const userData = JSON.parse(user);

    document.getElementById('userName').textContent =
        `${userData.firstName} ${userData.lastName}`;

    document.getElementById('userRole').textContent =
        userData.role;

    // Show sections based on role
    const role = userData.role.toLowerCase();

    if (role === 'client') {

        const clientSection =
            document.querySelector('.client-only');

        if (clientSection) {
            clientSection.style.display = 'block';
        }

    } else if (role === 'developer') {

        const developerSection =
            document.querySelector('.developer-only');

        if (developerSection) {
            developerSection.style.display = 'block';
        }

    } else if (role === 'admin') {

        const adminSection =
            document.querySelector('.admin-only');

        if (adminSection) {
            adminSection.style.display = 'block';
        }
    }
}

// Initialize Dashboard
function initializeDashboard() {

    // Dummy Stats
    document.getElementById('totalTickets').textContent = 24;

    document.getElementById('openTickets').textContent = 8;

    document.getElementById('inProgress').textContent = 10;

    document.getElementById('resolved').textContent = 6;

    loadDummyTickets();
}

// Load Dummy Tickets
function loadDummyTickets() {

    const tickets = [

        {
            ticketId: "TKT-101",
            title: "Login Page Error",
            priority: "HIGH",
            status: "OPEN",
            createdAt: new Date()
        },

        {
            ticketId: "TKT-102",
            title: "Dashboard Not Loading",
            priority: "MEDIUM",
            status: "IN_PROGRESS",
            createdAt: new Date()
        },

        {
            ticketId: "TKT-103",
            title: "CSS Styling Issue",
            priority: "LOW",
            status: "RESOLVED",
            createdAt: new Date()
        }

    ];

    displayTickets(tickets);
}

// Display Tickets
function displayTickets(tickets) {

    const allTicketsTable =
        document.getElementById('allTicketsTable');

    if (!allTicketsTable) return;

    const tableHtml = `

    <table style="width:100%; color:white; border-collapse:collapse;">

        <thead>

            <tr>

                <th>Ticket ID</th>

                <th>Title</th>

                <th>Priority</th>

                <th>Status</th>

                <th>Date</th>

            </tr>

        </thead>

        <tbody>

            ${tickets.map(ticket => `

                <tr>

                    <td>${ticket.ticketId}</td>

                    <td>${ticket.title}</td>

                    <td>${ticket.priority}</td>

                    <td>${ticket.status}</td>

                    <td>${new Date(ticket.createdAt)
                        .toLocaleDateString()}</td>

                </tr>

            `).join('')}

        </tbody>

    </table>

    `;

    allTicketsTable.innerHTML = tableHtml;
}

// Logout
function logout() {

    localStorage.removeItem('authToken');

    localStorage.removeItem('user');

    alert("Logged Out Successfully!");

    window.location.href = 'login.html';
}

// Setup Event Listeners
function setupEventListeners() {

    // Logout Button
    const logoutBtn =
        document.getElementById('logoutBtn');

    if (logoutBtn) {

        logoutBtn.addEventListener('click', function (e) {

            e.preventDefault();

            logout();

        });
    }

    // Navigation Links
    document.querySelectorAll('.nav-link')
        .forEach(link => {

            link.addEventListener('click', (e) => {

                const href =
                    link.getAttribute('href');

                if (href && href.startsWith('#')) {

                    e.preventDefault();

                    navigateToSection(href);

                }
            });

        });

}

// Navigate Sections
function navigateToSection(sectionId) {

    document.querySelectorAll('.nav-link')
        .forEach(link => {

            link.classList.remove('active');

        });

    const activeLink =
        document.querySelector(`[href="${sectionId}"]`);

    if (activeLink) {

        activeLink.classList.add('active');

    }

    document.getElementById('pageTitle').textContent =
        sectionId.replace('#', '')
            .replace(/-/g, ' ')
            .toUpperCase();
}