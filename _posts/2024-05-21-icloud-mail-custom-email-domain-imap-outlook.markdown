---
published: true
title: iCloud Custom Email Domain - Configuration for Outlook Mobile
layout: post
tags: [apple, appleid, email, domain, outlook, imap, k-9, k9]
categories: [iCloud]
---

Since Google decided to [shut down the excellent free G Suite](https://support.google.com/a/answer/2855120) that I used for years I had to find an alternative. Google Workspace is ridiculously priced for a family domain and unfortunately Microsoft has also removed the option for personalized email addresses in [Outlook.com / O365 Family](https://support.microsoft.com/en-us/office/changes-to-microsoft-365-email-features-and-storage-e888d746-61e5-49e3-9bd1-94b88e9be988).

After sifting through numerous other alternatives I settled on Apple's [Custom Email Domain with iCloud Mail](https://support.apple.com/en-us/102540), pretty easy choice in the end since it's a lot of bang for the buck and easy to [setup](https://support.apple.com/guide/icloud/mma473945269).

The only little snag I ran into was setting up the mail account in my Outlook Mobile (Android). Setting it up as an iCloud provider was easy but then it automatically used my @icloud.com address and no option to change that to my custom address but after numerous tries I finally found the correct configuration via [IMAP](https://support.apple.com/en-us/102525).

### Apple ID App-specific Password

First you need to setup an app-specific password at [appleid.com](appleid.com) as described [here](https://support.apple.com/en-us/102654).

### Outlook Mobile Configuration

```
Email Address: daniel@example.com
Display Name: Daniel Wikar
Description:

IMAP Host Name: imap.mail.me.com
Port: 993
Security Type: SSL/TLS
IMAP Username: <your-account>@icloud.com
IMAP Password: <your-app-specific-password>

SMTP Host Name: smtp.mail.me.com
Port: 587
Security Type: StartTls
SMTP Username: <your-account>@icloud.com
SMTP Password: <your-app-specific-password>
```

Using StartTls as the Security Type for SMTP was the key in getting it to work.

Also confirmed to be working with the excellent [K-9 Mail](https://k9mail.app/) and should work with any third-party client supporting SSL/TLS + StartTls.