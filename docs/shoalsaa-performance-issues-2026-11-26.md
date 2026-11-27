
# Shoalsaa performance issues 2026-11-26

The “Issues were logged in the Issues panel in Chrome DevTools” Lighthouse audit is a diagnostic flag, not a measurement of page speed. It means Chrome detected one or more browser-level problems while loading or using the page and recorded them in DevTools > Issues.

What it checks
Lighthouse loads the page and checks whether Chrome reports issues such as:

Mixed content — an HTTPS page requests an image, stylesheet, script, font, or other asset over HTTP.
Cookie problems — for example, third-party-cookie restrictions or missing security attributes.
Cross-origin / CORS problems — the browser blocks a script, font, API request, or other resource because the server does not allow that origin.
Security-policy problems — Content Security Policy (CSP) blocks a needed resource.
Deprecation or compatibility warnings — code relies on browser features Chrome plans to remove or change.
Other browser-detected page problems — the exact list depends on what Chrome observed during the audit.
It does not mean every recorded issue is a broken page feature, and it does not identify the WordPress plugin, theme, or custom code responsible by itself. Open the Issues panel and use the affected URL, script name, and issue description to trace the source.

Why it matters to the Lighthouse score
This audit is generally part of Best Practices, not the Performance score. A failing result can reduce that category because it signals a browser-detected quality, compatibility, privacy, or security concern.

Fixing it can still improve real-world performance and reliability when the underlying issue causes assets or API calls to fail. For example, missing files can produce 404 errors and make the server work harder, which can result in slower load times.

Do not treat it as a “get the score to 100” item only. DreamHost notes that Lighthouse audits cover performance, accessibility, SEO, and more, and recommends working through the listed issues rather than becoming overly focused on the score itself.

How to investigate and fix it on WordPress
Open the affected page in a Chrome Incognito window.

Open DevTools with Ctrl+Shift+I on Windows or Command+Option+I on Mac.

Select the Issues tab, reload the page, and expand each issue group.

Copy the exact affected resource URL and note whether it comes from WordPress core, your theme, a plugin, a CDN, an embedded service, or custom code.

Fix the issue type identified by Chrome before running Lighthouse again.

Clear any WordPress, CDN, and browser caches after publishing each change.

Re-run Lighthouse in Incognito mode and confirm that the Issues panel is clear or that only understood, non-actionable third-party warnings remain.

DreamHost recommends an Incognito test because browser extensions can interfere with Lighthouse analysis.

Concrete fixes by common issue type
Mixed content

Confirm that both WordPress Address (URL) and Site Address (URL) use https:// in WordPress > Settings > General.

Update old http:// links in posts, page-builder content, theme settings, widgets, image URLs, CSS, and custom scripts.

Replace or remove third-party embeds that only provide HTTP assets.

Configure HTTPS redirection for the site if needed.

Re-test the page and confirm all requested resources load over HTTPS.

DreamHost describes mixed content as images, scripts, or stylesheets loading through the old insecure HTTP protocol, including cases involving embedded videos. DreamHost also explains that HTTP links on a site with SSL can trigger a mixed-content warning.

For a non-DreamPress WordPress site, DreamHost documents an .htaccess HTTPS redirect option. Do not add this on DreamPress: DreamPress uses Nginx and “automatically forces HTTPS.”

Failed or blocked JavaScript, fonts, stylesheets, images, or API calls

Open DevTools > Network and reload the page.

Filter for failed requests and match them to the URLs shown in Issues.

Correct broken URLs, restore missing files, or remove calls to services you no longer use.

Update the responsible plugin or theme.

Ask the provider of an external service to correct its CORS or CSP configuration if its server is blocking the request.

Avoid “fixing” CORS by disabling browser security or broadly weakening a security policy.

Chrome’s Network tools can show total download time and individual resource requests, including which images, fonts, or JavaScript files are slowing a page.

Plugin or theme code causes the warning

Update WordPress, the active theme, and all plugins first.

Disable the suspected plugin temporarily and re-test the page.

Switch temporarily to a current default WordPress theme and re-test if the plugin test does not resolve it.

Re-enable items one at a time until the issue returns.

Replace the incompatible item or send the exact Chrome issue text and resource URL to its developer.

DreamHost notes that some plugins can interfere with correct caching and recommends testing a default theme to determine whether the theme is responsible. If server-level access is required, DreamHost’s documented isolation method is to rename /wp-content/plugins to /wp-content/plugins_OFF, test, then restore it and disable plugins individually.

Render-blocking or inefficient JavaScript

Identify the script URL in DevTools and determine whether it belongs to your theme, plugin, tag manager, ad service, or an embed.

Remove scripts that are unused on that page.

Load nonessential scripts later in the page or defer them only after testing all page functions.

Update or replace a plugin that adds unnecessarily heavy scripts site-wide.

Re-test forms, menus, checkout, analytics, and embedded content after every change.

DreamHost explains that a browser can stop rendering while it reads a JavaScript file, and that placing remote or local JavaScript near the bottom of the page can allow page content to render earlier.

Cookie or third-party service issue

Check whether the affected URL belongs to your own site or a third party such as analytics, chat, advertising, video, payment, or social media.

Update the integration or its WordPress plugin.

Remove the integration if it is no longer needed.

Ask the third-party provider for its current WordPress-compatible implementation if Chrome reports a cookie-policy or deprecation issue.

Test essential visitor actions with third-party cookies blocked, especially login, checkout, subscriptions, and embedded forms.

Important expectation
You may not be able to eliminate every Issue if it is generated by a third-party service you do not control. Prioritize issues that block page resources, weaken HTTPS/security, break key visitor journeys, or come from your own theme or plugins. Then document any remaining third-party issue and monitor the provider for an update.

Used resources
How to Optimize Your Site for Mobile
General WordPress Optimization Techniques
How to Fix Common SSL Issues in WordPress
Not Secure Warning in Web Browsers
Force Your Site to Load Securely With an .htaccess File
Managing WordPress Plugins
Fine Tuning Your WordPress JavaScript
How to Inspect a Website
