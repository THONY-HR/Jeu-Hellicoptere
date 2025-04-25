CREATE DATABASE Helicoptera;
USE Helicoptera;
CREATE TABLE Coordonner (
    idCoordonner INT AUTO_INCREMENT PRIMARY KEY,
    typeCoordonner INT,
    x1 INT,
    x2 INT,
    y1 INT,
    y2 INT
);

INSERT INTO Coordonner (typeCoordonner, x1, x2, y1, y2)
VALUES 
    (1, 0, 60, 650, 670),   -- Point A
    (1, 740, 800, 650, 670),   -- Point B
    (0, 200, 250, 100, 800),   -- Obstacle 1
    (0, 350, 400, 100, 800),   -- Obstacle 2
    (0, 600, 650, 70, 800);     -- Obstacle 3

