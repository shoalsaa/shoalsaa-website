# Website Succession Plan: Design and policy for handing over a website — and the secrets that run it

<!--Status: draft for discussion and adoption. This document contains no passwords, recovery codes, or secret locations. Those belong only in the vault and in the sealed break-glass material described inside. Review the placeholders in brackets and replace them before adoption. Amended 15 November 2026: the 24-hour helpline account is recorded as a known undocumented asset (Section 4.1), and role mailboxes for officers and committee chairs are added to the policy (Section 14).-->

## How to use this document

Sections 1–4 explain the problem and the design. Sections 5–9 give the recommended setup in enough detail to implement it. Sections 10–12 turn it into procedures a committee can follow under pressure. Section 14 is a short policy written so a sponsoring body can vote on it as-is. The appendices are fill-in templates — copy them, do not complete them in this document.

Shoals AA is used as the worked example because its shape is typical: a WordPress site, a hosting account, a domain, DNS, email, and off-site backups, all maintained by one person. Anywhere the text says [Organisation], [Maintainer], or [Service], another group can substitute its own names and keep the rest unchanged.

Words used carefully in this document: a credential is a username plus its proof — a password, passkey, hardware key, or recovery code. A secret is any credential material that must not be shared in plain text. The vault is the password manager or encrypted database where secrets live day to day. Break-glass access is the emergency route into the vault when the normal route has failed.

## 1  The problem: one person, two opposite failures

Most small websites do not fail because the technology is weak. They fail because exactly one person knows how to get in. That creates two opposite risks at the same time, and any honest plan has to solve both.

- **Lock-out** If the secrets are kept only in one person's head, memory, browser, or personal password manager, the organisation is locked out when that person is ill, dies, moves away, or simply stops answering. Recovery then depends on persuading each provider, one at a time, that the organisation is the real owner — a slow process that can fail entirely for the domain and hosting account, which control everything else.

- **Over-sharing.** If the secrets are instead shared loosely — one shared password, a spreadsheet, a note in a drawer — anyone who has ever had them keeps them forever. There is no way to remove one person, no record of who used what, and no clean rotation when roles change.

Administrator turnover makes this a certainty, not a contingency. In Alcoholics Anonymous service, roles nominally rotate about every two years, and often run longer in practice because suitably qualified volunteers are scarce. Experience — at district level and well beyond it — is that sponsoring organisations are rarely prepared for that handover. The maintainer, meanwhile, is frequently the only person who ever knew the full set of secrets, because building the site meant creating accounts no one else was present for.

The conflict is real: day-to-day security says share as little as possible, with as few people as possible. Succession says the organisation must be able to get in with certainty, even if the one person who knows everything cannot help. This plan resolves the conflict not by choosing one side, but by separating the two jobs — a shared vault for ordinary work, and a separate, sealed, split-custody route reserved only for catastrophe.

## 2  Design principles

**1.** Own, do not borrow. **The organisation owns the accounts; people are granted access. The domain, hosting, email, and backup accounts are registered to the organisation, under a role address it controls (for example <webservant@shoalsaa.org>), paid by the organisation — never to an individual's personal email or card.

**2.** No single point of failure. **At least two named people can reach every critical system at all times — the maintainer and a deputy — each with their own login, never a shared one.

**3.** Least privilege, in collections. **Each person sees only the collections their role needs. A content editor does not need the hosting credentials; a treasurer does not need the website vault.

**4.** Strong authentication by default. **Every critical account has phishing-resistant multi-factor authentication (MFA) where the provider supports it — a hardware security key or passkey in preference to an authenticator app, and an authenticator app in preference to text messages. This follows the direction of NIST Special Publication 800-63B on authenticator management.

**5.**  Recoverability is tested, not assumed. **Secrets are never the plan. Recovery codes, spare keys, and the break-glass route are set up in advance, stored apart from the things they protect, and tested. An untested recovery route is assumed not to work.

**6.** Leaving is a procedure. **When a person leaves a role, access is removed by name and the secrets that person knew are rotated by class (Section 11). Rotation is planned work, not an emergency improvisation.

