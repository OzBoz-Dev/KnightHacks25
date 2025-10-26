# FridgeMagnets

## Inspiration
We wanted to create a space where people can showcase themselves, away from the hustle and bustle of social media pages. Taking inspiration from how families share their best memories by sticking them onto a fridge, we let users create their own personal fridge, where they can place colorful magnets, inspirational messages, and their favorite photos.

## What it does
Users are greeted with a login page, where they can register with a username and secure password.  Once logged in, users can access their personal fridges and edit them. Users can edit fridges by adding a decorative magnet, custom note, or picture, all saved and ready to go!.

## How we built it
This app was built with a Flutter Web frontend, Flask backend, and SQLite database. The database stores fridges and magnets, and securely stores users. 

## Challenges we ran into
- Working with SQLite as first timers with no prior experience was quite difficult, since we were working with unfamiliar syntax.
- Learning how to properly use endpoints was difficult.
- We definitely underestimated the time it would take for some features, such as secure login.

## Accomplishments that we're proud of
- We created a working demo, complete with a login page, fridges, and fridge displays, which is awesome!
- We successfully implemented database manipulation between the frontend and backend services, which was a daunting task for first-time hackers in such a short time.

## What we learned
- Backend development using Flask.
- Secure password and token management using JWT and flask_login.
- Relational database manipulation using SQLite, and proper handling of foreign keys.
- Permission management using tokens, so only authorized users can edit their fridges, while anyone can view them.

## What's next for FridgeMagnets
We may consider dockerizing and hosting this service, so everyone can enjoy it!
