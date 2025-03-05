function toggleDarkMode() {
    document.body.classList.toggle("dark-mode");

    let button = document.querySelector(".dark-mode-toggle");

    if (document.body.classList.contains("dark-mode")) {
        button.innerHTML = "🌙";
        localStorage.setItem("darkMode", "enabled");
    } else {
        button.innerHTML = "☀️";
        localStorage.setItem("darkMode", "disabled");
    }
}

// Apply mode on page load (Default = Light Mode)
document.addEventListener("DOMContentLoaded", function () {
    if (localStorage.getItem("darkMode") === "enabled") {
        document.body.classList.add("dark-mode");
    }
    let button = document.querySelector(".dark-mode-toggle");
    if (button) {
        button.innerHTML = document.body.classList.contains("dark-mode") ? "🌙" : "☀️";
    }
});