**7.**If it is not inventoried, it does not exist. **The inventory (Section 5) is the source of truth. If an account is not in the inventory, it is not handed over, not backed up, and not rotated — which is why keeping the inventory current matters more than any single tool choice.

## 3  Roles and responsibilities

Succession fails when it is nobody's named job. The plan needs five roles. One person may hold two roles, but the maintainer and a break-glass custodian must never be the same person, and no role may be held by nobody.

Every role appointment is recorded in the organisation's minutes with a name and a start date. A role that exists only in a conversation does not survive the next rotation.

## 4  Scope: the systems a website actually depends on

A website is never one account. Losing any row in this table can lose the site, so the inventory and the vault must cover all of them. The Shoals AA column is an example to verify and complete, not a statement of current fact — confirm each entry against the current website manual before relying on it.

### 4.1  A worked example: the 24-hour helpline

The helpline is the sharpest illustration of this plan's problem, and it is worse than the website itself. The website has a maintainer who is present and engaged; the helpline is not a popular job, its position holders vanish frequently, and the account behind it was created by someone no one can now name. The published number — 256-415-7719 — belongs to a Google account, most likely Google Voice, whose owner and password are unknown, and getting the password to set up the answering list is a recurring challenge. If that account's credentials are lost entirely, the district cannot change who the number rings, cannot read its messages, and cannot prove to Google that it owns the number — the public phone line is stranded while still ringing.

Recovery, where it is possible at all, is through Google's own account recovery: the "Find your email" page will reveal the username for a phone number when the account holder's first and last name are supplied, if the number is attached to the account. That needs a name the district may no longer know. If recovery fails, the honest fallback is to obtain a new number under an account the district controls from the start — registered to a role mailbox, listed in the inventory, its credentials in the vault — and update the website and every listing that carries the old number. Either way, the lesson is the same: an account that is not inventoried, with its owner named and its credentials in the vault, is an account the organisation has already lost and does not yet know it.

The same reasoning applies to every officer and committee chair. District business conducted through personal email addresses leaves the district's correspondence, contacts, and account recoveries in the hands of whoever held the office, and they vanish with the holder. The recommendation is a district-owned role mailbox for every officer and committee chair — secretaryshoalsaa.org at minimum — registered to the office rather than the person, so the address and its contents move with the office at rotation. A role mailbox costs little (a further mailbox on the district's existing email hosting is of the order of $20 a year, against $84 a year per user for a Google Workspace seat) and it is what makes the rest of this plan enforceable: it is the address the accounts are registered to, the address password resets go to, and the address a successor inherits on day one.

## 5  The inventory: what must be recorded, and what must not

Create one inventory record per account, using Appendix A. Record the service, its purpose, the organisation role address used to register it, the account identifier (a username or account number is an identifier, not a secret), the role that owns it, who has access, what MFA is enrolled, when it renews and what it costs, and where its recovery codes live. Update the inventory in the same sitting as any change — a new plugin account, a moved backup, a changed card.

Store the inventory with the organisation's standing documents, with a copy in the shared document store and a printed copy held by an officer. Review it in full at every handover and at the annual drill, and spot-check it quarterly: pick three accounts at random and confirm the deputy can sign in to each one.

## 6  Recommended architecture: a hybrid vault

No single product solves both halves of the problem well, so the recommendation is a hybrid of two layers with different jobs. Either layer alone is a known failure: a cloud vault alone can lock the organisation out if its own recovery was never set up; an offline file alone is awkward for daily work and easy to let go stale.

- **Layer 1 — day-to-day.**An organisation vault in a reputable password manager, owned by the organisation, with named individual accounts for the maintainer and deputy and credentials grouped into collections by role (hosting and domain; website administration; email; backups and documents; finance-adjacent services). Day-to-day work happens here, sharing is by collection, and removing a person is a single administrative action.

