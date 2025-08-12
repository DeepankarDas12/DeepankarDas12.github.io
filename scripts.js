function includeHTML() {
  var z, i, elmnt, file, xhttp;
  z = document.getElementsByTagName("*");
  for (i = 0; i < z.length; i++) {
    elmnt = z[i];
    file = elmnt.getAttribute("w3-include-html");
    if (file) {
      xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
          if (this.status == 200) {
            // Get the current page's filename (e.g., "homepage.html")
            var currentPage = window.location.pathname.split('/').pop();
            
            var tempDiv = document.createElement('div');
            tempDiv.innerHTML = this.responseText;

            // Find the link by iterating through all <a> elements
            var links = tempDiv.querySelectorAll('a');
            for (var j = 0; j < links.length; j++) {
              // Use getAttribute('href') to get the original, relative link value
              // Then, compare it to currentPage
              if (links[j].getAttribute('href') === currentPage) {
                var imageElement = links[j].querySelector('img');
                if (imageElement) {
                  imageElement.removeAttribute('id');
                }
              }
            }
            
            elmnt.innerHTML = tempDiv.innerHTML;
          }
          if (this.status == 404) {
            elmnt.innerHTML = "Page not found.";
          }
          elmnt.removeAttribute("w3-include-html");
          includeHTML();
        }
      }      
      xhttp.open("GET", file, true);
      xhttp.send();
      return;
    }
  }
};