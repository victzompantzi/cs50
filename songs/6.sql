SELECT s.name FROM songs AS s JOIN artists AS a ON s.artist_id = a.id WHERE s.artist_id = (SELECT id FROM artists WHERE name = "Post Malone");