- **Layer 2 — break-glass copy.**An encrypted offline copy of the critical collections — for example a KeePassXC database export, or the manager's encrypted export — held on two encrypted USB drives in two separate secure locations. This copy is the fallback if the cloud vault is unreachable, the subscription lapses, or the provider itself is the problem. It is refreshed quarterly and after every handover, and its passphrase is protected by the break-glass arrangement in Section 8, never stored inside Layer 1 itself.

Two structural rules make the hybrid work. First, there must always be at least two organisation owners or administrators of the Layer 1 vault, so no one person can lock the others out or be the only route to recovery — 1Password's own recovery guidance makes the same point for family organisers, who cannot recover their own accounts. Second, the credentials for the vault itself, for the organisation email that resets it, and for the backup store must not live only inside the vault they protect; that circularity is the most common way small organisations lock themselves out permanently.

## 7  Choosing the vault: how the main options differ

The products below all encrypt competently. They differ where it matters for succession — in how a second person is let in during an emergency, and in what happens when the main account holder cannot act. Prices and plan gates change often and are deliberately not quoted as commitments here; verify the current plan before purchase, because the recovery feature is exactly the feature most often paywalled.

Recommendation for a typical district-sized site: Bitwarden on a paid organisation plan as Layer 1, because its timed Emergency Access matches the incapacity case most directly and its collections match role-based sharing, plus a KeePassXC Layer 2 copy for provider-independent recovery. An organisation already standardised on 1Password can reach an equivalent position with two organisers, completed Emergency Kits in sealed custody, and the same Layer 2 copy. What matters is the recovery design, not the brand.

## 8  The top-level secret: solving the problem that recurses

Every vault has a master password, and every plan eventually asks the same awkward question: who knows that, and where is it written? Putting it in an envelope in a drawer recreates the original problem one level up — one location, one holder, no record of opening. The answer is to split the secret so that no single person or place holds it, while enough trusted holders together can always rebuild it.

### Option A — split custody with sealed envelopes (simple, recommended default)

Divide the recovery material into two halves that are useless alone: for example, the vault master password in one sealed, signed, tamper-evident envelope, and a required second factor — a key file on a USB drive, or the printed recovery codes — in a second envelope, held by a different custodian in a different building. Opening requires both custodians and a minuted authorisation from the sponsoring body. Each envelope is signed across the seal, dated, and logged in Appendix B; any envelope found opened or replaced triggers an immediate rotation of everything it protects.

### Option B — threshold sharing, 2-of-3 (stronger, slightly more work)

Shamir's Secret Sharing, published by Adi Shamir in 1979, splits a secret into n shares such that any k shares reconstruct it and fewer than k reveal nothing at all — not a fragment, not a clue. A 2-of-3 split across three officers means any two can recover the master password if one custodian is unavailable, while no custodian alone can use or leak it. A 3-of-5 split suits a larger committee. If this option is chosen, generate the shares offline, on a computer not connected to a network, print or write each share separately, seal each one as in Option A, and rehearse reconstruction at the annual drill with a dummy secret first. Record only the scheme (for example “2-of-3, three custodians”) in the inventory — never the shares, and never all custodians' locations in a document stored with a share.

### Hardware keys: plan for three, enrolled in advance

A hardware security key such as a YubiKey cannot be copied — by design, a backup key is not a clone but a second key registered separately on each account. The accepted practice is therefore to buy and register the spares before they are needed:

- **Key 1 —**the maintainer's daily key, carried by the maintainer;

- **Key 2 —**a backup key registered on the same critical accounts, stored securely apart from Key 1;

- **Key 3 —**an organisation key registered on the same accounts, held by a custodian or in the organisation's safe, for succession.

Register every key on every critical account at setup time, test each key on its own before relying on it, and label keys by number only — never with account names. Choose the model by need: a basic FIDO2 / WebAuthn security key (USB-A or USB-C, with NFC if phones are used) covers most website, email, and vault logins; the fuller YubiKey 5 series adds one-time-password, smart-card (PIV), and OpenPGP functions, which matter only if the organisation actually uses them — for example to unlock a KeePassXC database. Budget for keys as organisation property, record their serial or inventory numbers (not their secrets — there are none to record) in Appendix A, and remember that a spare key sitting unregistered in a drawer protects nothing.

