# FridgeMagnets
Your personal fridge, decorate it how you like!

## Inspiration
We wanted to create a space where people can showcase themselves, away from the hustle and bustle of social media pages. Taking inspiration from how families share their best memories by sticking them onto a fridge, we wanted to let users create their own personal fridge, where they can place colorful magnets, inspirational messages, and their favorite photos.

## What it does
Users are greeted with a login page, where they can register with a username and secure password.  Once logged in, users can access their personal fridges and edit them. Users can edit fridges by adding a decorative magnet or sticky note. All magnet positions are saved so that they remain in the same position when you reload. You can update and delete magnets, but only if you are authorized to do that (the user who created them). Actions are accompanied by satisfying feedback through responsive UI elements.

## How we built it
This app was built with a Flutter Web frontend, Flask backend, and SQLite database. The database stores fridges and magnets, and securely stores users. The backend includes CRUD endpoints for users, fridges associated with users, and magnets associated with fridges.

## Challenges we ran into
- Working with SQLite as first timers with no prior experience was quite difficult, since we were working with unfamiliar syntax.
- Learning how to properly handle endpoints was difficult, especially when dealing with things such as CORS and Bearer Tokens when connecting from external devices and maximizing security.
- We definitely underestimated the time it would take for some features, such as secure login.
- We spent a lot of time debugging and chasing errors that were ultimately due to a small issue somewhere else, which wasted a lot of time and caused us to not finish all the planned features.

## Accomplishments that we're proud of
- We created a working demo, complete with a login page, fridges, and fridge displays, with states saved properly, and ways to create, update, delete, and manipulate many different kinds of components, which is further than we thought we'd get.
- We successfully implemented database manipulation between the frontend and backend services, which was a daunting task for two first-time hackers in such a short time, especially through dealing with HTTP and all its quirks in detail.
- We came up with a pretty slick setup, where one person edits the backend and the other edits the frontend in real time, using services like Tailscale to connect multiple devices together for testing, even when we went home.

## What we learned
- Backend development using Flask and frontend development using Flutter for Web, with a lot of trial and error to teach the do's and don'ts.
- Secure password and token management using JWT and werkzeug cryptography.
- Relational database manipulation using SQLite, and proper handling of foreign keys.
- Permission management using tokens, so only authorized users can edit their fridges, while anyone can view them.

## What's next for FridgeMagnets
- We may consider finishing the project, adding the features we didn't have time for (user search, images on magnets) and making it the best (and coziest) it can be!
- We may also consider dockerizing and hosting this service, so everyone can enjoy it!
