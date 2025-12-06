window.addEventListener('DOMContentLoaded', function () {
  const dropdown = document.getElementById('questionDropdown');
  const input = document.getElementById('questionInput');
  const answerBox = document.getElementById('answerBox');
  const askButton = document.querySelector('button[onclick="sendQuestion()"]');

  function sendQuestion() {
    // Use input value, fallback to dropdown if input is empty and dropdown is not default
    let question = input.value.trim();
    if (!question && dropdown.selectedIndex > 0) {
      question = dropdown.value;
      input.value = question; // sync input for clarity
    }
    answerBox.innerText = "Thinking...\n";

    fetch("/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question: question })
    }).then(() => {
      const eventSource = new EventSource('/chat-stream');

      let responseText = "";
      eventSource.onmessage = (event) => {
        responseText += event.data;
        answerBox.innerText = responseText;
      };

      eventSource.onerror = (err) => {
        eventSource.close();
        console.error("Stream error:", err);
      };
    });
  }

  // Attach sendQuestion to button
  if (askButton) {
    askButton.onclick = sendQuestion;
  }

  // Dropdown to input sync
  if (dropdown && input) {
    dropdown.addEventListener('change', function () {
      if (dropdown.selectedIndex === 0) {
        input.value = "";
      } else {
        input.value = dropdown.value;
        input.focus();
      }
    });

    // Reset dropdown when input is focused or changed
    input.addEventListener('focus', function () {
      dropdown.selectedIndex = 0;
    });
    input.addEventListener('input', function () {
      dropdown.selectedIndex = 0;
    });
  }

  // Custom dropdown logic
  const customDropdown = document.getElementById('customDropdown');
  const dropdownSelected = document.getElementById('dropdownSelected');
  const dropdownOptions = document.getElementById('dropdownOptions');

  if (customDropdown && dropdownSelected && dropdownOptions && input) {
    dropdownSelected.addEventListener('click', function () {
      dropdownOptions.style.display = dropdownOptions.style.display === 'block' ? 'none' : 'block';
      customDropdown.classList.toggle('open');
    });

    dropdownOptions.querySelectorAll('li').forEach(function (option) {
      option.addEventListener('click', function () {
        dropdownSelected.textContent = option.textContent;
        dropdownOptions.style.display = 'none';
        customDropdown.classList.remove('open');
        input.value = option.textContent;
        input.focus();
      });
    });

    // Close dropdown if clicking outside
    document.addEventListener('click', function (e) {
      if (!customDropdown.contains(e.target)) {
        dropdownOptions.style.display = 'none';
        customDropdown.classList.remove('open');
      }
    });

    // Reset dropdown when input is focused or changed
    input.addEventListener('focus', function () {
      dropdownSelected.textContent = 'Select a sample question...';
    });
    input.addEventListener('input', function () {
      dropdownSelected.textContent = 'Select a sample question...';
    });
  }

  // Responsive input field
  function resizeInput() {
    input.style.fontSize = window.innerWidth < 500 ? '0.95rem' : '1rem';
    input.style.padding = window.innerWidth < 500 ? '0.7rem' : '1rem';
  }
  window.addEventListener('resize', resizeInput);
  resizeInput();
});