## 9  Day-to-day security controls

- **Passwords.**Unique, generated passwords (at least 16 characters, or a multi-word passphrase for the few that must be typed) for every account, stored only in the vault. No reuse between the domain, hosting, email, and vault accounts — ever.

- **Multi-factor authentication.**MFA on every account that offers it, hardware key or passkey preferred. Where a provider offers only an authenticator app, enrol at least two devices or save the setup securely in the vault item so a lost phone is an inconvenience, not a lock-out.

- **Domain.**Keep the registrar transfer lock on at all times except during a planned transfer, auto-renewal on, and registration details in the organisation's name with a role email address. Remember the limit of the lock: it stops transfers by outsiders, not by someone signed in to the registrar account — which is why that account's own security comes first.

- **Website.**Individual administrator accounts in the CMS for each person; no shared “admin” login. Remove or downgrade accounts in the same week a role ends. Keep plugins and themes minimal, listed in the inventory, and updated by a named owner.

- **Backups.**Backups run automatically to off-site storage the host does not control, and a restore is actually performed and timed at least once a year. A backup that has never been restored is a hypothesis. Keep at least one backup copy reachable without the hosting account.

- **Handling.**No secrets in email, chat, shared documents, or code. If a secret is ever sent that way by accident, treat it as exposed: rotate it and note the incident in the drill log.

- **Alerts.**Critical alerts from the host and registrar (expiry, transfer, login, billing failure) go to a role address monitored by at least two people, not to the maintainer alone.

## 10  Succession procedures: three different events

### 10.1  Planned rotation — the normal case

Begin at least 60 days before the change where possible. The outgoing and incoming maintainers work through Appendix C together: the incoming maintainer is added everywhere with their own accounts, enrols their own MFA and hardware keys, and performs the core tasks once while the outgoing maintainer watches — sign in to the host, restore a backup to a test location, publish a change, and open the vault collections they will own. Only after that demonstration is the outgoing maintainer's access removed, and the rotation in Section 11 carried out. Record completion, with both signatures, in the minutes.

### 10.2  Unplanned absence — illness, incapacity, or death

**1.**An officer confirms the maintainer cannot act, and the sponsoring body minutes an authorisation naming an acting maintainer (normally the deputy). Sympathy and urgency do not replace that record — it is what providers and custodians will later rely on.

**2.**If the deputy already has working access — the intended position — the deputy simply steps up, and break-glass material is not touched. Note the date in the log and move to step 5.

**3.**Only if normal access has failed do the custodians meet, verify the minuted authorisation, open the sealed material together, and log the opening in Appendix B in each other's presence. No custodian opens anything alone, and no share is photographed or sent electronically.

**4.**The acting maintainer signs in, immediately sets a new vault master password and new recovery material, re-seals fresh break-glass shares with the custodians, and confirms the site, email, and backups are operating.

**5.**Within 30 days, carry out the full rotation in Section 11, appoint a new deputy, and report to the sponsoring body what was opened, what was changed, and what remains outstanding. Where the maintainer has died, the organisation should also expect individual providers to ask for evidence of its authority; the minutes, the inventory showing organisational ownership, and role-address registration are what make those conversations short.

### 10.3  Contested departure or removal

If a maintainer is removed, or leaves in dispute, speed and order matter more than completeness. A second vault owner first removes that person's vault access and CMS account, then the organisation — working from the inventory, in this order — secures the email account, the vault, the domain registrar, DNS, and hosting, rotating each password and revoking sessions and keys as it goes, and only then works down the remaining accounts. Do not announce the sequence to the departing maintainer before the first five systems are secured. Afterwards, complete the full rotation, review access logs where providers offer them, and minute what was done. This procedure is also why Principle 2 matters: it can only be executed by a second owner who already exists.

## 11  Handover checklist and what to rotate

