function toggleDarkMode() {
    document.body.classList.toggle("dark-mode");

    // Get button
    let button = document.querySelector(".dark-mode-toggle");

    // Check current mode & set correct icon
    if (document.body.classList.contains("dark-mode")) {
        button.innerHTML = "🌙"; // Show Moon in Dark Mode
        localStorage.setItem("darkMode", "enabled");
    } else {
        button.innerHTML = "☀️"; // Show Sun in Light Mode
        localStorage.setItem("darkMode", "disabled");
    }
}

// Apply mode on page load (Default = Dark Mode)
if (localStorage.getItem("darkMode") !== "disabled") {
    document.body.classList.add("dark-mode");
    document.querySelector(".dark-mode-toggle").innerHTML = "🌙"; // Moon for Dark Mode
} else {
    document.querySelector(".dark-mode-toggle").innerHTML = "☀️"; // Sun for Light Mode
}
