# 2017-scouting-app
iPhone app for the viewing of data from Team 8's scouting system.

Team 8's 2017 Scouting System consists of three parts:
* Viewer App - iPhone app that allows viewing of raw and calculated pit and match scouting data pulled from Firebase, as well as match and ranking data pulled from The Blue Alliance for easy formulating of match strategies and picklists. Also includes QR code scanning for uploading raw match data to the server.
* Collection App - iPad app used by scouters in the stands to collect raw match data and submit it to the server via QR code scanning/uploading.
* Backend Server - Python program constantly running on a private server that receives match data, performs calculations on it, and submits it to Firebase and the viewer app.