A handover is complete when the incoming maintainer has signed in alone, unaided, to every critical system, and the items below have been dealt with. Rotating literally everything is impractical and invites mistakes; rotating nothing leaves the departed maintainer — however trusted — holding live keys. Rotate by class:

The completed checklist (Appendix C) is signed by both parties where possible, or by the acting maintainer and an officer in an unplanned succession, and filed with the minutes. Unchecked items stay on the sponsoring body's agenda until they are closed — they do not quietly expire.

## 12  Drills, review, and keeping the plan alive

- **Quarterly (30 minutes).**the deputy signs in to three randomly chosen critical accounts; vault owners and custodians are confirmed still in role; renewal dates and payment method are checked; alerts are confirmed reaching two people.

- **Annually (half a day).**a full tabletop walk-through of Section 10.2, plus a live test: restore the site backup to a test location, open the Layer 2 offline vault copy on an offline computer, and — using a dummy secret — reconstruct a split share if Option B is in use. Inspect every sealed envelope for tampering without opening it. Replace any envelope whose condition is in doubt, and re-make its contents.

- **At every rotation.**a full inventory and access review: every account in Appendix A confirmed to exist, needed, and correctly owned; every person with access confirmed still in role; this plan re-read and amended for anything that changed.

Record each drill in Appendix D: date, who took part, what was tested, what failed, and what was fixed. A failed drill is the system working — it found the broken recovery route while the maintainer was still there to repair it. Report drill completion, not drill detail, to the sponsoring body; the detail stays with the custodians.

## 13  Risks, limits, and honest trade-offs

- **Trust remains.**Split custody reduces risk; it does not abolish trust. Enough custodians acting together can always open the break-glass material — that is its purpose. Choose custodians for probity, minute their appointment, and keep the threshold high enough that collusion is a deliberate, visible act.

- **Terms and law.**A password manager's emergency feature governs access to that vault only. It does not compel any other provider to recognise the successor, and using another person's personal credentials can breach a provider's terms. This is a further reason to register accounts to the organisation under role addresses with named individual logins, rather than in the maintainer's personal name.

- **Change.**Providers' account-recovery processes, plan features, and prices change. Any step in this plan that names a product feature must be re-verified at the annual review; a feature that was present at adoption may be paywalled, renamed, or removed later.

- **Physical loss.**Paper burns, USB drives fail, and people move house. Two locations for Layer 2, inspected annually, is the minimum; a plan held in one building is a plan for every scenario except a fire in that building.

- **Not legal advice.**This document is an operational design, not legal advice. Questions of authority after a death, of organisational ownership of assets, and of any employment or fiduciary duty should be put to the organisation's own advisers in its own jurisdiction.

## 14  Policy for adoption

The following statements are drafted so a sponsoring body can adopt them by motion, filling the brackets once. Everything before this section is the reasoning and method behind them.

**1.**All accounts used to register, host, operate, back up, or pay for the organisation's website are the property of [Organisation], registered under an organisation role address, and listed in the website inventory.

**2.**No critical system shall have fewer than two named individuals with working administrative access. The maintainer shall appoint, and the body shall minute, a deputy maintainer at all times.

**3.**All website credentials shall be held in the organisation's approved password vault, in role-based collections. No website secret shall be stored solely in a personal password manager, browser, document, or memory.

**4.**Multi-factor authentication shall be enabled on every account that supports it, with hardware security keys registered in accordance with the succession plan: a daily key, a backup key, and an organisation key held in custody.

**5.**Break-glass recovery material for the vault shall be held in split custody by [two / three] custodians who are not the maintainer, under seal, and may be opened only on a minuted authorisation of the body, in the presence of at least two custodians, with the opening logged.

**6.**An offline encrypted copy of the critical vault collections shall be maintained in two separate secure locations, refreshed quarterly and after every handover.

**7.**On any change of maintainer — planned, unplanned, or contested — the handover checklist shall be completed and the credentials rotated by class as set out in the succession plan, and completion shall be reported to the body.

