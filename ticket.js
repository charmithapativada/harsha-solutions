document.getElementById("ticketForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const ticket = {
        id: "TKT-" + Math.floor(Math.random() * 100000),
        title: document.getElementById("title").value,
        description: document.getElementById("description").value,
        priority: document.getElementById("priority").value,
        status: "OPEN"
    };

    let tickets = JSON.parse(localStorage.getItem("tickets")) || [];
    tickets.push(ticket);
    localStorage.setItem("tickets", JSON.stringify(tickets));

    alert("Ticket Created Successfully! ID: " + ticket.id);

    window.location.href = "dashboard.html";
});