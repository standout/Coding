# Staging servers

In general, we do staging deploys on **the same server** as production deploys
for smaller apps. The following things differ between production and staging:

# Domain convention

Use `staging-appname.standout.se` or `staging.realappdomain.com`

# Databases

Production databases is named `appname_production` and staging databases is
named `appname_staging`. They should have different user accounts and passwords
to prevent accidental overwrites.

Staging databases should be updated once per day with one of the following
options:

 a) An exact copy of production database (works well for small apps with
   non-sensitive info)
 b) A total reset of the database via a seed file.

The daily update does not fit all applications of course.

# Email

Staging server should never send out real e-mails to e-mail addresses in the
database. You can pick one of the following options:

 a) Always send all outgoing e-mail to a specific e-mail address
 b) Use something like [mailcatcher](http://mailcatcher.me)
 c) Use [letter opener web](https://github.com/fgrehm/letter_opener_web)

# Security

The staging app can be set to accept a master password for testing conveniences,
but the main app should never be accessible without a password. A simple solution
using HTTP BASIC AUTH should do just fine.

A self-signed SSL certificate is okay to use on staging servers.