**8.**The deputy shall perform a quarterly access check and the custodians and maintainer shall conduct an annual recovery drill, including a tested backup restore. Drill completion shall be reported to the body.

**9.** This policy shall be reviewed at every maintainer rotation and at least annually.

**10.**Every officer and committee chair shall conduct district business through a district-owned role mailbox (for example <secretary@shoalsaa.org>), registered to the office rather than the person, so the address and its contents move with the office at rotation. At minimum <secretary@shoalsaa.org> but preferably every officer and committee chair should have an address at shoalsaa.org. Note that area uses this syle address for all its officers and committee chairs, we recommend shoasaa.org because it is a less expensive solution for us.

## Appendix A  Inventory template — one row per account

Copy this table into a spreadsheet or document held with the organisation's standing papers. No secrets in any column.

## Appendix B  Break-glass custody log

One log, held by the sponsoring body's secretary — not stored with any envelope or share. Record creation, inspection, opening, and re-sealing. Never record the contents.

## Appendix C  Handover sign-off checklist

Outgoing: [name]  •  Incoming: [name]  •  Date started: [date]  •  Date completed: [date]. Tick each item only when the incoming maintainer has done it unaided.

- Inventory (Appendix A) reviewed, corrected, and re-filed.

- Incoming maintainer added — own accounts — to vault (as owner), registrar, DNS, hosting, CMS, email admin, and backup storage; own MFA and hardware keys enrolled and tested.

- Incoming maintainer has signed in alone to every critical system.

- Backup restore performed by the incoming maintainer to a test location and timed.

- A real content change published and reversed by the incoming maintainer.

- Layer 2 offline vault copy refreshed; superseded copies destroyed.

- Break-glass material re-made / re-sealed with custodians; custody log updated.

- Rotation by class (Section 11) completed; outgoing access removed everywhere and verified.

- Renewal dates, payment method, and alert recipients confirmed with the treasurer.

- Open issues, quirks, and “what I wish I had known” written down and filed with the manual.

- Completion reported to and minuted by the sponsoring body.

<*Signed
Outgoing: __________________Incoming: ______________________Officer: ______________________*>

## Appendix D  Drill and review log

## Appendix E  Adapting this plan to another project

For a shared-document project, a newsletter, a meeting-list service, or any other shared digital asset, keep Sections 1–3, 5, and 8–14 unchanged and replace only the scope table in Section 4: list whatever the asset depends on — the document store, the mailing-list provider, the payment account, the social accounts — in place of the website layers. The failure this plan prevents is identical in every case: the asset outlives the person who set it up, and the organisation discovers too late that “access” was a person, not a property of the organisation. If a project is small enough that a full vault feels heavy, keep the minimum viable version: an organisational role email, two named administrators, one shared vault or one KeePassXC database, sealed split-custody recovery, and one tested restore a year. Do not drop below that floor.

## Sources and further reading

Product features and procedures were checked against the providers' own documentation in November 2026. Re-verify before relying on any named feature, as plans and gates change.

- Bitwarden Emergency Access — Bitwarden Help Center. <https://bitwarden.com/en-gb/help/emergency-access.pdf>

- 1Password Recover accounts for family or team members — 1Password Support. <https://support.1password>.com/recovery/

- NIST. SP 800-63B, Authentication and Authenticator Management — National Institute of Standards and Technology. <https://pages.nist.gov/800-63-4/sp800-63b.html>

<!--General background drawn on for the handover, domain-ownership, hardware-key backup, KeePassXC sharing, and Shamir threshold-sharing sections: ICANN material on registrant ownership, registrar transfer locks and locked domains; Yubico and FIDO2 guidance that security keys cannot be cloned and spares must be registered in advance; KeePassXC documentation on database encryption, key files and KeeShare; and Adi Shamir, “How to Share a Secret,” Communications of the ACM, 1979. Where a secondary summary and a provider's own page disagreed — notably on whether Bitwarden Emergency Access is available on the free plan — this document follows the provider's current documentation: it is a paid-plan feature for the grantor.-->

