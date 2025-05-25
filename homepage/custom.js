/**
 * Repeats until element if found and runs callback with found result
 * @author TheRolf
 * @param {Function} Some function with a non-nullish positive result
 * @param {number} Total timeout to try
 * @param {Function} Function to call
 */
function waitForElementWithFunction(elementFunction, timeout, callback) {
  const startTime = Date.now();

  function checkElement() {
    const element = elementFunction();

    if (element) {
      callback(element);
    } else if (Date.now() - startTime < timeout) {
      setTimeout(checkElement, 100); // Check again in 100 milliseconds
    } else {
      console.error('Element not found within the specified timeout.');
      callback(undefined);
    }
  }

  checkElement();
}

/**
 * Creates html from string and appends it to current element
 * @author TheRolf
 * @param {String} str html string to append
 */
Element.prototype.appendHTML = function(str) {
  var div = document.createElement('div')
  
  div.innerHTML = str
  while (div.children.length > 0) {
    this.appendChild(div.children[0])
  }
}

function loadImageBg() {
  waitForElementWithFunction(() => document.getElementById('page_container'), 12000, (container) => {
    container.appendHTML(`<video autoplay muted loop style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; z-index: -1;">
      <source src="/images/galaxy.mp4" type="video/mp4">
        Your browser does not support the video tag.
      </video>
    `)
  })
}

window.onload = () => {
  loadImageBg();
}
