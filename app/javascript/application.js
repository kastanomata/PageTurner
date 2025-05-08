// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import './navbar';

document.addEventListener('DOMContentLoaded', function() {
    const checkbox = document.querySelector('#user_is_curator');
    const iconSelect = document.querySelector('#user_curator_icon_id');
  
    function toggleIconSelect() {
      iconSelect.style.display = checkbox.checked ? 'block' : 'none';
    }
  
    if (checkbox) {
      checkbox.addEventListener('change', toggleIconSelect);
      toggleIconSelect(); // Initial check
    }
  });