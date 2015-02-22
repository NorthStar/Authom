# Authom

Robust authentication system that fits different levels of security and products. Most importantly, it is intuitive to use for an average user.

Many of us are mobile developers. Many of us have written sketchy things. Some sketchiness came from the frameworks, some …er deliberate, I would say. Insecure design decisions are present everywhere in mobile apps and services, exposing end users to many exploits. 

So many app companies store all kinds of things from your purchasing history, your behavior with interfaces, to your behavior in other apps, social media tokens, your entire contact book, which by the way is giant because you allowed your own address book to sync from Facebook. The worst would be passwords. Passwords are broken, because no one knows how to use good keychain, yet so much of our infrastructure on mobile is either public or password-protected. On web, people compromise their internet identities and credit cards, but in mobile, people compromise their clothes, identity, blood, and credit cards. In other words, the mobile security space is a bleak Wild Wild West, and an average user is extremely likely to lose all privacy. So here is when Authom comes in, to empower the users with options to keep their privacy while being non-intrusive to their day-to-day lives.

Email addresses, credit card numbers can become public. They are keys that are hard to alter, so they tend to be comprisable.

Passwords, security question is what you know
Digits, code pushed to your phone, keeps track of what you have
Fingerprints are who you are (TouchID verifies that you own the current phone at hand)
Selfie-taking process verifies who you are & what you know & your state of mind (But I did this in money20/20 hackathon so I would not elaborate)

The focus here is consumers’ user experience. I want to be the person who gets it right


## Inspiration
After making (EmojiPass)[http://www.hackathon.io/p-face] where a selfie-taking process can be used to securely verify identity for payments, I have been thinking more and more about mobile security, specifically a better solution for users to secure their data while having a good experience.

## How it works
The Authom app is a demo of three-tiered security solution. I provided a minimalistic use case for each of them.


The most secure layer is EmojiPass, as linked above. The self-taking process, including speed of smile formation, phone tilting, and the face itself uniquely identifies but the right, personal emotion and expression. This is suitable for payments.


The second most secure layer is TouchID. Many private information is stored on phone, yet many 2FA services use a phone app to input a code. This makes no sense at all, given that a phone can be compromised, rendering the 2 factors parallel. The TouchID is orthogonal to having the physical device. Moreover, service providers don't have access to the actual fingerprints, just the fact that the user authenticated.

The easiest layer is single sign-on, implemented using Twitter Digits to associate a user's phone number with an account. The phone number is the best available public key for mobile, naturally, so the easiest identification ought to take advantage of that.

## Challenges I ran into
Making things pretty is rather hard.

No teammates.

Didn't know how to make it into a product, per se

## Accomplishments that I'm proud of
All the decisions regarding the security paradigm makes sense.

Finally making something that is innovative and useful in a hackathon.

## What I learned
The problem with security is complicated.

## What's next for Authom
A lot of documentation to get my idea through.

I would rather have a more comprehensive framework that is ready-to-use and saves developer hassle.
