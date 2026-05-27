document.addEventListener("DOMContentLoaded", function () {

    // ================= SIGNUP =================
    const signupForm = document.getElementById("signupForm");

    if (signupForm) {
        signupForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const user = {
                firstName: document.getElementById("firstName").value,
                lastName: document.getElementById("lastName").value,
                email: document.getElementById("signupEmail").value,
                username: document.getElementById("signupUsername").value,
                password: document.getElementById("signupPassword").value
            };

            localStorage.setItem("userAccount", JSON.stringify(user));

            alert("Account created successfully!");
            window.location.href = "login.html";
        });
    }


    // ================= LOGIN =================
    const loginForm = document.getElementById("loginForm");

    if (loginForm) {
        loginForm.addEventListener("submit", function (e) {
            e.preventDefault();

            const inputUser = document.getElementById("username").value;
            const inputPass = document.getElementById("password").value;

            const storedUser = JSON.parse(localStorage.getItem("userAccount"));

            // if no account created
            if (!storedUser) {
                alert("No account found. Please sign up first.");
                return;
            }

            // allow email OR username login
            if (
                (inputUser === storedUser.username || inputUser === storedUser.email) &&
                inputPass === storedUser.password
            ) {
                localStorage.setItem("authToken", "logged-in");

                alert("Login successful!");
                window.location.href = "dashboard.html";
            } else {
                alert("Invalid credentials!");
            }
        });
    }

});