>The one-sentence version: The organisation — not any one person — owns every account; at least two named people can always get in; and the way back in when the main maintainer cannot act is written down, sealed, split between custodians, and tested once a year.

>Design test: Ask of any proposed arrangement two questions.
(1) If the maintainer were unreachable tonight, could two named officers restore the site this week using only what is written down and >sealed?
(2) If any one helper left on bad terms tomorrow, could the organisation cut off that person's access within a day, without rebuilding everything? A plan that fails either question is not finished.

| Role | Who (example) | Responsibilities |
| --- | --- | --- |
| Sponsoring body | District committee / officers | Owns the accounts and this policy; approves custodians; receives drill and audit reports; authorises break-glass use in an emergency. |
| Maintainer | Webservant / web-committee chair | Day-to-day operation; keeps the inventory and vault current; trains the deputy; initiates planned handover. |
| Deputy maintainer | Named second administrator | Has own admin access everywhere critical; performs at least one real task per quarter so access stays live; first successor. |
| Break-glass custodians (2–3) | Trusted officers, not the maintainer | Each holds one sealed share or envelope (Section 8); produce it only under the conditions in Section 10; attend the annual drill. |
| Treasurer / payer | Organisation treasurer | Pays for domain, hosting, vault and keys from organisation funds; confirms renewals; holds no website secrets by virtue of paying. |

| Layer | Why it is critical | Shoals AA example — verify |
| --- | --- | --- |
| Domain registration | Controls the name itself; loss here loses everything below it. | shoalsaa.org — registrar of record to be confirmed in the inventory |
| DNS | Directs the name to the site and email; can silently redirect both. | Nameservers point to Cloudflare (per website manual) |
| Hosting provider | Holds the site files, database and panel access. | DreamHost — shared hosting account |
| Website CMS | Day-to-day administration of content and plugins. | WordPress — administrator accounts, update and backup plugins |
| Site email | Receives password resets for almost everything else. | webservant&#64;shoalsaa.org and any role mailboxes |
| 24-hour helpline | The published contact number; callers reach the answering list. Whoever controls this account controls the district's public phone line. | Google account behind 256-415-7719 (likely Google Voice) — owner and password currently UNKNOWN; see Section 4.1 |
| Off-site backups & documents | The only route back after deletion, corruption or host failure. | WPvivid backups to Dropbox; manual and documents in shared storage |
| Password vault itself | Holds all of the above; its own recovery must be planned separately. | To be selected — see Sections 6–7 |
| Analytics, forms, maps, social | Often registered personally and forgotten until they break. | List each one found; close or transfer the rest |

| Never in the inventory: No passwords, no recovery codes, no hardware-key PINs, no answers to security questions, and no statement of where the sealed break-glass envelopes are kept beyond naming their custodians. The inventory is a map, and a map is safe to share with the committee. The secrets themselves live only in the vault; the way into the vault in a catastrophe lives only in split custody (Section 8). |
| --- |

| Option | Emergency / recovery model | Watch out for |
| --- | --- | --- |
| Bitwarden (organisation) | Emergency Access: a trusted contact requests access; after a waiting period you set, they receive View or Takeover access unless you decline. Collections suit role-based sharing well. | Emergency Access requires a paid (Premium or paid organisation) grantor account — it is not on the free plan. The contact needs their own Bitwarden account. Takeover replaces the master password and removes existing two-step methods, so treat it as a full handover, not a peek. |
| 1Password (Families / Business) | No timed emergency-access feature of the Bitwarden kind. Recovery is by a family organiser or team administrator, who starts recovery for a member; the member then sets a new password and Secret Key. The printed Emergency Kit (sign-in address, email, Secret Key, space for the password) is the offline fallback. | An organiser cannot recover their own account — appoint at least two organisers. The Emergency Kit is powerful paper: whoever holds a completed kit may have most of what sign-in needs, so store it like a key, not like a form. |
| Proton Pass | Sharing by vault; account recovery depends on the wider Proton account's recovery settings and any recovery material saved in advance. | Confirm, before relying on it for succession, exactly how a second person gains access if the account holder cannot act — do not assume a Bitwarden-style timed emergency feature exists. |
| KeePassXC (offline) | A single encrypted database file (AES-256 / ChaCha20, Argon2id key derivation). Whoever has the file, its passphrase, and any required key file or hardware key can open it. KeeShare can sync selected groups to separate shared files. | There is no server, no account recovery, and no emergency feature at all — which is its strength offline and its weakness socially. Simultaneous editing of one shared file can lose changes; use one editor at a time or KeeShare, keep versioned backups, and plan the passphrase's custody explicitly (Section 8). |

| Rule that prevents the classic lock-out: Recovery codes for each critical account are printed, sealed with the break-glass material, and stored apart from both the daily key and the account passwords. Email and the vault come first: whoever controls the organisation email can reset much of the rest, so its recovery route is tested before all others. |
| --- |

| Class | Action at every handover |
| --- | --- |
| Vault | Incoming owner confirmed; outgoing owner removed; new master password set by the incoming maintainer if they are taking over a shared account (prefer instead: each person keeps their own account and only ownership changes). Break-glass shares re-made and re-sealed. |
| Domain, DNS, hosting, email admin | Passwords changed; MFA re-enrolled to the incoming maintainer's keys; sessions revoked; recovery addresses confirmed as role addresses. |
| CMS administrators | Outgoing admin account removed or downgraded; incoming admin verified; any shared or dormant accounts closed. |
| Backups and document storage | Access granted by name to the incoming maintainer and removed from the outgoing one; restore tested; Layer 2 offline copy refreshed and old copies destroyed. |
| API keys, tokens, plugin licences | Re-issued or transferred where the provider allows; at minimum, inventoried and their owner updated. Tokens the outgoing maintainer created personally are replaced. |
| Lower-risk content accounts | Transferred by name; passwords changed at the next quarterly review if not changed at handover, and sooner if there is any concern. |

| Service / account | Purpose & owner role | Registered to / renews | Access & MFA |
| --- | --- | --- | --- |
| [e.g. Domain registrar — account ID] | [Domain — Maintainer] | [Organisation role email / date / cost] | [Maintainer + Deputy / hardware key] |
| [Hosting panel] | [Hosting — Maintainer] | [Role email / date / cost] | [Names / MFA method] |
| [DNS provider] | [DNS — Maintainer] | [Role email / date / cost] | [Names / MFA method] |
| [CMS admin accounts] | [Website — Maintainer] | [Site URL / —] | [Each admin by name / MFA method] |
| [Site email admin] | [Email — Maintainer] | [Role email / date / cost] | [Names / MFA method] |
| [Role mailboxes — secretary@, chair@, …] | [District business email — each officer] | [Organisation domain / date / cost] | [Office holders by role / MFA method] |
| [24-hour helpline — Google account] | [Helpline answering list — Hotline coordinator] | [Google account behind the published number / —] | [Names / MFA method] |
| [Backup storage] | [Backups — Deputy checks] | [Role email / date / cost] | [Names / MFA method] |
| [Password vault] | [All credentials — Two owners] | [Organisation account / date / cost] | [Owners by name / keys enrolled] |
| [Hardware keys — serials] | [MFA — Custodians] | [Purchased by organisation / date] | [Key 1 / 2 / 3 — holder role only] |
| [Other: analytics, forms, licences] | [Purpose — Role] | [Role email / date / cost] | [Names / MFA method] |

| Date | Item (envelope / share no.) | Action & authorisation | Custodians present / signatures |
| --- | --- | --- | --- |
| --- | --- | Created / inspected / opened / re-sealed — minute reference | --- |

*End of second-pass draft. Open decisions for the adopting body: (1) vault product and plan; (2) break-glass Option A or B, and the custodians' names; (3) who the deputy is today; (4) the date of the first drill; (5) role mailboxes for officers and committee chairs (<DCM@shoalsaa.org>, <secretary@shoalsaa.org> along with the existing  <webservant@shoalsaa.org> at minimum) — for decision at a district meeting.*  
